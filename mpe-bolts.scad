use <mpe-util.scad>


module
boltpass(circularsz=50,bolt=3.5,cuth=4)
{
    bsectr=lenangle(bolt,circularsz)/2; // bolt sector
    // bolts cut
    ringsector(-bsectr,bsectr,
        circularsz-bolt,circularsz+bolt,cuth,true);
}


module
boltend(dbolt=50,bolt=3.5,hbolt=6.4,abolt=9.4,lh=3, cuth=4)
{
    translate([dbolt/2,0,0]) cylinder(d=bolt, h=cuth*3, center=true, $fn=12);
    translate([dbolt/2,0,-.5]) cylinder(d=hbolt, h=cuth-lh+.5, $fn=12);
}

module
boltnut(dbolt=50,bolt=3.5,hbolt=6.4,abolt=9.4, cuth=4)
{
    translate([dbolt/2,0,0]) cylinder(d=bolt, h=cuth*3, center=true,$fn=12);
    translate([dbolt/2,0,0]) rotate([0,0,30])cylinder(d=hbolt, h=cuth, $fn=6);
}
