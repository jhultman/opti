$oneolcom 
Option solver = CPLEX ;

Set
    i "elements"
        /   carbon
            chrome
            manganese
            silicon	/
    j "materials"
    	/   pig-iron-1
        	pig-iron-2
        	ferro-silicon-1
        	ferro-silicon-2
        	alloy-1
        	alloy-2
        	alloy-3
        	carbide
        	steel-1
        	steel-2
        	steel-3  /
     k "element requirements"
        /   geq
            leq      /
     l "material requirements"
        /   cost 
            avail    /  ;

Table
    elt(i,k) "material requirements"
                geq    leq 
    carbon      3.0    3.5
    chrome      0.3    0.45
    manganese   1.35   1.65
    silicon     2.7    3.0  ;

Table
    mat(j,i) "material requirements"
                     carbon    chrome    manganese    silicon 
    pig-iron-1       4.0       0.0       0.9          2.25
    pig-iron-2       0.0       10.0      4.5          15.0
    ferro-silicon-1  0.0       0.0       0.0          45.0
    ferro-silicon-2  0.0       0.0       0.0          42.0
    alloy-1          0.0       0.0       60.0         18.0
    alloy-2          0.0       20.0      9.0          30.0
    alloy-3          0.0       8.0       33.0         25.0
    carbide          15.0      0.0       0.0          30.0
    steel-1          0.4       0.0       0.9          0.0
    steel-2          0.1       0.0       0.3          0.0
    steel-3          0.1       0.0       0.3          0.0   ;

Table
    specs(j,l) "costs and available amounts"
                      cost      avail
    pig-iron-1        0.03      inf 
    pig-iron-2        0.0645    inf 
    ferro-silicon-1   0.065     inf 
    ferro-silicon-2   0.061     inf 
    alloy-1           0.1       inf 
    alloy-2           0.13      inf 
    alloy-3           0.119     inf 
    carbide           0.08      20 
    steel-1           0.021     200 
    steel-2           0.02      200 
    steel-3           0.0195    200   ;

Positive Variables
    w(j)    "amount in pounds of material j used" 
    p(j)    "price in dollars per pound material j"
    f(i)    "fraction of element i by weight in batch"

Free Variable
    z "cost of production in dollars" ;

Equations
    obj, lim_mat(j), geq(i), leq(i), ton ; 

* we want to minimize cost
obj .. z =e= sum(j, specs(j,'cost') * w(j)) ;

* we have limited materials 
lim_mat(j) .. w(j) =l= specs(j,'avail') ;

* we have composition requirements
geq(i) .. sum(j, mat(j,i) * w(j)) =g= elt(i, 'geq') * sum(j, w(j)) ;
leq(i) .. sum(j, mat(j,i) * w(j)) =l= elt(i, 'leq') * sum(j, w(j)) ;

* the batch needs to weight one ton
ton .. sum(j, w(j)) =e= 2000

Model
    steel / all / ;

Solve steel Using LP Minimizing z ;

Display z.l
Display w.l
Display w.m
