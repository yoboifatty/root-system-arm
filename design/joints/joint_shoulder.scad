// ============================================================
// joint_shoulder.scad — SHOULDER ROOT NODE
// ------------------------------------------------------------
// A swollen root knot where the main trunk splits into branches.
// Organic, irregular surface with natural curves and tapers.
// Motor mounts underneath; gears sit inside the node cavity.
// ============================================================

include <../lib/parts_lib.scad>;

$fn = 128;  // High resolution for smooth organic surfaces

// Root knot dimensions — swollen, irregular form
KNOT_RADIUS_BASE = 35;      // Base radius of the root knot (wider)
KNOT_RADIUS_TOP = 25;       // Top radius (narrower)
KNOT_HEIGHT = 40;           // Height of the knot

// Branch arm dimensions — tapered, curved roots
BRANCH_THICKNESS_BASE = 14; // Thickness at joint end (thicker)
BRANCH_THICKNESS_TIP = 8;   // Thickness at tab end (thinner)
BRANCH_LENGTH = L1_UPPER_ARM - 50; // Length of the branch arm

// Gear train dimensions
ZA_P = 14; ZA_W = 84; ZB_P = 16; ZB_W = 80; // Shoulder: 30:1 ratio
d1 = GEAR_MODULE * (ZA_P + ZA_W) / 2;       // Motor to intermediate axis
d2 = GEAR_MODULE * (ZB_P + ZB_W) / 2;       // Intermediate to joint axis
MOT_X = d1 + d2;                            // Motor center position

// Organic surface irregularity — makes it look alive, not machined
module organic_knot() {
    difference() {
        union() {
            // Main root knot body — tapered cylinder with organic swelling
            translate([0, 0, 0]) {
                // Base section (wider)
                cylinder(h = KNOT_HEIGHT * 0.3, r1 = KNOT_RADIUS_BASE, r2 = KNOT_RADIUS_BASE * 0.9);
                
                // Middle section (swollen like a root knot)
                translate([0, 0, KNOT_HEIGHT * 0.3]) {
                    cylinder(h = KNOT_HEIGHT * 0.4, r1 = KNOT_RADIUS_BASE * 0.9, r2 = KNOT_RADIUS_TOP * 1.2);
                }
                
                // Top section (tapering)
                translate([0, 0, KNOT_HEIGHT * 0.7]) {
                    cylinder(h = KNOT_HEIGHT * 0.3, r1 = KNOT_RADIUS_TOP * 1.2, r2 = KNOT_RADIUS_TOP);
                }
            }

            // Organic surface bumps — makes it look like a real root knot
            translate([KNOT_RADIUS_BASE * 0.7, 0, KNOT_HEIGHT * 0.4]) {
                sphere(r = 8);
            }
            translate([-KNOT_RADIUS_BASE * 0.5, KNOT_RADIUS_BASE * 0.6, KNOT_HEIGHT * 0.3]) {
                sphere(r = 6);
            }
            translate([0, -KNOT_RADIUS_TOP * 0.8, KNOT_HEIGHT * 0.6]) {
                sphere(r = 7);
            }

            // Parent-link mounting tab — root branch extending down and back
            translate([-(KNOT_RADIUS_BASE + 10), -TAB_HOLE_DY * 2 - 10, KNOT_HEIGHT / 2 - 5]) {
                hull() {
                    cylinder(h = 8, r1 = BRANCH_THICKNESS_BASE/2, r2 = BRANCH_THICKNESS_TIP/2);
                    translate([-(TAB_W/2 + 8), 0, 0]) cube([TAB_W + 16, TAB_HOLE_DY * 4 + 20, 8]);
                }
            }

            // Child-link mounting tab — root branch extending up and forward
            translate([MOT_X - KNOT_RADIUS_TOP/2, KNOT_RADIUS_TOP + 8, KNOT_HEIGHT / 2 - 5]) {
                hull() {
                    cylinder(h = 8, r1 = BRANCH_THICKNESS_BASE/2, r2 = BRANCH_THICKNESS_TIP/2);
                    translate([0, TAB_W/2 + 8, 0]) cube([TAB_W, TAB_HOLE_DY * 4 + 20, 8]);
                }
            }
        }

        // Blind rod pockets — where steel rods press-fit in from above
        translate([d2, 0, -1]) cylinder(h = KNOT_HEIGHT - 6 + 1, d = ROD_D + BORE_CLR);   // Intermediate rod
        translate([0,  0, -1]) cylinder(h = KNOT_HEIGHT - 6 + 1, d = ROD_D + BORE_CLR);   // Output / joint axis

        // Motor shaft pass-through — motor hangs below the node
        translate([MOT_X, 0, -2]) cylinder(h = KNOT_HEIGHT + 4, d = SHAFT_D + 1.5);

        // Motor corner screws — M3 tap-in-plastic on measured pattern
        for (i = [-1:1:1])
            for (j = [-1:1:1])
                translate([MOT_X + i * MOTOR_HOLE_SPACING / 2, j * MOTOR_HOLE_SPACING / 2, -2]) {
                    cylinder(h = KNOT_HEIGHT + 6, d = TAP_D);
                }

        // Tab holes (both tabs) — M3 tap-in-plastic
        for (i = [-1:1:1])
            for (j = [-1:1:1])
                translate([-(KNOT_RADIUS_BASE + 10) + i * TAB_HOLE_DX, -TAB_HOLE_DY * 2 - 10 + j * TAB_HOLE_DY, -2]) {
                    cylinder(h = KNOT_HEIGHT + 6, d = TAP_D);
                }

        for (i = [-1:1:1])
            for (j = [-1:1:1])
                translate([MOT_X - KNOT_RADIUS_TOP/2 + i * TAB_HOLE_DX, KNOT_RADIUS_TOP + 8 + j * TAB_HOLE_DY, -2]) {
                    cylinder(h = KNOT_HEIGHT + 6, d = TAP_D);
                }
    }
}

organic_knot();