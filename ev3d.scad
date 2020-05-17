filepath="../../model-kossel/";

///
//    prototypes
/// h=1
module e3dv5()
{
  translate([0,0,1]) // anycubic kossel mount 7->9mm effector correction
  rotate([0,0,180-52])
translate([0,0,69.7]) // size
  translate([0,0,51.7-1.7]) // anycubic kossel mount
  rotate([90,0,90]) translate([4,-64.2,0])
    import(file=str(filepath,"E3Dv5.STL"));
}
//translate([0,0,-18.7]) #cube([5,5,18.7]);


// ANYCUBIC KOSSEL TIP OFFSET 23.2mm from mount plane
// mount ring h=6mm, mount ring d=12mm, c.ring h=55.6 (real55.5)
// heater 20x16x12, offset=5.5 (real5.4), hoffset:43.6 (real44.5)
module e3dv6()
{
 // translate([0,0,2.2])  // kossel offset
  rotate([0,0,-45+4]) translate([0,0,34.7]) 
    {
//            e3dv6a();
            e3dv6b();
//        translate([0,-8.,-45.6])
        translate([0,-8.+1,-45.6])
        rotate([0,90,0]) cylinder(d=6.1,h=22,center=true,$fn=60);
    //translate([0,0,-55.6]) #cube([10,10,55.6]);
    }
}

module e3dv6a()
{
    translate([0,0,7+3]) rotate([180,0,0]) // ring mount correction
        import(file=str(filepath,"E3D_V6.STL"));
}
module e3dv6b()
{
    translate([0,0,-14.65]) rotate([90,0,90])
        import(file=str(filepath,"E3D_V6_1.75mm_Universal_HotEnd_Mockup.STL"));
}
e3dv5();

//#e3dv6_space();
module
e3dv6_space()
{
    translate([0,0,-18.7]) {
        cylinder(d=23,h=18.7);
        sector(165,360-90,20*2,18.7);
        intersection() {
            translate([0,0,.5])cylinder(d=23+10,h=18.7+.5);
            translate([0,0,11]) sphere(d=23+6);
        }
    }
}
