//bayonet angular parameters

function abayonet(sz=91,tol=0.7,lock=41,astop=4,ofs=24) = 
    let(nl=sz-lock)
 [ofs,           // 0         bayonet start 
  ofs+nl,          // 1   49.87 spring start, baoyonet end
  ofs+lock+tol,    // 2 * 41.51 lock start, moved:0.51
  ofs+nl+astop,    // 3   53.87 pin pos, 12.36 to lock 
  ofs+lock+nl-tol, // 4 * 90.3  lock end, moved:49.3, sz:48.79 (tol0.51)
  ofs+sz,          // 5   90.87 spring end, spring-pin: 37
  ofs+sz+tol*2];   // 6   91    spring fixation

//rotate([0,0,-21])
springlock($fn=64);
//springbase($fn=64,dtension=0);
//rotate([0,0,41])
//#bayonetpath($fn=64);

module
ringsector2d(ls,le,d1,d2)
intersection() {
    difference() {circle(d=d2); circle(d=d1);}
    rotate([0,0,ls])translate([-d2,0])square(d2*2);
    rotate([0,0,le])translate([-d2,-d2*2])square(d2*2);        
}

function center2pr(p1,p2,r) = let(c1=(p1+p2)/2, c=p2-p1, n=[c.y,-c.x], 
		nn=norm(n), h=nn/2, y=r<h?0:sqrt(r*r-h*h), ofs=nn==0?[0,0]:y/nn*n) c1-ofs;

//circle2rtest([-1,3.5],[-1.7,-2.8],20);
module
circle2rtest(p1,p2,r)
{
    c=center2pr(p1,p2,r);
    color("blue")translate(p1) circle(r=.5);
    color("red")translate(p2) circle(r=.5);
    #translate(c) circle(r=r,$fn=33);
}

function sincos(a)=[cos(a),sin(a)];

// bayonet locks
//
// la: circle sector angle  lstopp: diameter
// d0: mount outer cylinder
// d1: mount free pass hole
module
springlock(d0=60+2,d1=54,lh=3,dstopp=4,bsz=90.87,anglelock=41)
{
    soffs=180*dstopp/d1/3.1415926535;
    bangular=abayonet(/*sz=bsz,lock=anglelock/*,astop=soffs*/);
    sq=1.35;
    lin=d1+1.05;
    lout=d1+2.31;
    p1=sincos(bangular[3])*lin/2;
    p2=sincos(bangular[4])*lout/2;
    ax=center2pr(p1,p2,(lin+lout)/4);

    linear_extrude(height=lh,convexity=5)
    difference() {
        // lock base sector
        ringsector2d(bangular[2],bangular[4],d1,d0,$fn=72);
        // lock stopper
        rotate([0,0,bangular[3]]) translate([d1/2,0])
            circle(d=dstopp,$fn=36);
        // lock entrace radius from enter to stopper
        intersection(){ rotate([0,0,bangular[3]])square(lout/2);
        translate(ax)circle(d=(lin+lout)/2); }
        //ringsector2d(bangular[3],bangular[4],0,lin);
        // lock chamfer
        rotate([0,0,bangular[4]]) translate([lout/2-.2,0])
            rotate([0,0,45]) square(sq+.2,center=true);
    }
        // Rin=56.2 Rout=55.2 OR translatex=-1,R=55.5
        // translate([-1,0]) ringsector2d(bangular[3],bangular[4],0,lin,$fn=72);
    //translate(p1)circle(r=0.1);
    //translate(p2)circle(r=0.1);
}


module
springs(d1,h,lstopp,spring,dtension)
{
    bangular=abayonet();

    tol=.2;
    soffs=180*(lstopp-tol)/d1/3.1415926535; // spring offset to stopper pin
    sr=(d1+dtension)/2-spring;
    rotate([0,0,bangular[3]]) translate([sr+spring,0,0])
        cylinder(d=lstopp-tol,h=h,$fn=24); // stopper
    rotate([0,0,bangular[3]-soffs])
      rotate_extrude(angle=bangular[5]-bangular[3]+soffs)
        translate([sr,0,0]) square([spring,h]); // spring itself

}

module
springbase(d0=60,d1=54,h=3.15,hs=2.6,dlock=4)
{
    bangular=abayonet();
    tol=.18;

    ai=bangular[0];
    ab=bangular[1];
    ls=bangular[3];
    ae=bangular[5];

    lstopp=4;
    spring=5/4 * lstopp/2; // spring thinkess
    bgap=2.15;
    sgap=1.75;
    egap=2.25;
    stension=1.0;
    sd=d1+stension-spring*2;

    linear_extrude(height=h, convexity=9)
    difference() {
        circle(d=d0-tol);
        ringsector2d(ls,ae,sd-sgap*2,d0);
        rotate([0,0,ab])translate([sd/2-egap,-egap,0])
            square(10);
        ringsector2d(ai, ab,d1-bgap,d0);
    }

    springs(d1, hs, lstopp, spring, stension);
}


module
bayonetpath(d0=60+2,d1=54,cuth=4) {
   bangular=abayonet();

    rotate([0,0,bangular[0]]) let(sz=(d0-d1)/2)
        rotate_extrude(angle=bangular[1]-bangular[0],convexity=3)
            translate([d1/2,0,0]) square([sz,cuth]);

}
