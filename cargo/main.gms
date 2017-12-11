$oneolcom 
Option solver = CPLEX ;

Set
    i "compartments"
        /   front
            centre
            rear    /
    j "cargos"
        /   c1*c4   /
    k "metrics"
        /   weight
            volume  / ;

Table
    cap(i,k) "capacity of plane"
            weight  volume 
    front   10      6800
    centre  16      8700
    rear    8       5300 ;

Table
    req(j,k) "cargo specs"
            weight  volume 
    c1      18      480
    c2      15      650 
    c3      23      580
    c4      12      390 ;

Parameters
    p(j)  "profit in dollars per tonne cargo j"
        /   c1   310
            c2   380
            c3   350
            c4   285    / ;

Positive Variables
    n(i,j)  "units of cargo j stored in compartment i" ;

Free Variable
    z "profit per flight in dollars" ;

Equations
    obj, weight(i), volume(i), bal(i) ;

* we want to maximize profit
obj .. z =e= sum((i,j), p(j) * n(i,j) * req(j,'weight')) ;

* each compartment i has weight and volume constraint 
weight(i) .. sum(j, n(i,j) * req(j,'weight')) =l= cap(i,'weight') ;
volume(i) .. sum(j, n(i,j) * req(j,'volume') * req(j,'weight')) =l= cap(i,'volume') ;

* the plane must be balanced 
alias(i,ip);
bal(i) .. sum(j, n(i,j) * req(j,'weight')) * 
            sum(ip, cap(ip,'weight')) =e=
          cap(i,'weight') *
            sum((ip,j), n(ip,j) * req(j,'weight')) ;

Model
    cargo / all / ;

Solve cargo Using LP Maximizing z ;

Display n.l
