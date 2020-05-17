

module d2hw_a201d()
{
    fp=11.2;
    op=10.4; // travel 0.8mm
    di=1.7;
    hb=7;
    translate([-13.3/2,-5.3/2,.5])
        color([.2,.2,.2])cube([13.3,5.3,6.5]);
    for(i=[-1,0,1]) translate([5.08*i,0,-2.5]) cylinder(d=.8,h=3);
    translate([4,0,hb]) {
        color([.2,.2,.2]) { cylinder(d=di,h=fp-hb-di/2,$fn=10);
            cylinder(d1=5.3,d2=di*2.5,h=(fp-hb)/4);
            translate([0,0,fp-hb-di/2]) sphere(d=di,$fn=10); }
        color([.2,.2,.5]) { cylinder(d=di*1.5,h=(fp-hb)/1.5);
            cylinder(d=di*2.2,h=(fp-hb)/2);
        }
    }
}

module d2hw_pcb()
{
    pcbh=1.7;
    pcbsz=12.7;
    rotate([180,0,0]) d2hw_a201d();
    color([.2,.6,.2]) translate([0,0,pcbh/2])
        difference() { cube([pcbsz,pcbsz,pcbh],center=true);
            for(i=[-1,1]) translate([0,5.08*i,0]) 
                cylinder(d=2.5,h=pcbh*2,center=true,$fn=12);
        }
}

module d2hw_pcbholder(h=28)
{
    pcbh=1.7;
    pcbsz=12.7;
    ofs=4;
    szx=pcbsz+6;
    szy=pcbsz+6;
    mnth=4;
    
    module frame1() {
        let(d=10) hull() for(x=[-1,1]) for(y=[-1,1])
                translate([x*(szx-d)/2-ofs,y*(szy-d)/2,0]) cylinder(d=d,h=h,$fn=25);
    }
    module frame2() {
        translate([0,0,h-mnth]) cylinder(d=35,h=mnth,$fn=90);
    }
    module pcbmnt() {
        tol=0.5;
        dm=5.08;
        th=10;
        pcbx=pcbsz+tol;
        
        for(x=[-ofs]) for(y=[-dm,dm])
            translate([x,y,0]) cylinder(d=2,h=th,$fn=12);
        translate([-ofs,0,0]) {
            cube([pcbx,pcbsz+tol,pcbh*2],center=true);
            cube([pcbx,dm,th], center=true);
        }
        hull() {
            translate([0,0,th/2-.5]) cylinder(d1=5,d2=12,h=1+h-th/2,$fn=30);
            translate([-ofs-pcbx/2,-dm/2,th/2]) cube([pcbx,dm,th/4]);
        }
    }
    module bevl() {
        translate([0,0,h]) rotate([180,0,0]) 
        bevel(mnth,10,3.2,10) 
        rotate([180,0,0]) translate([0,0,-h]) frame1();
    }
    module bolts() {
        for(a=[0,120,240]) rotate([0,0,a]) translate([30/2,0,0]) {
            cylinder(d=3.5,h=h+1,$fn=15);
            cylinder(d=6.5,h=h-3);
        }
    }
    difference() {
        union() { frame1(); frame2(); bevl(); }
        pcbmnt();
        bolts();
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

//translate([-4,0,0]) d2hw_pcb();
//intersection()
{
//   translate([-100*0,-50,0]) cube([100,100,100]);
    d2hw_pcbholder(21);
}

