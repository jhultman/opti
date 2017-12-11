$oneolcom

Option solver = CPLEX ;

Set
    i "substances"
    /   1*5   /
    j "in or out" 
    /   bought
        sold    / ;

Table
    p(i,j) "price in dollars per gallon substance i"
        bought  sold
    1   0.00    0.80
    2   0.00    0.00
    3   0.50    0.00
    4   1.20    0.00
    5   0.60    0.70    ;

Positive Variables
    x(i)        "gallons of substance i"
    revenues    "revenues per month in dollars"
    costs       "costs per month in dollars"

Free Variable
    z "profit per month in dollars" ;

Equations
    obj, c, r, conserv, prodRatio, npwCap, detCap ;

* we want to maximize profit
obj .. z =e= revenues - costs ;

* revenues
r .. revenues =e= p('1','sold')*x('1') + p('5','sold')*x('5') ;

* costs
c .. costs =e= p('3','bought')*x('3') + p('4','bought')*x('4') 
        + p('5','bought')*x('5') ;

* conservation of npw
conserv .. x('1') + x('2') =e= x('3') + x('4') ;

* npw to detergent ratio must be 1 to 10
prodRatio .. x('2') =e= 0.1 * x('5') ;

* npw factory capacity
npwCap .. x('3') =l= 10000 ;

* detergent factory capacity
detCap .. x('5') =l= 120000 ;

Model
    npw /    all     / ;

Solve npw Using LP Maximizing z ;

Display x.l
