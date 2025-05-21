$fa = 1;  
$fs = 0.4;  

difference() {
    cube([67.5, 41.6, 2]);
    
    translate([32, 22, -1])
        cylinder(h=4, r=5.6);

}

    // Indents on top inner long wall
    translate([10, -0.5, 0])
        cube([47, 0.7, 0.8]);

    translate([10, 41.4, 0])
        cube([47, 0.7, 0.8]);