///
//  Utility
///

function lenangle(length, diameter) = 360*length/diameter/3.1415926535;

module
ringsector(ls,le,d1,d2,z,circles=false)
{
    sz=.5*(d2-d1);
    rotate([0,0,ls])
        rotate_extrude(angle=le-ls,convexity=3,$fn=72)
            translate([.5*d1,0,0]) square([sz,z]);
    if (circles) for(a=[ls,le]) rotate([0,0,a]) 
        translate([.25*(d1+d2),0,0])
            cylinder(d=sz,h=z,$fn=24);
}

module
sector(sa,ea,d,z)
    rotate([0,0,sa])
        rotate_extrude(angle=ea-sa,convexity=3,$fn=72)
            square([.5*d,z]);

module
roundpass(x,y,z)
    hull() for(m=[-.5*x,.5*x]) translate([m,0,0])
        cylinder(d=y,h=z,$fn=24);

// ringsector(90-24,90+24,54,66,4);

function crosslines(c1,x1,y1, c2,x2,y2) = 
    [ (c1*c2*(y2-y1)-2.0*(x2*c1-c2*x1))/(c2-c1)/2.0,
      (2.0*(x1-x2)+c2*y2-c1*y1)/(c2-c1)  ];

function crossdline(R, c1,x1,y1, c2,x2,y2) = 
    crosslines(c1,x1,y1+R*sqrt(4.0/(c1*c1)+1.0), c2,x2,y2+R*sqrt(4.0/(c2*c2)+1));

//function d2(r1,r2) = r1[0]*r2[1] - r1[1]*r2[0];
function d2(r1,r2) = cross([r1.x,r1.y,0],[r2.x,r2.y,0]).z;
function center3p(a,b,c) = let(v2=b-a, v3=c-a, vq=[v2*v2,v3*v3])
    a+[d2(vq,[v2.y,v3.y]), d2([v2.x,v3.x],vq)] / d2(v2,v3) / 2;

circle3test([0,3],[2.7,2],[0,-1],$fn=50);
circle3test([-1,3.5],[-0.7,2.8],[-1.1,2.2],$fn=50);

module
circle3test(p1,p2,p3)
{
    #translate(p1) circle(r=.05);
    #translate(p2) circle(r=.05);
    #translate(p3) circle(r=.05);
    c=center3p(p1,p2,p3);
    ra=norm(p1-c);
    translate(c) circle(r=ra);
}

// trapezoidal-triangle
module traptriangle(size,cut,height)
hull() for(j=[0,120,240]) rotate([0,0,j])
    translate([-.5*cut,size-0.1,0]) cube([cut,.1,height]);
