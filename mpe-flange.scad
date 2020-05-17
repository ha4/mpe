///
//  TubeFlange
///

module
TubeFlange(wall=1.5, aflange=30, szflange=33, fanoffs=0, fanmnt=25, fanbolt=3.2, htube=8, tube=13.2, tex=15.5, trifl=3, support=true)
{
    fsz=szflange;
    fa=aflange;
    fh=fsz*cos(fa);
    diam=fsz-6;
    centr=[0,-2*wall,fsz/2-fanoffs];

    // intersection cylinder&sphere
    module cyls(d,h,hmin) let(dsph=d*d/4/(h-hmin)+h-hmin) intersection() {
        cylinder(d=d,h=h);   translate([0,0,h-dsph/2]) sphere(d=dsph); }
    module tapermnt(d,h,t) { // taper C=2tg(a/2)
        cylinder(d1=d,d2=d+h*t,h=h);
        translate([0,0,h-.002])cylinder(d=d+h*t,h);
        } 
    module fxbase() {
        // flange
        rotate([-fa,0,0])
            translate([-fsz/2,-2*wall,0]) {
                cube([fsz,wall,fh-wall]);
                // print support
                if(support)translate([0,0,fh-wall-.1]) rotate([fa,0,0])
                    cube([fsz,0.5,(htube+wall+.24)/cos(fa)]);
            }
        // bolt enforcener
        rotate([-fa,0,0]) translate(centr) rotate([180-90,0,0])
          for(ra=[0,90,180,270]) rotate([0,0,ra])
            translate([fanmnt/2,fanmnt/2,-wall]) 
                cyls(6.5,wall*1.5,wall);
        // transition
        hull() {
          rotate([-fa,0,0])
            translate(centr) rotate([-90,0,0]) cylinder(d=diam+2*wall,h=wall);
          translate([0,0,fh])cylinder(d=tube,h=wall);
        }
        // tube
        translate([0,0,fh]) cylinder(d=tube,h=htube);
        // locks
        for(z=[fh+trifl,fh+2*trifl])
            translate([0,0,z]) rotate_extrude(convexity=5) 
                translate([tube/2,0,0]) circle(r=(tex-tube)/4);     
    }
    
      difference() {
        // flange
        fxbase();
        // holes
        taper=2; // 90 degree taper
        rotate([-fa,0,0]) translate(centr+[0,wall,0]) rotate([180-90,0,0]) {
            translate([0,0,-.1])
                cylinder(d=diam-wall/2,h=wall+.3);
            for(ra=[0,90,180,270]) rotate([0,0,ra]) {
              translate([fanmnt/2,fanmnt/2,-.1])
                cylinder(d=fanbolt,h=wall+1); 
              translate([fanmnt/2,fanmnt/2,.5])       
                tapermnt(fanbolt, wall-.3, taper);
            }
        }
        //transition
        hull() {
          rotate([-fa,0,0])
            translate(centr) rotate([-90,0,0]) cylinder(d=diam-wall,h=wall);
          translate([0,0,fh])cylinder(d=tube-1.5*wall,h=wall/2);
        }
        // duct
        translate([0,0,fh]) cylinder(d=tube-1.5*wall,h=htube+.1);
        // section test
        ///translate([0,-70,0])cube([140,140,140]);
    }
}
