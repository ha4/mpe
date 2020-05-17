
nbolts=[3,6,9];
dbolts=30;
function bpos(i)=let(a=360/12*i)dbolts/2*[cos(a),sin(a),0];
bolts=[for(j=nbolts) bpos(j)];
dbearings=12;

module mountplate()
{
    h=7;
    core=50;
    bara=9;
    bpos=core/2-bara/2-1.5;
    module b() rotate([0,90,0])cylinder(d=bara,h=5,center=true);
    difference() {
        color("pink")translate([0,0,-h]) cylinder(d=core,h=h);
        translate([0,0,-h-1]) cylinder(d=25,h=h+2);
        for(i=[0:12]) translate(bpos(i)-[0,0,7+.5])
            cylinder(d=3.5,h=7+1,$fn=12);
        }
    color("pink") rotate([0,0,360/24])
    for(i=[bpos,-bpos]) translate([0,i,0]) b();
}

module prism(x, y, z) {
       polyhedron(points=[
               [0,0,z],           // 0    front top corner
               [0,0,0],[x,0,0],   // 1, 2 front left & right bottom corners
               [0,y,z],           // 3    back top corner
               [0,y,0],[x,y,0]    // 4, 5 back left & right bottom corners
       ], faces=[ // points for all faces must be ordered clockwise when looking in
               [0,2,1],    // top face
               [3,4,5],    // base face
               [0,1,4,3],  // h face
               [1,2,5,4],  // w face
               [0,3,5,2],  // hypotenuse face
       ]);
}

//vprism(4,25,11);

module vprism(mx,my,z) {
    rotate([90,0,180])
    translate([0,0,-my]) prism(mx,z,my);
}


bearing();
module bearing(d1=dbearings,d2=5.0,h=5)
{
    e=.45; // extrusion width
    wall=e*2;
    teeth=11;
    root=e*3; // teeth root
    rin=d2/2;
    teethcenter=rin/1.4;
    module outer() difference() {
        cylinder(d=d1,h=h,$fn=60);
        translate([0,0,-1])cylinder(r=d1/2-.4*3,h=h+2,$fn=40);
    }
    module teeths() difference() {
        union() for(t = [0:360/teeth:359])
            rotate([0, 0, t]) translate([teethcenter,0,0]) 
                    vprism(root, d1/2-wall, h);
        translate([0,0,-1])cylinder(d=d2,h=h+2,$fn=90);
    }
    outer();
    teeths();
}

module bearings()
{
    for(i=bolts) translate(i) bearing();
}

module support(htotal=30,hmnt=5)
{
    mntsz=35;
    dpen=10.6;
    tol=0.3;
    dbox=17;
    box=[dbox,20,0];
    hbox=7;
    gap=1;

    module frame() {
        //cylinder(d=mntsz,h=hmnt,$fn=80);
        for(b=bolts) hull() {
            //translate(-box/2)cube(box+[0,0,hmnt]);
            cylinder(d=dbox,h=hmnt);
            translate(b) cylinder(d=dbearings-1,h=hmnt);
        }
        cylinder(d=dbox,h=htotal);
        hull() {
            translate(-box/2+[0,0,htotal-hbox])cube(box+[0,0,hbox]);
            translate([0,0,htotal-hbox*2])cylinder(d=dbox,h=hbox*2);
        }
    }
    
    module cuts() {
        boxgap=[gap,box.y+1,0];
        ypos=(dpen/2+box.y/2)/2;
        translate([0,0,hmnt*1.5]-boxgap/2) cube(boxgap+[0,0,htotal]);
        translate([0,0,-.5]) cylinder(d=dpen+tol,h=htotal+1,$fn=50);
        for(d=[-ypos,ypos])translate([0,d,htotal-hbox/2])
            rotate([0,90,0]) cylinder(d=3.5,h=box.x+1,center=true,$fn=20);
        for(i=bolts) translate(i-[0,0,1]) {
            cylinder(d=dbearings+tol,h=hmnt+2,$fn=44);
            rotate_extrude($fn=40) translate([dbearings/2+1.5,1+hmnt/2-3.2/2,0])
                square([1,3.2]);
        }
    }
    
    difference() {
        frame();
        cuts();
    }
    
}

//bearing();
//rotate([0,0,360/12]*-2)mountplate();
//for(i=bolts) translate(i) cylinder(d=5,h=20,$fn=22);
//bearings();
//support();
