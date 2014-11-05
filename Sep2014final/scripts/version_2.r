#
# Function performs the propositionalization of relational datasets. It adds attributes representing the network
# properties of the dataset. In particular, the dataset computes, for each node representing a data object:
# - degree of the node
# - closeness of the node
# - betweenness of the node
# - transitivity of the node

library(infotheo)
library(discretization)
library(sqldf)
library(igraph)
library(vegan)


#discList -optional parameter, list with attributes to discretize numbers ex. list(5,6), list()
#discInteger - bool paremeter, indicating if integers are to be discretized along with continuous parameters  
propositionalize <- function(source.dir = getwd(), source.name, output.dir = getwd(), output.name, discList, discIntegers){


  # read the input data in CSV format (assume that the label is the last attribute)
  source.file <- paste(source.dir, source.name, sep = "/")
  data <- read.csv(source.file, header=TRUE,na.strings=c("?","NA",""))
  
  data.discretized <- data.frame(data)

  # discretize all columns in the input dataset using the chi merge discretization and add categorical columns not changed
  nrCol <- ncol(data)
  disc <- data["label"]
  # add an ID column to the data frame
  id <- 1:nrow(data)
  categ <- id
  
  while (nrCol >=1){
  nrCol <- nrCol -1
	  if(length(discList)==0){
		if(is.numeric(data[,nrCol]) && (!is.integer(data[,nrCol]) || discIntegers)) #
			disc <- cbind(data[nrCol],disc)
		else
			categ <- cbind(categ, data[nrCol])
		}
		else{
		if(nrCol %in% discList)
			disc <- cbind(data[nrCol],disc)
		else
			categ <- cbind(categ, data[nrCol])
		
		}
    }
  if(ncol(disc) >1){
    disc=chiM(disc,alpha=0.1) # function works properly only when all attributes in argument are numeric
    data.discretized <- cbind(categ,disc$Disc.data)}
  else
    data.discretized <- cbind(categ, disc)
  colnames(data.discretized )[1] <- "id"
  
  
  # get the number of all attributes
  num.attributes <- length(names(data.discretized))

  # create a join of data frames
  join <- sqldf("SELECT * FROM 'data.discretized' df1 JOIN 'data.discretized' df2 ON df1.id < df2.id")
  
  # order columns alphabetically by name
  join.ordered <- join[, order(names(join))]

  count.common.values <- function(x) {
    width <- length(x)/2
    count <- 0
    for (i in 1:width) {
      if(!is.na(x[2*i-1]) && !is.na(x[2*i]) && x[2*i-1] == x[2*i])
        count <- count+1
    }
    count
  }
  
  # create a vector containing, for each pair of objects, the number of common values between objects
  # and merge this vector with the data. Then, remove pairs of objects that have no values in common
  common.values <- apply(join.ordered, 1, count.common.values)
  edges <- sqldf("SELECT df1.id, df2.id FROM 'data.discretized' df1 JOIN 'data.discretized' df2 ON df1.id < df2.id")
  edges <- cbind(edges, common.values)
  edges <- edges[common.values > 0, ]

  # create a undirected  graph from the edges data frame and set the number of common values as the weight of each edge
  g <- graph.data.frame(edges, directed=FALSE)
  E(g)$weight <- edges[,3]

  # compute statistics on the graph
  clustering.coefficient <- transitivity(g, type="weighted")
  degree <- graph.strength(g, loops = FALSE)
  degree <- decostand(degree, "range")
  colnames(degree)[1] <- "degree"

  print (cat("density ", graph.density(g, loops=FALSE)))
  # create a data frame with all network statistics
  network.attributes <- cbind(degree,clustering.coefficient)
  names(network.attributes) <- c("degree","clustering coefficient")
  
  
  # create a linear model to compute the weight of each instance
  data.model <- cbind(data.discretized["label"], network.attributes)
  linear.model <- lm(label ~ ., data = data.model)
  final.model <- step(linear.model)
  
  # read the names of attributes in the model
  # remove the first attribute of the model which contains the intercept
  model.names <- names(final.model$coefficients)
  intercept <- model.names[1]
  
  model.names <- model.names[2:length(model.names)]
  
  # compute the weight based on the model by computing residuals and setting the weight of objects
  # to be high where the residuals are low (i.e. for objects which label can be predicted using network attributes)
  weight <- 0

  for (i in 1:length(model.names)) {
	name <- model.names[i]
	newWeight <- final.model$coefficients[name] * network.attributes[, c(name)]
    weight <- weight + newWeight
	print(final.model$coefficients[name])
	print(cat("max ",max(newWeight), "min ", min(newWeight), "mean ", mean(newWeight)))
  }
  weight <- weight + final.model$coefficients[intercept]
  residuals <- abs(weight - data.discretized["label"])
  weight <- 1 / (residuals + 1)

  
  # write out the result
  output.file <- paste(output.dir, output.name, sep = "/")
  colnames(weight)[1] <- "weight"
  #names(weight)<- "weight"
  data.output <- cbind(data,weight)#.discretized
  
  write.csv(data.output, file = output.file,  row.names=FALSE)
  alarm()
}
