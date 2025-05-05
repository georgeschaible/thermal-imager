$fa = 1;  
$fs = 0.4;  

// === Case dimensions ===
case_length = 72;   // X
case_width  = 46;   // Y
case_height = 25;   // Z
wall = 2;         // Wall thickness
rounding = 2;       // Radius for corner rounding

module rounded_box(size, radius) {
    difference() {
        minkowski() {
            cube([size[0] - 2*radius, size[1] - 2*radius, size[2] - radius]);
            translate([radius, radius, radius])
                sphere(r=radius, $fn=32);
        }
    }
}

difference() {
    
    // === Outer shell ===
    rounded_box([case_length, case_width, case_height], rounding);

    // === Hollow interior ===
    translate([wall, wall, wall])
        cube([
            case_length - 2 * wall,
            case_width  - 2 * wall,
            case_height + 1
        ]);

    // === LCD screen window ===
    translate([9, 4.2, -1])
        cube([48, 37, 4]);

    // === Button cutouts and indents ===
    translate([62.6, 7.8, -1])
        cube([7.6, 6.2, 4]);
    translate([59, 7, 1.1])
        cube([12, 8, 4.5]);

    translate([62.6, 18.3, -1])
        cube([7.6, 6.2, 4]);
    translate([59, 17.5, 1.1])
        cube([12, 8, 4.5]);

    translate([62.6, 28.8, -1])
        cube([7.6, 6.2, 4]);
    translate([59, 28, 1.1])
        cube([12, 8, 4.5]);


    // === Toggle switch wires ===
    translate([-2, 23.5, 15])
        rotate([0, 90, 0])
            cylinder(h=5, r=7);

    // === microSD slot ===
    translate([69, 19, 6])
        rotate([90, 0, 90])
            cube([15, 2, 4]);
    translate([73, 19, 7.8])
        rotate([-90, 0, 90])
            difference() {
            minkowski() {
                cube([15, 1.5, 1]);
                sphere(r=.6, $fn=24); 
        }
    }

    // === Micro USB port cutout ===
    translate([24.5, case_width - 3, 10])
        rotate([-90, 0, 0])
            cube([9, 4, 3]);
    translate([24, case_width, 10.5])
        rotate([-90, 0, 0])
        difference() {
        minkowski() {
            cube([10, 5, 2]);
            sphere(r=1, $fn=24); 
        }
    }
    
    // === Micro USB groove ===
    translate([23.5, 43.5, 5])
        cube([16, 1, 25]);
    
    // === Reset button ===
    translate([8.5, 43.5, 6])
        cube([5, 5, 2]);
    
    // Indents on top inner long wall
    translate([8, 1.5, 24.5])
        cube([55, 1, 1]);

    translate([8, 43.6, 24.5])
        cube([55, 1, 1]);

}

difference() {
    // === Toggle switch box ===
    translate([-16, 0, 0])
        rounded_box([20, 46, 25], rounding);
    
    // === Slice intrusion ===
    translate([2, 2, 2])
        cube([4,42,25]);

    // === Hollow toggle interior ===
    translate([-14, 3, 2])
        cube([22,41,23]);
        
    // === Toggle switch cutout ===
    translate([-16, 13, 8])
        cube([4, 20, 12]);
}


// === Square supports between buttons ===
translate([64.1, 15, 2])
    cube([6, 2.5, 3]);

translate([64.1, 25.5, 2])
    cube([6, 2.5, 3]);

// === Square supports and hollow screw posts ===
translate([64.1, wall, 1.5])
difference() {
    union() {
        translate([0, 0, 0.5]) cube([6, 5, 3]);
        translate([2.7, 2.5, 0]) cylinder(h=3, r=2);
    }
    translate([2.7, 2.5, -1.5]) cylinder(h=8, r=1);
}

translate([64.1, 39, 1.5])
difference() {
    union() {
        translate([0, -1, 0.5]) cube([6, 6, 3]);
        translate([2.7, 2, 0]) cylinder(h=2, r=2);
    }
    translate([2.7, 2, -1.5]) cylinder(h=8, r=1);
}

translate([2.1, wall, 1.5])
difference() {
    union() {
        translate([0, 0, 0.5]) cube([5.5, 6, 3]);
        translate([3, 2.5, 0]) cylinder(h=3, r=2);
    }
    translate([3, 2.5, -1.5]) cylinder(h=8, r=1);
}

translate([2.1, 39, 1.5])
difference() {
    union() {
        translate([0, -1, 0.5]) cube([5.5, 6, 3]);
        translate([3, 2, 0]) cylinder(h=3, r=2);
    }
    translate([3, 2, -1.5]) cylinder(h=8, r=1);
}

  
// Tetrahedron supports
// Bottom-left corner
translate([1.5, 1.5, 24.5])
hull() {
    translate([0, 0, 0]) sphere(0.1);
    translate([3, 0, 0]) sphere(0.1);
    translate([0, 3, 0]) sphere(0.1);
    translate([0, 0, -3]) sphere(0.1);
}

// Bottom-right corner
translate([70.5, 1.5, 24.5])
hull() {
    translate([0, 0, 0]) sphere(0.1);
    translate([-3, 0, 0]) sphere(0.1);
    translate([0, 3, 0]) sphere(0.1);
    translate([0, 0, -3]) sphere(0.1);
}

// Top-left corner
translate([1.5, 44.5, 24.5])
hull() {
    translate([0, 0, 0]) sphere(0.1);
    translate([3, 0, 0]) sphere(0.1);
    translate([0, -3, 0]) sphere(0.1);
    translate([0, 0, -3]) sphere(0.1);
}

// Top-right corner
translate([70.5, 44.5, 24.5])
hull() {
    translate([0, 0, 0]) sphere(0.1);
    translate([-3, 0, 0]) sphere(0.1);
    translate([0, -3, 0]) sphere(0.1);
    translate([0, 0, -3]) sphere(0.1);
}

