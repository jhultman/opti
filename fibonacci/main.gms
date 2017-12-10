$oneolcom 

Scalars
    p  "rho"
    a0  /   -3  /
    b0  /   5   /
    tol /   0.2 /   ;

p = ( 3 - sqrt(5) ) / 2 ;

Set
    i "loop variables"
        /   1*8   / ;

Positive Variables
    a(i)    "left endpoint" 
    c(i)    "left middle" 
    d(i)    "right middle" 
    b(i)    "right endpoint"
    a_prev  "previous a"
    b_prev  "previous b"
    c_prev  "previous c"
    d_prev  "previous d"
    f1 "f at c"
    f2 "f at d" ;

a_prev.l = a0 ;
b_prev.l = b0 ;
c_prev.l = a0 + p * ( b0 - a0 ) ;
d_prev.l = a0 + (1 - p) * ( b0 - a0 ) ;

Loop(i,

    f1.l = power(c_prev.l, 2) + 2*c_prev.l ;
    f2.l = power(d_prev.l, 2) + 2*d_prev.l ;

    if(f1.l < f2.l,
        a.l(i) = a_prev.l ;
        b.l(i) = d_prev.l ;
    else
        a.l(i) = c_prev.l ;
        b.l(i) = b_prev.l ;
    ) ;

    c.l(i) = a.l(i) + p * ( b.l(i) - a.l(i) ) ;
    d.l(i) = a.l(i) + (1 - p) * ( b.l(i) - a.l(i) ) ;

    a_prev.l = a.l(i)   ;
    b_prev.l = b.l(i)   ;
    c_prev.l = c.l(i)   ;
    d_prev.l = d.l(i)   ;
    ) ;

Display a.l
Display c.l
Display d.l
Display b.l
