dbase=35;
dinner=14;

ps=(dbase-1)/2*sincos(-15)-[0,0,.5];
pe=(dinner-1)/2*sincos(0)+[0,0,19];
pts1=[
    ps,
    [ps.x,ps.y-5,ps.z],
//    [22,-18,5],
//    [10,-19,20],
    [ps.x+pe.x,-15,15],
    [pe.x,pe.y-5,pe.z],
    pe
    ];

ptc=[15,-5,10];

ptn=[
    [0,0,-1],
    [0,-1,0],
//    [4,-1,-1.5],
//    [0,-1,.5],
    [-1,0,0],
    [0,-1,0],
    [0,0,1]
];

function sincos(a)=[cos(a),sin(a),0];
function nv(x,x0)=(x-x0)/norm(x-x0);
function radmove(pl,c,r)=[for(p=pl) p+r*nv(p,c)];
pts2=radmove(pts1,ptc,4);
function normmove(pl,pn,r)=[for(i=[0:len(pl)-1]) pl[i]+r*nv(pn[i],[0,0,0])];
pts3=normmove(pts1,ptn,4);
    
function bin(n,k=0) = (k==0)?1:(n-k+1)/k*bin(n,k-1);
function p_bern(t,n)=let(r=1-t)
    [for(i=[0:n]) bin(n,i)*pow(r,(n-i))*pow(t,i)];
function bezier(t,pts)=p_bern(t,len(pts)-1)*pts;

function curvepts(pb)=[for (t=[0:0.05:1+.0001]) bezier(t,pb)];

module servpoints(pts)
    for (p=pts) translate(p) sphere(r=.5,$fn=12);

module arrow(c) {
    hull() {sphere(r=.2);translate(c) sphere(r=.2);}
    hull() {translate(c)sphere(r=.4); translate(c*1.2)sphere(r=.1);}
}

module servbipoints(pts,pt2)
    for (i=[0:len(pts)-1]) translate(pts[i]) {
        sphere(r=.5,$fn=12);
        arrow(pt2[i]-pts[i]);
    }

module servcurve(pc)
    for (i=[0:len(pc)-2]) hull() {
        translate(pc[i]) children();
        translate(pc[i+1]) children();
    }
module servbicurve(pc1,pc2)
    for (i=[0:len(pc1)-2]) hull() {
        hull() {translate(pc1[i]) children(); translate(pc2[i]) children();}
        hull() {translate(pc1[i+1]) children(); translate(pc2[i+1]) children();}
    }

module multisupport() for (j=[0,120,240]) rotate([0,0,j]) {
    children();
    mirror([0,1,0]) children();
}


$fn=10;
//#servpoints([ptc]);
//#servpoints(pts1);
//#servpoints(pts2);
//servcurve(curvepts(pts1)) sphere(d=1);
multisupport()
    servbicurve(curvepts(pts1),curvepts(pts3))
        sphere(d=1);
//#servbipoints(pts1,pts3);
function drills(n=12,d=30)=[for(j=[0:360/n:359]) sincos(j)*d/2 ];

difference() {
    translate([0,0,-5]) union() {
        cylinder(d=dbase,h=5,$fn=67);
        for(c=drills()) translate(c) cylinder(d=7,h=5,$fn=33);
    }
    translate([0,0,-6]) cylinder(d=25,h=7,$fn=67);
    for(c=drills()) translate(c+[0,0,-6])
        cylinder(d=3.5,h=7,$fn=67);
}

difference() {
    translate([0,0,-5]) cylinder(d=dinner,h=39,$fn=56);
    translate([0,0,-6]) cylinder(d=11,h=41,$fn=56);
    translate([-2/2,-18/2,-6]) cube([2,18,23]);
    translate([-2/2,-18/2,25]) cube([2,18,20]);
}

