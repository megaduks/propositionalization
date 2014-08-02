add_new_attributes <- (function(path1,path2,path3){
library(infotheo)
library(discretization)
myData <- read.csv(path1, header=T)
myDataDisc <-myData
# discretization by entropy
#myDataDisc <-mdlp(myData)$Disc.data
# discretization by equalwidth
for (i in 1:(ncol(myData)-1))
	myDataDisc[i] <- discretize(myData[i],"equalwidth",sqrt(length(unique(as.vector(unlist(myData[i]))))))
write.csv(myDataDisc,file = path2, row.names=F)


myDataDisc <- read.table(path2, header=T, stringsAsFactors=TRUE,sep=",")
id <- 1:NROW(myDataDisc)
myDataDisc <- cbind(id, myDataDisc) 
for (c in 2:(ncol(myDataDisc)-1)){
	myDataDisc[,c]= as.integer(myDataDisc[,c])
}

library(sqldf)
numOfAttributesOryg <- length(names(myDataDisc))
joinedTables <- sqldf("select * from myDataDisc m1, myDataDisc m2 where m2.id > m1.id")
myTable <- 1:nrow(joinedTables)
for(i in 1:nrow(joinedTables)) {
	c <- 2
	sum <-0
	while(c < numOfAttributesOryg){
		if(joinedTables[i,c]==joinedTables[i,c+numOfAttributesOryg])
			sum <- sum + 1		
		c <- c + 1
	}
	myTable[i] <- sum
}

library(igraph)

library(tnet)
id1 <- joinedTables[,1]
id2 <- joinedTables[,numOfAttributesOryg+1] 
edges <-c(as.data.frame(id1),as.data.frame(id2),as.data.frame(myTable)) 

edges <-c(as.data.table(id1),as.data.table(id2),as.data.table(myTable))
edges <- as.data.table(edges)
edges <- sqldf("select * from edges where myTable > 0") 
g <- graph.data.frame(edges, directed=F)
E(g)$weight <- edges[,3]


transitivity_weighted = transitivity(g, type="weighted")
edges2 <- symmetrise_w(edges, method="MAX")
degree_w <- degree_w(edges2,measure="output", type="out", alpha=1)
degree <- degree_w [,"output"] #/nrow(myData)
edges[,3] <- 1/edges[,3]
betweenness = betweenness(g, v=V(g), directed = F, normalized = F)
write.csv(c(myData,as.data.table(transitivity_weighted),as.data.table(degree),as.data.table(betweenness)),path3, row.names=F)
})
