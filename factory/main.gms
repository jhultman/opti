$oneolcom 
Option solver = CPLEX ;

Set
    i "products"
        /   1 * 4   /
    j "machines"
        /   x
            y       / ;

Table 
    treq(i,j) "time needed per unit good i on machine j"
            x       y 
    1       10      27
    2       12      19
    3       13      33
    4       8       28  ;
        
Parameters
    sp(i) "space in square meters per unit good i"
        /   1   0.10
            2   0.15
            3   0.50
            4   0.05    /
    p(i)  "profit in dollars per unit good i"
        /   1   10
            2   12
            3   17
            4   8       /
   e(j) "breakdown rate of machine j"
        /   x   0.05
            y   0.07    / ;

Scalars
    wk  "working hours per week"
        /   35      /
    a   "area in square meters of total floor space"
        /   50      /
    r   "tolerance for constraint that x2 is twice x3"
        /   0.05    / ;

Positive Variables
    h(i,j)  "hours per week spent producing good i on machine j"
    n(i)    "number of units of good i produced per week" ;

Free Variable
    z "profit per week in dollars" ;

Equations
    obj, time(j), space, twice1, twice2, good1a, good1b, goods(i);

* we want to maximize profit

obj .. z =e= sum(i, p(i)*n(i)) ;

* there are only 35 hours in a work week 
time(j) .. sum(i, h(i,j)) =l= (1-e(j)) * wk ;

* we have limited space
space .. sum(i, n(i)*sp(i)) =l= a ;

* we must produce at least 1.95 times n(3) of good 2
twice1 .. n('2') =g= (2 - r) * n('3') ;

* we must produce at most 2.05 times n(3) of good 2
twice2 .. n('2') =l= (2 + r) * n('3') ;

* we must use both machines to produce good 1
good1a .. n('1') =l= h('1','x') / treq('1','x') ;
good1b .. n('1') =l= h('1','y') / treq('1','y') ;

* we can use either machine to produce the other goods
goods(i)$(ord(i) > 1) .. n(i) =e= sum(j, h(i,j) / treq(i,j)) ; 

Model
    production  / all / ;

Solve production Using LP Maximizing z ;

Display n.l
