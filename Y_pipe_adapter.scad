/* [General] */

// Adapter thickness (mm)
thickness = 1; 

// Length of the attachments (mm)
attachments_length=25; 

/* [Y Section] */
// Are you specifying the inner or the outer diameter?
diameter_type_y=0; // [0:Inner, 1:Outer]

// Diameter of the Y section (mm)
diameter = 30;

// Length of the lower part of the Y (mm)
length_lower = 45;

// Length of the upper parts of the Y (mm)
length_upper = 55;

// Angle of the Y (degrees)
angle = 70;

/* [Bottom attachment] */
// Do you want the bottom attachment?
include_bottom_attachment=true;

// Are you specifying the inner or the outer diameter?
diameter_type_bottom=0; // [0:Inner, 1:Outer]

// Diameter of the bottom attachment (mm)
diameter_bottom = 35;

// Taper of the bottom attachment (tenth mm)
taper_bottom_size = 0; // [-10:10]
taper_bottom = taper_bottom_size / 10;

/* [Top left attachment] */
// Do you want the top left attachment?
include_topleft_attachment=true;

// Are you specify the inner or the outer diameter?
diameter_type_topleft=0; // [0:Inner, 1:Outer]

// Diameter of the top left attachment (mm)
diameter_topleft = 35;

// Taper of the top left attachment (mm)
taper_topleft_size = 0; // [-8:8]
taper_topleft = taper_topleft_size / 10;

/* [Top right attachment] */
// Do you want the top right attachment?
include_topright_attachment=true;

// Are you specifying the inner or the outer diameter?
diameter_type_topright=0; // [0:Inner, 1:Outer]

// Diameter of the top right attachment (mm)
diameter_topright = 35;

// Taper of the top right attachment (mm)
taper_topright_size = 0; // [-10:10]
taper_topright = taper_topright_size / 10;

/* [Hidden] */

// Minimum angle
$fa = 4;

// Minimum size
$fs = 1;

module YSolid(d=30, lower_len=40, upper_len=60, angle=35)
{
    union()
    {
        cylinder(h=lower_len, d=d);
        
        translate([0, 0, lower_len])
            rotate([0, angle/2, 0])
                cylinder(h=upper_len, d=d);
        
        translate([0, 0, lower_len])
            rotate([0, -angle/2, 0])
                cylinder(h=upper_len, d=d);
    }
}

module YAdapter(d=30, lower_len=40, upper_len=60, angle=35, thickness=1)
{
    difference()
    {
        YSolid(
            d=d, 
            lower_len=lower_len, 
            upper_len=upper_len, 
            angle=angle);
        
        translate([0, 0, -1])
            YSolid(
                d=d - thickness * 2, 
                lower_len=lower_len + 1, 
                upper_len=upper_len + 1, 
                angle=angle);
    }
}

module Attachment(thickness=1, d1=10, d2=20, length=30, base_length=5, taper=3)
{
    r1 = d1/2;
    r2 = d2/2;
    
    shape = [
        [r1, 0],
        [r2, base_length],
        [r2 - taper, base_length + length],
        [r2 - taper - thickness*2, base_length + length],
        [r2 - thickness*2, base_length],
        [r1 - thickness*2, 0],
    ];
    
    rotate_extrude(angle=360)
    {
        polygon(shape);
    }
}

d = diameter_type_y == 1
        ? diameter
        : diameter + thickness * 2;

d_b = diameter_type_bottom == 1
        ? diameter_bottom
        : diameter_bottom + thickness * 2;

d_tl = diameter_type_topleft == 1
        ? diameter_topleft
        : diameter_topleft + thickness * 2;

d_tr = diameter_type_topright == 1
        ? diameter_topright
        : diameter_topright + thickness * 2;

YAdapter(
    d = d,
    lower_len = length_lower,
    upper_len = length_upper,
    angle = angle,
    thickness = thickness
);

if(include_bottom_attachment)
{
    translate([0, 0, 0.01])
        rotate([180, 0, 0])
        Attachment(
            thickness = thickness,
            d1 = d,
            d2 = d_b,
            length = attachments_length,
            taper = taper_bottom
        );
}

if(include_topleft_attachment)
{
    l_u = length_upper - 0.1;
    
    translate([
        l_u * sin(-angle/2), 
        0,
        length_lower + l_u * cos(-angle/2),
    ])
        rotate([0, -angle / 2, 0])
            Attachment(
                thickness = thickness,
                d1 = d,
                d2 = d_tl,
                length = attachments_length,
                taper = taper_topleft
            );
}

if(include_topright_attachment)
{
    l_u = length_upper - 0.1;
    
    translate([
        l_u * sin(angle/2), 
        0,
        length_lower + l_u * cos(angle/2),
    ])
        rotate([0, angle / 2, 0])
            Attachment(
                thickness = thickness,
                d1 = d,
                d2 = d_tr,
                length = attachments_length,
                taper = taper_topright
            );
}
