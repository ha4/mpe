
$fn=48;
filepath="../../model-kossel/multipurpose-effector/";
//filepath="../mpe-kossel/";
//filepath="./";
use <ev3d.scad>
use <mpe-original.scad>
use <mpe-bayonet.scad>
use <mpe-flange.scad>
use <mpe-oldkossel.scad>
use <mpe-util.scad>
use <mpe-bolts.scad>
use <mpe-sens.scad>


//
// EXTRUDER
//
//translate([0,0,41.6])
//e3dv5();
//#e3dv5();
//translate([0,0,-4.5])
//e3dv6();

//
// MPE original
//
//mpe_effector(filepath);
//mpe_springring();
//mpe_fanduct();
//mpe_insert();
///mpe_hotendmountasm();
//mpe_hotendmount1();
//mpe_hotendmount2();
//mpe_hotendmount3();
//mpe_insertpen();

//
// MAIN modules
//
//
/*** linear and angular tolerances */
ltol=0.18;
atol=0.51;
/*** bayonet angular parameter */
boffs=24; bsize=91; block=41; blist=[0,120,240];
abolt=(120+bsize)/2+boffs;
/*** effector parameters */
//Reff=40; Rod_separation=42;
Reff=31; Rod_separation=43;
Heff=9;
/*** mount sizes */
//mount_core=60;
mount_core=50;
mnt_drill=5.0-.5; // 4.5
mnt_border=3;
mnt_height=Heff+2;
mnt_pass=mount_core-2*mnt_border;
dbayonet=mnt_pass-2.2;
/*** head parameters */
dbolt=mount_core-mnt_drill*2;
hbase=7;

//translate([0,0,-9/2])
//Effector($fn=77);
//SpringRing();
//HotendMount();
//Insert();
//FanDuct();

//Effector();
//rotate([0,0,41])
//SpringRing(aair=[-90,-45,0,45,90,135,164.5],cabl=[3.5,2.5]);
///FanDuct(lh=1, cabl=[3.5,2.5], taper1=0.7, taper1air=0.1, wall=1.5/2, dairmax=40.6);
//Insert(cabl=[3.5,2.5],aflange=20,fanoffs=1.5);
//translate([0,-.5*mount_core+.1,hbase+3.15])
//TubeFlange(aflange=20,fanoffs=1.5);

////module offset(h) translate([0,0,(h<0)?h:0]) cube([5,5,abs(h)]);
//#offset(-19.7-7/2-15.7);

*translate([0,0,-9/2]) {
SpringRingBase();
*Base();
*InsertBase();
*translate([0,0,-21-3]) { d2hw_pcbholder(h=21); translate([-4,0,0]) d2hw_pcb(); }
}
//KossInsert();

// main radius: 31, rod-mnt distance:43 center-to-edge=37
// height=7 jointsz=6+6 center-plain-to-extruder-tip=

module bayonets() for(a=blist) rotate([0,0,a]) children();

//jbase([42,9,9],5,5);
module
jbase(sz,da,h1) // all dimension + tip cone size
    intersection() {
        db=sqrt(sz.y*sz.y+sz.z*sz.z)+.05; // face tolerance
        cube(sz,center=true);
        hull() for(i=[0:1]) mirror([i,0,0])
            translate([-sz.x,0]/2)rotate([0,90])
            cylinder(d1=da,d2=db,h=h1,$fn=36);
    }

//joint();
module
joint(radial=40, separation=42, height=9, depth=9,
        end_sz=5, conesize=5, boltdepth=10, nutspace=14, nutcut=8)
    translate([0,radial,0]) difference() {
        // rod holder & support
        rotate([90,0]) union() {
            sz=[separation,height,depth];
            jbase(sz,end_sz,conesize);
            linear_extrude(height=radial) projection(cut=true)
                translate([0,0,-depth/2])jbase(sz,end_sz,conesize);
        }
        // nut & bolt
        rotate([0,90]) {
            cylinder(d=3.2,h=separation+1,center=true,$fn=36);
            cylinder(d=6.4,h=separation-boltdepth*2,center=true,$fn=6);
        }
        // nut insertion space
        let(x=separation-2*nutspace)
         translate(-[x,-depth+2*nutcut,height+2]/2) cube([x,depth,height+2]);
    }

// base modules
module
extbase(d0, bh, jradial, jmnt, extra=1)
// jradial: form center to joint surface jmnt: joint surface width
{
    szcntr=d0/2+extra*cos(30); // from center to inter-joint
    sz=jradial+szcntr; // form joint to oppizite inter-joint
    joffset=jradial+jmnt/2; // from center to j.trigon vertex
    // effector body
    intersection_for(a=blist) {
         rotate([0,0,a]) translate([-sz,-szcntr,-bh/2])
            cube([sz*2,sz,bh]);
         rotate([0,0,a]) translate([0,joffset,-bh/2])
            rotate([0,0,-90-45]) cube([sz*2,sz*2,bh]);
    }
}

// outer=[[0,30],[1.5,30], [16.226,21], /*r*/[17.369,19.974], [18.071,18.608],
//  [19.853,12.68] /*OR[20.208,11.5]*/];
// intra=[ [0,20], [1.5,20], [5.9,21.48], [13.095,20.42], /*r*/[15.792,19.13],[16.70,17.517],
//  [19.183,12.28] /*OR [19.477,11.5]*/]; // end taper=5.306
// intrb=[ [0,13], [1.5,13], /*r*/[4.64,15.70], [8.65,16.69],
//  [13.24,16.715], /*r*/[15.224,16.27], [17.25,14.31], [18.538,11.88] /*or [18.738,11.5]*/];
// inner=[0,11.5], [1.5,11.5], /*r [4.12,13.65]*/, /*r*/[5.63,14.455], [9.368,15.5],
//  [12.91,15.5], /*r*/[15.01,14.965], [16.61,13.51], [17.925,11.5];

// d1:main outer diameter, lh-plate diameter, d2=outer diam, h2=height
//duct_shape();
module
duct_shape(d1=60,lh=1.5,t1=1.213,d2=23,h2=20.185,t2=6.71,r1=4.2)
{
    sol=crossdline(r1, t1,d1/2,-lh, t2,d2/2,-h2);
    hull() {
        translate([0,-lh])square([d1/2,lh]);
        translate(sol) circle(r=r1);
        translate([0,-h2]) square([d2/2,h2]);
    }
}

// din1:
module air_shapei(din1=26,din2=40,lh=1.5,lext=1,h=19.477,dend=23,
    dmax=42.96,hmax=5.9,taper1=0.293,taper2=5.306,rcurv=5.947,
    hgap=0.739,
    taper1a=0.001,taper2a=3.778,rcurva=4.4861)
{
    p1=[din1/2,-lh]; p2=[15.70,-4.64]; p3=[16.69,-8.65]; p4=[dend/2,-h+hgap];
    cp1=center3p(p1,p2,p3);
    cr1=norm(p1-cp1);
    sola=crossdline(rcurva, taper1a,p3.x,p3.y, taper2a,p4.x, p4.y);
    hull() {
        translate(cp1) circle(r=cr1);
        translate(sola)circle(r=rcurva);
        translate([0,-h+hgap])square([dend/2,2]);
    }
    translate([-lext,-h/2]) square([lext+din1/2,h/2+lext]);
    translate([-lext,-h-lext]) square([lext+dend/2,h/2+lext]);
}

module air_shapeo(din1=26,din2=40,lh=1.5,lext=.5,h=19.477,dend=23,dmax=42.96,hmax=5.9,taper1=0.293,taper2=5.306,rcurv=5.947,hgap=0.739,taper1a=0.001,taper2a=3.778,rcurva=4.4861)
{
    sol=crossdline(rcurv, taper1,dmax/2,-hmax, taper2,dend/2,-h);
    translate([din2/4,-hmax]) square([din2/4,hmax+lext]);
    hull() {
        translate([din2/2-din2/4,-lh-.5]) square([din2/4,.5]);
        translate([dmax/2-sqrt(2)/2,-hmax])rotate([0,0,45])
            square([1,1],center=true);
        translate(sol)circle(r=rcurv);
        translate([dend/4,-h])square([dend/4,2]);
    }
}


module
air_sup(fa,n=9)
{
    da=fa/n;
    for(a=[0:n]) if (a!=0 && a!=n)
        rotate([0,0,da*a]) 
        translate([21,0,-12])
        rotate([0,180-31.7,0])
        translate([0,-1/2,0])
            cube([11.23,.8,3]);
}


// cpath:central pass  wall: internal wall depth
// cab: cable path size  air: air path  aair: angular air pass pos.
module
aircut(cpath=23,wall=1.5,air=7,aair=[-90,164.5],cuth=4)
{
    aird=cpath+2*wall;
    airw=lenangle(wall,aird)/2;
    airs=len(aair)-1;

    // air channel
    for(i=[0:airs-1])
         ringsector(aair[i]+((i==0)?0:airw),
                    aair[i+1]-((i==(airs-1))?0:airw),
                    aird, aird+2*air, cuth);
}

module
cablecut(cpath=23,wall=1.5,jcabl=5,air=7,aira=164.5,cuth=4)
{
    lst=is_list(jcabl);
    cablen=((!lst)?air-2:jcabl[1]);
    cabld=((!lst)?jcabl:jcabl[0]);
    cxd=cpath/2+cablen/2+cabld/2+((lst)?1:2)*wall-.6;
    cyd=cabld/2+wall+0.4;   // cable pass coord

    // cable channel, centered in rings
    rotate([0,0,aira]) translate([cxd,cyd,0]) {
        roundpass(cablen,cabld,cuth);
        //#cylinder(d=1,h=10,center=true);
    }
}

//aircut();
//cablecut();

module
ductbase(lh,taper1=1.213,wall=1.5/2,cpath)
{
    tol=0.18;
    rotate_extrude(convexity=7)
        difference() {
            duct_shape(d1=mount_core-tol, lh=lh, t1=taper1);
            offset(delta=-wall) air_shapei(din1=cpath,lh=lh,lext=5);
        }
}

module
unimount(h,luft=false)
{
    dia=30;
    cylinder(d=25,h=h);
    for(i=[0:360/12:359]) rotate([0,0,i])
            if (luft) boltpass(circularsz=dia);
            else translate([dia/2,0,0]) cylinder(d=3.5,h=h);
}

//difference() {
//ductbase(mount_core=60,lh=1.5,wall=1.5, cpath=23+1.5*2);
//translate([50,0,0])cube(100,center=true);
//}


//
//  Main Units
//

//
//  Kossel Effector
//
// Reff: effector radius (to mount rod) Rod_separation: itself
// mount_core: central mount hole diameter 
// mnt_border: wall thikness around mount hole 
module
Effector()
{
    d0=mount_core+mnt_border*2;
    hcone=5;
    L=9;
    difference() {
        union() {
            bayonets()
                joint(radial=Reff, separation=Rod_separation, height=Heff, 
                    depth=L, conesize=hcone);
            extbase(d0=d0,jradial=Reff-L/2, bh=Heff, jmnt=Rod_separation-2*hcone);
            // mount base
            translate([0,0,-Heff/2]) cylinder(d=d0,h=mnt_height,$fn=72);
        }
        // central mount
        cylinder(d=mount_core,h=mnt_height*3,center=true,$fn=80);
    }
    // bayonet locks
    translate([0,0,-Heff/2]) bayonets()
        springlock(d0=mount_core+mnt_border, d1=mnt_pass);
}
Effector();


// mount_core: main diameter   dpath:central pass  lh: ring height
module
SpringRing(dpath=23, lh=3.15, wall=1.5, aair=undef,cabl=undef)
{
    dmax=mount_core*4/6;
    airs=((aair==undef)?[-90,164.5]:aair);
    aird=(dmax-dpath-2*wall)/2;
    airend=airs[len(airs)-1];

    difference(convexity=5){
        intersection_for(a=[0,120,240]) rotate([0,0,a])
            springbase(d0=mount_core,d1=mnt_pass,$fn=96);
        // perforations
        translate([0,0,-.5]) {
          // multi-cuts
          rotate([0,0,abolt]) bayonets() boltpass(circularsz=dbolt);
          // single cuts
          // main extruder path
          cylinder(d=dpath,h=lh+1,$fn=48);
          // air duct
          aircut(cpath=dpath,air=aird,aair=airs);
          // cable pass
          cablecut(cpath=dpath,jcabl=((cabl==undef)?5:cabl),
                air=aird,aira=airend);
        }
    }
}

module
SpringRingBase(lh=3)
{
    difference(convexity=5){
        intersection_for(a=[0,120,240]) rotate([0,0,a])
        springbase(d0=mount_core,d1=mnt_pass,h=lh,$fn=96);
        translate([0,0,-.5])
           rotate([0,0,abolt]) bayonets() boltpass(circularsz=dbolt);
        translate([0,0,-.5]) unimount(h=lh+1,luft=true);
    }
}

///
//  Fan Duct and Base
///

// mount_core: main diameter   dpath:central pass
// wall: all inner wall thinkness 
// aair: air vhentilation ring angle start,stop  dairmax: outer diameter
// cabl: cabling path size
module
FanDuct(dpath=23, lh=1.5, htotal=22, taper1=1.213, taper1air=0.293,
    wall=1.5, dairmax=42.96, aair=[-90,164.5],cabl=5)
{
    d1=mnt_pass+1; //50
    dmax=mount_core*4/6;
    aird=(dmax-dpath-wall*2)/2;
    airend=aair[len(aair)-1];
    dbayonet=mnt_pass-2.2;
   
    difference() {
        // base
        ductbase(lh=lh,taper1=taper1,wall=wall,cpath=dpath+wall*2);
        // air channel
        rotate([0,0,aair[0]]) difference() {
            rotate_extrude(convexity=5,angle=airend-aair[0])
            difference() {
                air_shapeo(lh=lh,din2=dmax,dmax=dairmax,taper1=taper1air);
                air_shapei(lh=lh,din1=dpath+1.5*2);
            }
           air_sup(255); // angle
        }
        // central space
        translate([0,0,-22.925]) {
            cylinder(d1=29.18,d2=23,h=5.01); // taper d/h=1.2356
            cylinder(d=23,h=7);
        }
        // cables & heater
        translate([0,0,-htotal]) sector(360-91,166.5,60,htotal-2*lh);
        // cable pass
        translate([0,0,-htotal])
            cablecut(cpath=dpath,jcabl=cabl,air=aird,aira=airend,cuth=htotal+1);
        // mount & bayonet
        for(i=[0,120,240]) rotate([0,0,i+abolt]) translate([0,0,-htotal]) {
            boltend(dbolt=dbolt,cuth=htotal,lh=lh);
            translate([0,0,-.5])
                bayonetpath(d0=mount_core+1,d1=dbayonet,cuth=htotal+1);   
        }
    }
    intersection() {
        ductbase(mount_core=mount_core,lh=lh,taper1=taper1,wall=wall,cpath=dpath+wall*2);
        for(i=[0,120]) rotate([0,0,i+9.4]) translate([dbolt/2,0,-htotal])
             difference() { cylinder(d=6.4+1,h=htotal); cylinder(d=6.4,h=htotal); }
    }
}

//FanDuct();
//difference() { air_shapeo(); air_shapei(); }
//difference() { duct_shape(); air_shapei(); }
//#FanDuct();
//#mpe_fanduct();
//ductbase();
//#translate([0,-20])square([23/2,20]);

module
Base(lh=1.5, htotal=3, taper1=1)
{
    tol=0.18;
    d1=mnt_pass+1; //50
    dmax=mount_core*4/6;
   
    difference() {
        // base
        hull() {
            // mount plate
            translate([0,0,-lh])cylinder(d=mount_core-tol,h=lh);
            translate([0,0,-htotal]) cylinder(d=mount_core-taper1*(htotal-lh),h=htotal);
        }
        // mount & bayonet
        for(i=[0,120,240]) rotate([0,0,i+abolt]) translate([0,0,-htotal])
            boltend(dbolt=dbolt,cuth=htotal,lh=lh);
        translate([0,0,-.5-htotal]) 
            bayonets() bayonetpath(d0=mount_core+1,d1=dbayonet,cuth=htotal+1);   
        translate([0,0,-htotal-.5]) unimount(h=htotal+1);
    }
}

///
//  Insert block
///

module
InsertBase(hbase=7)
{
    bara=9;
    bpos=mount_core/2-bara/2-1.5;
    module b() rotate([0,90,0])cylinder(d=bara,h=5,center=true);
    translate([0,0,3.15]) difference() {
        union() {
            cylinder(d=mount_core-.2,h=hbase); // base plate
            rotate([0,0,360/24])
            for(i=[bpos,-bpos])translate([0,i,hbase]) {
                b();
                bevel(0,1,1,5) b();
            }
        }
        rotate([0,0,abolt]) bayonets() translate([0,0,hbase/2-.5])
        boltnut(dbolt=dbolt,cuth=hbase);
        translate([0,0,-.5]) unimount(h=hbase+10);
    }
}

module bevel(h,h_bevel,r_bevel,fn)
{
    eps=0.001;
    function h_bev(i)=h_bevel*(1-cos(90*i));
    function r_bev(i)=((i==1)?eps:0)+r_bevel*(1-sin(90*i));
    module temp(hx,r) translate([0,0,hx]) linear_extrude(height=eps)
        minkowski() { projection(cut=true)translate([0,0,-h-hx]) children();
           circle(r); } 
	translate([0,0,h])
    for(j=[0:fn-1]) let(i1=j/fn,i2=(j+1)/fn,h1=h_bev(i1),h2=h_bev(i2))
        hull() {
            temp(h_bev(i1), r_bev(i1)) children();
            temp(h_bev(i2), r_bev(i2)) children();  }
}


module fanflange(fsz=33,fa=20,depth=9.6,height=28.3,
    circular=47,center=50,
    wall=1.5,
    fan=27,mnt=25,bolt=2.5,offs=1.5)
{
    pth0=fsz*cos(fa); // fan side plate
    ptl0=fsz*sin(fa)*0.85;
    pth=pth0>height?height:pth0;
    ptl=ptl0<depth?depth:ptl0;
    swall=wall*sin(fa);
    fsz2=(pth-swall)/cos(fa); // corrected height
    ptl2=(height)*tan(fa)-wall/cos(fa);
    module frame() {
        rotate([-fa,0,0]) translate([-fsz/2,-wall,0])
            cube([fsz,wall,fsz2]);
        // side walls
        translate([-fsz/2,0,0]) cube([wall,ptl,pth]);
        translate([fsz/2-wall,0,0]) cube([wall,ptl,pth]);
        // upper wall
        translate([-fsz/2,ptl2,height-wall]) cube([fsz,depth-ptl2,wall]);
    }
    module fandrill() {
        translate([0,.5,fsz/2-offs]) rotate([90,0,0]) {
          cylinder(d=fan,h=wall+1);
          for(ra=[0,90,180,270]) rotate([0,0,ra])
            translate([mnt/2,mnt/2,0])cylinder(d=bolt,h=wall+1);
        }
        translate([-fsz/2-1,-fsz-wall,0])cube([fsz+2,fsz,fsz]);
    }
    difference() {
        frame();
        rotate([-fa,0,0]) fandrill();
    }
    // lower wall
    difference() {
        translate([-fsz/2,0,0]) cube([fsz,depth,wall]);
        translate([0,center/2,-.5])cylinder(d=circular,h=wall+1);
    }
}

//translate([0,-mount_core/2+.1,7+3.15]) fanflange();

module
insbase(d1,h1, // base plate size
h2,d2, // heatsink tube
h3,sz3,sz3f, // extruder mount triangle size: height,overall size,cornder size
wall, // wall thikness
ivent,ovent) // heatsink inlet ventilation angles, exhaust wall distance
{
    awall=lenangle(.5*wall,d2); // wall angular size
    av=.5*(ivent[0]+ivent[1]);  // heatsing inlet angular size
    m=5;
    szsup=sz3f+7;
    //oventsz=.5*d1*cos(180/3.1415*(ovent+wall)/d1);
    oventsz=sz3*0.96;

    cylinder(d=d1,h=h1); // base plate
    translate([0,0,h1-.1]) cylinder(d=d2,h=h2+.2); // extruder heatsink tube
    translate([0,0,h2+h1]) // extruder mount triangle din=15
        traptriangle(sz3,sz3f,h3);
    // air-duct walls
    for(a=ivent+[awall,-awall])rotate([0,0,a]) // extruder heatsink ventilation
       translate([0,-.5*wall,h1-.1]) cube([oventsz,wall,h2+.2]);
    rotate([0,0,180+av]) for(o=[-ovent,ovent-wall*2]) translate([0,.5*o,h1-.1])
        cube([oventsz,wall,h2+.2]);
    // two special closed walls
    for(a=[0,240]) rotate([0,0,a])
         translate([-szsup/2,sz3-wall,h1-.1]) cube([szsup,wall,h3+h1]);
}

module Insert(dpath=23, wall=1.5, 
    hbase=7, hmain=7+21.4, hsupp=4, htop3=10.9, suppsz=23.354,
    ivent=[-15,75], ovent=13,
    aflange=30, szflange=33, fanoffs=0, fanmnt=25, fanbolt=2.5,
    aair=[-90,164.5],cabl=5)
{
    dmax=mount_core*4/6;
    ebolt=36.5;
    aird1=dpath+wall*2;
    aird=(dmax-dpath-wall*2)/2;
    airend=aair[len(aair)-1];
    av=.5*(ivent[0]+ivent[1]);
    awall=lenangle(wall*.86,dpath); // spring offset to stopper pin

    module extruderpass() {
        translate([0,0,hmain]) traptriangle(21.25,7.8,7); // head mount
        translate([0,0,-.1]) cylinder(d=dpath,h=hmain+.2); // heatsink
        bayonets() translate([0,0,hmain-wall-.5]) rotate([0,180,-90])
                boltnut(dbolt=ebolt, abolt=90, cuth=5);   // head bolts
    }
    module airbridge() {
        translate([0,0,-.1]) {
            ringsector(aair[0],ivent[0],aird1,dmax,hbase+.2);
            ringsector(ivent[1],airend,aird1,dmax,hbase+.2);
        }
        rotate([0,0,ivent[0]-.1])
            rotate_extrude(angle=ivent[1]-ivent[0]+.2,convexity=2)
            polygon([[aird1/2,-.01],[dmax/2,hbase-wall],[dmax/2,-.01]]);
    }
    module heatsinkvent() {
        vo=suppsz; // ventilation out radius = triangle size
        vocone = (dmax-aird1)/(hbase-wall);
        hout = hbase+(vo*2-dmax)/vocone;
        intersection() {
            union() { // ventilation radial space
                sector(ivent[0]+awall, ivent[1]-awall, mount_core, hmain); // in
                rotate([0,0,av]) translate([-mount_core/2,-ovent/2+wall,0])
                    cube([mount_core/2,ovent-2*wall,hmain]); // vent-out
            }
            hull() { // vent shape
                translate([0,0,wall]) cylinder(d=aird1,h=hmain-2*wall);
                translate([0,0,hout]) cylinder(r=vo,h=hmain-hsupp-hout);
            }
        }
    }
    //render(convexity=5)
    translate([0,0,3.15]) 
    difference() {
//        union() {
//           cablecut(cpath=dpath-3,
//                jcabl=[cabl.x+1,cabl.y+1],
//                jcabl=cabl+2,
//                air=aird,aira=airend-1.7,cuth=hmain+4.3);
//        }
           insbase(d1=mount_core-.2,h1=hbase,h2=hmain-hbase-hsupp,d2=aird1,
                h3=htop3, sz3=suppsz,sz3f=7.66,wall=wall,
                ivent=ivent,ovent=ovent);
        extruderpass();
        airbridge();
        heatsinkvent();
        translate([0,0,-.1])
            cablecut(cpath=dpath,jcabl=cabl,air=aird,aira=airend,cuth=hbase+.2);
                //cuth=hmain+4.1);
        // base bolts
        rotate([0,0,abolt]) bayonets() translate([0,0,hbase/2-.5])
                boltnut(dbolt=dbolt,cuth=hbase);  
     }
     // suppsz=23.354 d1/2=r_our=suppsz+7.66*sin60
     // r_in=3r_out/sqrt(3)*sin60-r_out=3/2r_out-r_out=r_out/2 => din=30
     //dd=(suppsz+7.66*sin(60))/2;
     //#translate([0,0,3.15]) cylinder(r=60/4,h=hmain+15);
     //
     translate([0,0,3.15])
     bayonets() translate([0,-.5*mount_core+.1,hbase])
        fanflange(fsz=szflange,fa=aflange,depth=mount_core/2-15,height=hmain,
            circular=mount_core-2,center=mount_core,
            wall=wall, fan=szflange-6,mnt=fanmnt,bolt=fanbolt,offs=fanoffs);
}


module
insbase0(d1,h1, // base plate size
h2,d2, // heatsink tube
h3,sz3,sz3f, // extruder mount triangle size: height,overall size,cornder size
wall, // wall thikness
ivent, // heatsink inlet ventilation angles
ovent, // heatsing exhaust wall distance
fa,fsz // flange angle and size
)
{
    awall=lenangle(.5*wall,d2); // wall angular size
    av=.5*(ivent[0]+ivent[1]);  // heatsing inlet angular size
    m=5;
    szsup=sz3f+7;
    //oventsz=.5*d1*cos(180/3.1415*(ovent+wall)/d1);
    oventsz=sz3*0.96;
    pth=fsz*cos(fa); // fan side plate
    ptl=fsz*sin(fa)*0.85;

    cylinder(d=d1,h=h1); // base plate
    translate([0,0,h1-.1]) cylinder(d=d2,h=h2+.2); // extruder heatsink tube
    translate([0,0,h2+h1]) { // extruder mount triangle
        // extruder base
        traptriangle(sz3,sz3f,h3);
        // flange supports
        for(i=[0,120,240]) rotate([0,0,i]) {
            translate([-.5*szsup,sz3-m,0]) cube([szsup,m,h3]);
        }
    }
    // air-duct walls
    for(a=ivent+[awall,-awall])rotate([0,0,a]) // extruder heatsink ventilation
       translate([0,-.5*wall,h1-.1]) cube([oventsz,wall,h2+.2]);
    rotate([0,0,180+av]) for(o=[-ovent,ovent-wall*2]) translate([0,.5*o,h1-.1])
        cube([oventsz,wall,h2+.2]);
    // fan flanges
    for(i=[0,120,240]) rotate([0,0,i])
    translate([0,-.5*d1,h1]) {
           //flange
           rotate([-fa,0,0]) translate([-fsz/2,-wall,0])
                cube([fsz,wall,fsz]);
           // down plate
           difference() {
               translate([-fsz/2,0,0]) cube([fsz,ptl,wall]);
               translate([0,.5*d1,0]) cylinder(d=d1-4,h=wall+.1);
               }
           // side plate
           translate([-fsz/2,0,0]) cube([wall,ptl,pth]);
           translate([fsz/2-wall,0,0]) cube([wall,ptl,pth]);
        }
     // two special closed walls
     for(a=[0,240]) rotate([0,0,a])
         translate([-szsup/2,sz3-wall,h1-.1]) cube([szsup,wall,pth]);
}

module Insert0(dpath=23, wall=1.5, 
    hbase=7, hmain=7+21.4, hsupp=4, htop3=10.9, suppsz=23.354,
    ivent=[-15,75], ovent=13,
    aflange=30, szflange=33, fanoffs=0, fanmnt=25, fanbolt=2.5,
    aair=[-90,164.5],cabl=5)
translate([0,0,3.15]) 
{
    dmax=mount_core*4/6;
    ebolt=36.5;
    aird1=dpath+wall*2;
    aird=(dmax-dpath-wall*2)/2;
    airend=aair[len(aair)-1];
    av=.5*(ivent[0]+ivent[1]);
    awall=lenangle(wall*.86,dpath); // spring offset to stopper pin
   
    //render(convexity=5)
    difference() {
        // base inner form
        insbase0(d1=mount_core-.2,h1=hbase,h2=hmain-hbase-hsupp,d2=aird1,
                h3=htop3, sz3=suppsz,sz3f=7.66,wall=wall,
                ivent=ivent,ovent=ovent,fa=aflange,fsz=szflange);
       // main holes 
       translate([0,0,-.1]) {
            cylinder(d=dpath,h=hmain+.2);
            ringsector(aair[0],ivent[0],aird1,dmax,hbase+.2);
            ringsector(ivent[1],airend,aird1,dmax,hbase+.2);
        }
        // extruder mount
        translate([0,0,hmain]) traptriangle(21.25,7.8,7);
        // air bridge
        rotate([0,0,ivent[0]-.1]) rotate_extrude(angle=ivent[1]-ivent[0]+.2,convexity=2)
            polygon([[aird1/2,-.01],[dmax/2,hbase-wall],[dmax/2,-.01]]);
        // air-vent-in
        intersection() {
            union() {
                // vent-in
                sector(ivent[0]+awall, ivent[1]-awall, mount_core, hmain);
                // vent-out
                rotate([0,0,av]) translate([-mount_core/2,-ovent/2+wall,0])
                    cube([mount_core/2,ovent-2*wall,hmain]);
            }
            // vent shape
            vo=suppsz; // ventilation out radius = triangle size
            vocone = (dmax-aird1)/(hbase-wall);
            corr = (vo*2-dmax)/vocone;
            echo(corr);
            hull() {
                translate([0,0,wall]) cylinder(d=aird1,h=hmain-2*wall);
                translate([0,0,hbase+corr]) cylinder(r=vo,h=hmain-hbase-hsupp-corr);
            }
        }

        // fan flanges clean
        fsz=szflange; fa=aflange; fcls=fsz*sin(fa);
        for(i=[0,120,240]) rotate([0,0,i])
           translate([0,-.5*mount_core+.1,hbase]) rotate([-fa,0,0]) 
           translate([-fsz/2-3,-fsz-wall,0]) {
                cube([fsz+6,fsz,fsz]);
                translate([(fsz+6)/2,0,fsz/2-fanoffs])
                    rotate([-90,0,0]) {
                        cylinder(d=fsz-6,h=fsz+wall+.1);
                        for(ra=[0,90,180,270]) rotate([0,0,ra])
                        translate([fanmnt/2,fanmnt/2,0])cylinder(d=fanbolt,h=fsz+wall+.1);
                    }
           }
        // top clean
        translate([0,0,htop3+hmain-hsupp]) cylinder(d=mount_core,h=htop3);
        // cables
        translate([0,0,-.1])
            cablecut(cpath=dpath,jcabl=cabl,air=aird,aira=airend,cuth=hbase+.2);
        // bolts
        rotate([0,0,abolt]) bayonets() translate([0,0,hbase/2-.5])
                boltnut(dbolt=dbolt,cuth=hbase);           
        bayonets() translate([0,0,hmain-wall-.5]) rotate([0,180,-90])
                boltnut(dbolt=ebolt, abolt=90, cuth=5);

     }
}

//Insert();
//HotendMount(separate=1);
//HotendMount(separate=2);
//HotendMount();

module HotendMount(hmain=7+21.4, stw=20, di=12, do=16, hpath=6.2, hsup=10.3, tollerance=.3, separate=0)
translate([0,0,3.15+hmain]) rotate([0,0,120]) rotate([0,0,1.22*0]) {
    difference() {
        union() {
            traptriangle(21.25-tollerance,7.8,7-.2); // base
            translate([0,0,6]) cylinder(d=24,h=hsup-6); // ring
            translate([-stw/2,-5.5-do/2,0])
                cube([stw,5.5,26.8]); // stand
            for(z=[-7.5,7.5]) translate([z,-do/2,hsup/2]) 
                cube([stw-15,5,hsup],center=true);  // stand mating
        }
        union() {
            // wiring
            let(d1=13) translate([0,-d1/2-11.1,11.8])
                cylinder(d=d1, h=20); // stand cable path
            // central hole
            translate([0,0,-1])cylinder(d=di+.2,h=7*2);
            translate([0,0,hpath])cylinder(d=do,h=hsup-hpath+1);
            // cable clamp bolt
            for (z=[-7.5,7.5])
            translate([z,-9.6,24.3]) rotate([-90,0,0])
                boltnut(dbolt=0, bolt=2.3, hbolt=4.5, cuth=4);
            // mount bolts to insert
            bayonets() translate([0,36.5/2,0]) {
                translate([0,0,-1]) cylinder(d=3.5,h=7*2);
                translate([0,0,4.3]) hull() {
                    cylinder(d=6,h=7);
                    translate([0,6,0]) cylinder(d=6,h=7);
                }
            }
            if (separate%2 != 0) // section a
                  translate([-21.25,-tollerance,-.1])
                    cube([21.25*2,21.25,hsup+1]);
            if (separate >= 2) // section b
                  translate([-21.25,-21.25+tollerance,-.1])
                    cube([21.25*2,21.25,hsup+1]);
        }
}
}


