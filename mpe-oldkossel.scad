///
//  Old kossel effector mount
///

//KossInsert();

module KossInsert()
{
    module rcube(c,center=false)
        let(v=c.x>c.y?[1,0,0]:[0,1,0],nv=[1,1,0]-v,o=c*v/2-c*nv/2)
        hull() for(a=[-o,o]) translate(a*v)
            cylinder(d=c*nv,h=c.z,center=center);
    module kossel_mounts(hx=16,$fn=20) {
        cylinder(d=25.1,h=hx,center=true); // center
        translate([0,4.101,0]) // heater pass
            cube([16.4,18,hx],center=true);
        translate([0,-18.5,0]) {  // air duct
            rcube([22+4*0,8,hx],center=true); // 22-reduces
            for(x=[-12,12])for(y=[-6.6,7.41]) // airduct mounts
                translate([x,y,0]) cylinder(d=2.6,h=hx,center=true);
        }
        for(x=[-16.5,16.5])for(y=[-7.9,11.1]) // extruder mounts
            translate([x,y,0]) cylinder(d=3.2,h=hx,center=true);
    }
    translate([0,0,1])
    difference() {
        cylinder(d=50,h=7);
        rotate([0,0,-25]) kossel_mounts();
        translate([0,0,-4-.5])
            bayonets() bayonetpath(d0=50+1,d1=43,cuth=5);   
    }
}

