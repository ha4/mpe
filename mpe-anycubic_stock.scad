module e3d_v5_0()
translate([0,0,69.7]) // z-lenght
rotate([90,0,-90]) translate([4,-64.2,0]) import(file="E3Dv5.STL");

module anycubic_effector0()
rotate([0,0,120]) // orientation
translate([-170+1.7,-50+1.3,-7/2])
import(file="effector_Anycubic.stl",convexity=5);

module blower4010()
import(file="../../model-fan-air-compress/4010_Blower_Fan_v2.stl");

module anycubic_effector()
{
    h=7; eoffset=31; edist=43;
    module base() {
        w1=21.94; emnt=12.1; d0=3.65;
        d1=sqrt(emnt*emnt+h*h);
        h1=tan(90-55)*(d1-d0);
        hull() for(a=[0,120,240]) rotate([0,0,a])
            translate([-w1/2,eoffset-0.1,-h/2]) cube([w1,0.1,h]);
        for(a=[0,120,240]) rotate([0,0,a]) translate([0,eoffset]) 
            intersection() {
                cube([edist,emnt,h],center=true);
                hull() for(j=[0,1]) mirror([j,0]) translate([-edist/2,0]) 
                       rotate([0,90]) cylinder(d1=d0,d2=d1,h=h1,$fn=31);
            }
    }
    module quad(m) for(x=[-1,1]*m.x/2,y=[-1,1]*m.y/2) translate([x,y])
            children();
    module mounts() {
        $fn=30;
        h0=h*3;
        cw=16.4;cy=13.1;
        aw=26; ah=8; ay=18.5; // duct slot 26x8, center offset 18.5
        // extruder
        cylinder(d=25,h=h0,$fn=50); 
        translate([-cw/2,-cy]) cube([cw,cy,h0]);
        // extruder mnt
        translate([0,-1.6])quad([33,19]) cylinder(d=3.2,h=h0); 
        translate([0,ay]) { // air 
            translate(-[aw,ah]/2) cube([aw,ah,h0]); // duct
            translate([0,-.4])quad([24,14]) cylinder(d=2.5,h=h0); // mnt
        }
        // arm nut
        for(a=[0,120,240]) rotate([0,0,a]) translate([0,eoffset,h])
            rotate([0,90]) cylinder(d=3,h=edist+5,center=true);
    }
    difference() {
        base();
        translate([0,0,-h]) mounts();
    }
}

module e3d_v5()
{
    $fn=40;
    module z(v)translate([0,0,v])children();
    module mnt() {
        cylinder(d=16,h=3);
        cylinder(d=12,h=12.3);
        z(3+5.6) cylinder(d=16,h=3.7);
    }
    module cooler() {
        for(m=[0:3.4:33])z(m)cylinder(d=25,h=1.2);
        z(34)cylinder(d=16,h=1.5);
    }
    module heaterblock() {
        w=16;h=12;d=16;y=12;
        translate([-w/2,-y,0]) cube([w,d,h]);
        translate([0,-7,h/2+1])
            rotate([0,90])cylinder(d=6.2,h=22,center=true);
    }
    module nozzle() {
        cylinder(d1=1.2,d2=6,h=3.43);
        z(2) cylinder(d=9.24,h=3,$fn=6);
    }
    module drill() {
        // mount
        z(57) cylinder(d=7,h=4);
        z(59.57) cylinder(d=9.8,h=12);
        // cooler
        z(19.5) cylinder(d=3,h=2);
        z(20) cylinder(d=15,h=15);
        z(35) cylinder(d=13,h=4);
        z(39) cylinder(d=9,h=17);
        // heater
        z(5.4) cylinder(d=6,h=13);
        // nozzle
        z(2.5) cylinder(d=6,h=2.6);
        z(2) cylinder(d=2,h=1);
        z(0) cylinder(d1=0.46,d2=2,h=2.01);
        z(-1) cylinder(d=0.46,h=7);
    }
    difference() {
        union() {
            z(57.4)mnt();
            z(19.6)cooler();
            z(5.5) heaterblock();
            nozzle();
        }
        drill();
    }
}

module blower4010_box()
{
    sz=40; h=10;
    mnt=35; dr=5;
    dv=29.8; xv=3; // vent. in diameter, offset
    wall=1;
    r_do=28; // rotor outer
    r_di=21; // rotor inner
    r_dh=17; // rotor hub diameter
    r_db=24; // rotor base diameter
    r_hb=2.3;// rotor base height
    r_h=7.0; // rotor height
    r_n=29;  // rotor foils
    $fn=39;
    dsz=mnt-dr-wall*2;
    module move_mnt() for(x=[-mnt,mnt]/2, y=[-mnt,mnt]/2)
            translate([x,y]) children();
    module mirror4() for(i=[0,1],j=[0,1])mirror([i,0])mirror([0,j])
            children();
    module r1square(d,x) hull() {
        circle(d=d);
        translate([-d/2,0])square([x,x-d/2]);
        translate([0,-d/2])square([x-d/2,x]);
    }
    module outline() difference() {
        translate(-[sz,sz]/2)square(sz);
        // corners
        mirror4() translate([mnt,mnt]/2) r1square(dr,dr);
    }
    module mnt_ears() intersection() {
        r1square(dr+wall,dr+wall);
        rotate([0,0,180])r1square(dr,dr);
        }
    // bottom
    linear_extrude(wall) outline();
    // base
    linear_extrude(h) difference() {
        outline();
        offset(-wall) outline();
        translate([-dsz/2,-sz/2-1])square([dsz,sz/2+1]);
    }
    // cover
    translate([0,0,h-wall]) linear_extrude(wall)
        difference() { outline(); translate([xv,0])circle(d=dv); }
    // mount ears
    translate([0,0,2])
        mirror4() linear_extrude(1.5) translate([mnt,mnt]/2)
        difference() { mnt_ears(); circle(d=2); }
}

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

// blower b-part connection
module bconnect()
{
    sz=40; h=10;
    mnt=35; dr=5;
    wall=1;
    tube=13.2;
    xtube=6.6;
    ed=5; // extra duct
    $fn=39;
    dsz=mnt-dr;

    module base() {
        // base
        hull() for(x=[-1,1]*mnt/2,y=[-1,1]*mnt/2)
            translate([x,y]) cylinder(d=dr,h=3.5);
        translate([dsz,sz]/-2)cube([dsz,ed+.05,h]);
        translate([0,-sz/2+ed,h/2+xtube])rotate([-90,0])
        to_tube(1,ztube=sz/2-ed,tube=tube)
            translate([0,xtube])square([dsz,h],center=true);
    }
    module hole() {
        // drills
        for(x=[-1,1]*mnt/2,y=[-1,1]*mnt/2) translate([x,y]) 
            cylinder(d=2+.5,h=10,center=true);
        // mount cut
        translate([0,dsz/2]) {
            cylinder(d=dsz,h=3.5*2+.1,center=true);
            translate([0,dsz/2])
            cube([dsz,dsz,3.5*2+.1],center=true);
        }
        // out duct
        hull() 
        translate([0,-sz/2,h/2]) {
            cube([dsz-wall*2,2*ed,h-wall*2],center=true);
            cube([dsz-wall,.1,h-wall],center=true);
        }
        translate([0,-sz/2+ed,h/2+xtube])rotate([-90,0])
        to_tube(2,ztube=sz/2-ed,tube=tube)
            translate([0,xtube])square([dsz,h],center=true);
    }
    difference() {
        base();
        hole();
    }
}

// blower a-part connection
module aconnect(part=3)
{
    sz=40; h=10; // blower size
    mnt=35; dr=5; bh=3.5; // blower mount, output size, main wall
    slmnt=60; // slot mount distance
    wall=1; // tubing wall and other params
    tube=13.2;
    tex=15.5; trifl=3; // tube grip extend, step
    htube=8;
    xtube=5;
    $fn=39;
    dsz=mnt-dr;

    module base1() {
        // main plate
        translate(-[sz,sz]/2-[0,bh])cube([sz,sz+bh,bh]);
        // slot mounting
        hull() for(x=[-.5,.5]*slmnt) translate([x,0])
            cylinder(d=slmnt-sz,h=bh);
    }
    module base2() {
        hull() { // transition tube
            translate([-dsz/2,-sz/2-wall,bh])
            cube([dsz,wall,h]);
            translate([0,-sz/2-wall-sz/4,bh+tube/2])
            rotate([-90,0])
            cylinder(d=tube,h=wall);
        }
        translate([-sz/2,-sz/2-bh])  // vertical wall
            cube([sz,bh,h+bh]);
        translate([0,-sz/2-sz/4,bh+tube/2]) // output tube
            rotate([90,0])
            cylinder(d=tube,h=htube+wall);
        translate([0,-sz/2-sz/4,bh+tube/2]) // lock rings
            rotate([90,0])for(z=[trifl,2*trifl])
            translate([0,0,z])
            rotate_extrude(convexity=5) 
                translate([tube/2,0])
                circle(r=(tex-tube)/4);             
    }
    module holes1() {
        translate([0,0,-1]) // enlighteemnt
            cylinder(d=sz/1.5,h=bh+2);
        for(x=[-.5,.5]*mnt,y=[-.5,.5]*mnt) // blower mount
            translate([x,y,-1])
            cylinder(d=1.5,h=bh+2);
        for(x=[-.5,.5]*slmnt) translate([x,0,-1]) // slot mount
            cylinder(d=4,h=bh+2);
    }
    module holes2() {
        hull() { // transition tube
            translate([-dsz/2+wall,-sz/2-wall,bh+wall])
            cube([dsz-2*wall,wall+1,h-2*wall]);
            translate([0,-sz/2-wall-sz/4-.01,bh+tube/2])
            rotate([-90,0])
            cylinder(d=tube-2*wall,h=wall);
        }        
        translate([0,-sz/2-sz/4,bh+tube/2]) // output
            rotate([90,0])
            cylinder(d=tube-2*wall,h=htube+wall*2);
    }
    module trpz(w,h) let(a=55, w1=w-2*h/tan(a))
        polygon([[-w/2,0],[w/2,0],[w1/2,h],[-w1/2,h],[-w/2,0]]);
    module dovetail(outer=true,tol=0.1)
        translate([0,-sz/2,-1]) rotate([0,0,180])
        linear_extrude(bh+(outer?1:2)) offset(delta=tol/2)
        difference() {
            if (outer) translate([-sz/2,0])square([sz,bh]);
            trpz(sz/2,bh);
        }
    if (part>=2)difference() { base1(); holes1();dovetail(outer=false);} 
    if (part%2==1)difference() { base2(); holes2();dovetail();}
}


module effector_assembly()
{
translate([0,0,-18.8-7/2]) // effector offset
    e3d_v5();
    anycubic_effector();
    translate([0,29/2,40/2+7/2])rotate([90,0,180])
        blower4010();
}

module cutx() intersection() {
    children();
    translate([500,0]) cube(1000,center=true);
}

effector_assembly();
//anycubic_effector();
//anycubic_effector0();
//blower4010();
//%blower4010_box();
//cutx()
//bconnect();
//translate([0,0,-3.5])
//aconnect(3);
//e3d_v5();
//e3d_v5_0();

