$oneolcom 
Option solver = CPLEX ;


Set
    i "trucks"
        / 1*4 /
    j "buyer preferences"
        / 1*5 / ;

Parameters
    cost(i) "daily operating cost in USD of truck i"
        / 1 45
          2 50
          3 55
          4 60   /
    cap(i) "daily capacity of truck i in gallons"
        / 1 400
          2 500
          3 600 
          4 1100 /
    dem(j) "daily demand of store j in gallons"
        / 1 100 
          2 200
          3 300 
          4 500 
          5 800  / ;


Integer Variable
    x(i, j) "indicator for milk being supplied by truck i to store j" ;


Free Variable
    z "total daily operating cost in USD" ;


Equations
    obj, demand(j), supply(i) ;

* we want to minimize cost
obj .. z =e= sum(i, sum(j, x(i, j) * cost(i))) ;

* we have to meet demand of store j 
demand(j) .. sum(i, x(i, j)) =g= 1 ;

* we cannot exceed capacity of truck i 
supply(i) .. sum(j, x(i, j) * dem(j)) =l= cap(i) ;


Model
    milk / all / ;

Solve milk Using MIP Minimizing z ;

Display x.l
