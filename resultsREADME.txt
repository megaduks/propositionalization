Opis zbiorów danych 
fertility (unbalanced dataset) 
100 przypadków (12% klasa 1, 88% klasa 0) 
Zdyskretyzowano jedynie 2 i 9 atrybut

Step:  AIC=-251.91
label ~ degree + clustering.coefficient

                         Df Sum of Sq     RSS     AIC
<none>                                 7.5843 -251.91
- clustering.coefficient  1   0.17032  7.7546 -251.69
- degree                  1   2.82681 10.4111 -222.23
      degree 
-0.003461196 
clustering.coefficient 
529.8686 
			  

hepatitis (unbalanced dataset)  
155 przypadków ( 20% klasa 0, 80% klasa 1)
Przestawiono atrybut klasy na koniec.
Zdyskretyzowano jedynie 14 i 17 atrybut

Step:  AIC=-326.27
label ~ degree

         Df Sum of Sq    RSS     AIC
<none>                18.405 -326.27
- degree  1    6.9885 25.393 -278.38
     degree 
0.001009801 


bands (balanced dataset)

wynik bands1.net zdyskretyzowano wszystkie atrybuty ciagłe

Step:  AIC=-892.88
label ~ degree + betweenness

              Df Sum of Sq    RSS     AIC
<none>                     102.20 -892.88
- betweenness  1    11.803 114.01 -835.87
- degree       1    24.862 127.07 -777.31
       degree 
-0.0001901313 
betweenness 
0.004170923  

wynik bands2.net zdyskretyzowano wszystkie atrybuty liczbowe
Step:  AIC=-860.38
label ~ degree + betweenness

              Df Sum of Sq    RSS     AIC
<none>                     108.54 -860.38
- betweenness  1    9.6163 118.16 -816.54
- degree       1   19.1674 127.71 -774.57
      degree 
-0.000166757 
betweenness 
0.005444356 
			 

winequality-red (multiclass unbalaned dataset)
1600 instancji 9 attrybutów


wynik winequality-red2.net zdyskretyzowano wszystkie atrybuty liczbowe
Step:  AIC=-1140.86
label ~ degree + clustering.coefficient

                         Df Sum of Sq    RSS      AIC
<none>                                780.47 -1140.86
- degree                  1     1.703 782.17 -1139.38
- clustering.coefficient  1   158.354 938.82  -847.48
      degree 
7.175994e-05 
clustering.coefficient 
             -33.06292 
			 

breastCancerWisconsin (unbalanced dataset)
   Benign: 458 (65.5%) 0
   Malignant: 241 (34.5%) 1 (złośliwy)

Start:  AIC=-2402.1
label ~ degree + betweenness + clustering.coefficient + bonacich

wynik breastCancerWisconsin1.net zyskretyzowanno wszystkie atrybuty ciagle
                         Df Sum of Sq    RSS     AIC
<none>                                22.173 -2402.1
- betweenness             1    0.2339 22.406 -2396.8
- bonacich                1    0.5877 22.760 -2385.8
- clustering.coefficient  1    6.5103 28.683 -2224.2
- degree                  1   21.0780 43.251 -1937.1
       degree 
-0.0002632699 
 betweenness 
3.146003e-05 
clustering.coefficient 
              -3.25064 
    bonacich 
-0.002969161 


wynik breastCancerWisconsin2.net zyskretyzowanno wszystkie atrybuty liczbowe
label ~ degree + betweenness + clustering.coefficient + bonacich

                         Df Sum of Sq    RSS     AIC
<none>                                26.016 -2290.4
- betweenness             1     0.158 26.175 -2288.1
- bonacich                1     0.347 26.363 -2283.1
- clustering.coefficient  1     2.535 28.551 -2227.4
- degree                  1    32.477 58.493 -1726.0
       degree 
-0.0003298334 
 betweenness 
1.889156e-05 
clustering.coefficient 
             -1.998184 
   bonacich 
-0.00296275 
  
