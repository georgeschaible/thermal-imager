$fa = 1;
$fs = 0.4;

module button_insert() {
    difference() {
        // === Base rectangle ===
        cube([10.8, 7.8, 1]);

        // === Triangular prism ===
        translate([9.1, 9, -0.4])
            rotate([90, 0, 0])
            linear_extrude(height=12)
                polygon(points=[[0,0], [2,0], [2,1]]);
    }

    // === Bottom extension ===
    translate([0, 0, -2])
        cube([6, 7.8, 2]);

    // === Rounded top cap ===
    translate([1.5, 1.9, 1])
    minkowski() {
        cube([5.2, 4, 1.4]);
        sphere(r=0.6);
    }
}

// === Create 3 spaced parts ===
for (i = [0:2]) {
    translate([i * (10.8 + 5), 0, 0])
        button_insert();
}
