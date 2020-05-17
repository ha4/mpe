filepath="../mpe-kossel/";

module mpe_effector()
{
import(file=str(filepath,"Multi-effector-V2_0.1.stl"));
}

module mpe_springring() 
{
rotate([0,0,9.2])
translate([.11,2,0])
import(file=str(filepath,"springring_E3DV6.stl"));

///#cylinder(d=23.0,h=5,$fn=72);
}

module mpe_fanduct()
{
rotate([0,180,9.9-1])
translate([-.17,0,0])
import(convexity=30,file=str(filepath,"Coolingfan_duct_2.01.stl"));

//#translate([24.626,4.297,0]) cylinder(d=3.5,h=30,center=true,$fn=36);
}

module mpe_insert()
{
rotate([0,0,9.9-1])
translate([0.0005,0.0007,3.15])
import(convexity=30,file=str(filepath,"insert_5.08_E3DV6.stl"));
//#translate([-0.721,18.241,0]) cylinder(d=3.38,h=50,$fn=48);
}

module mpe_hotendmountasm()
{
    rotate([0,0,7.5986-1])
    translate([-4.772,-5.643,31.485])
    import(convexity=30,file=str(filepath,"Hotend_mount_1.04.stl"));
    //#cylinder(d=12.193,h=80,$fn=48);
    //#translate([-50,-100-.097,0]) cube(100);
}

module mpe_hotendmount1()
    rotate([0,0,2.25]) intersection() {
        translate([-22,-13.82-.097,0]) cube([44,13.82,100]);
        mpe_hotendmountasm();
        //#cylinder(d=12.193,h=80,$fn=48);
        //#translate([7.5,0,55.845]) rotate([90,0,0])
        //        cylinder(d=2.2,h=50,center=true,$fn=36);
    }

module mpe_hotendmount2()
    rotate([0,0,2.25])translate([-1.166,-4.15,0])
    intersection() {
        translate([-22,4.146,0]) cube([44,21.068,100]);
        mpe_hotendmountasm();
    }

module mpe_hotendmount3()
    rotate([0,0,2.25])translate([-1.77,0,20.85])
    intersection() {
        translate([-22,-22.26,0]) cube([44,5.3,100]);
        mpe_hotendmountasm();
    }

module mpe_insertpen()
{
    rotate([0,0,0])
    translate([0,0,0])
    import(convexity=10,file=str(filepath,"Insert_for_pen.stl"));
}
