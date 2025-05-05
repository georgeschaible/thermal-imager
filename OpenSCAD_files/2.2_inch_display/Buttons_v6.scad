$fa = 1;
$fs = 0.4;

module button_insert() {
    difference() {
        // === Base rectangle ===
        cube([10.4, 7.6, 1]);

        // === Triangular prism ===
        translate([8.6, 9, -0.4])
            rotate([90, 0, 0])
            linear_extrude(height=12)
                polygon(points=[[0,0], [2,0], [2,1]]);
    }

    // === Bottom extension ===
    translate([0, 0, -1.0])
        cube([6, 7.6, 1.2]);

    // === Rounded top cap ===
    translate([1.7, 1.9, 1])
    minkowski() {
        cube([5, 3.8, 1.4]);
        sphere(r=0.6);
    }
}

// === Create 3 spaced parts ===
for (i = [0:2]) {
    translate([i * (10.8 + 5), 0, 0])
        button_insert();
}
