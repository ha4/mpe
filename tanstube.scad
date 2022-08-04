
// M=mode 1=outer,2=inner,3=wall
module to_tube(M=3, ztube=20, tube=13.2, htube=8, wall=1,R=[0,0,0],T=[0,0,0])
{
    dex=2.3; trifl=3; lt=4; // tube grip extend, step, lock type 4/24
    w0=wall/10;
    dx=(M<2?0:wall);
    // outlet
    translate([0,0,ztube-dx/2])
        cylinder(d=tube-dx*2,h=htube+dx);
    // locks
    if (M==1) for(z=[0,trifl])
            translate([0,0,ztube+htube-2-z])
            rotate_extrude(convexity=5) 
                translate([tube/2,0])
                circle(r=(dex)/4,$fn=lt);  
    // transition
    hull() {
        translate([0,0,ztube-dx/2]) cylinder(d=tube-dx*2,h=w0);
        translate(-[0,0,(M<2?0:w0)]) translate(T)
        rotate(R)linear_extrude(height=w0)
        offset(delta=-dx)children();
    }
}

difference() {
    $fn=44;
    to_tube(1,R=[0,60],T=[-7,0]) circle(19);
    to_tube(2,R=[0,60],T=[-7,0]) circle(19);
    //cube(100);
}
