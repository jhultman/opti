Option solver = CPLEX
$oneolcom

Set
    t "in months" / 1*60 / ;

Scalars
    principal "in dollars" / 5000.00 /
    r "annual interest rate" / 0.03 / ;

Positive Variables
    p "monthly payment in dollars"
    bal(t) "end-of-month balance in dollars" ;

Free Variable
    z "total loan payments in nominal dollars" ;

Equations
    obj,init,final,constr(t) ;

* we want to minimize total nominal payment
obj..z =e= 60*p ;

* initial EOM balance is principal plus interest
init.. bal('1') =e= principal*(1+r/12)-p ;

* loan must be paid in full
final.. bal('60') =e= 0 ;

* flow of money between periods
constr(t)$( ord(t) > 1 ).. bal(t) =e= bal(t-1)*(1+r/12)-p ;

Model
    loan / all / ;

Solve loan Using LP Minimizing z ;

Display p.l
