$fa = 1;  
$fs = 0.4;  

difference() {
    cube([67.5, 42.6, 2]);
    
    translate([31.5, 24, -1])
        cylinder(h=4, r=6);

}

    // Indents on top inner long wall
    translate([10, -0.5, 0])
        cube([47, 0.7, 0.8]);

    translate([10, 42.35, 0])
        cube([47, 0.7, 0.8]);