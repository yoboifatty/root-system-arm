// ============================================================
// joint_base_rotate.scad — BASE ROTATION ROOT NODE
// ------------------------------------------------------------
// The lowest root knot where the arm connects to the base.
// Wider and more stable than other joints, like a main root
// anchoring into the soil. Motor mounts underneath for rotation.
// ============================================================

include <../lib/parts_lib.scad>;

$fn = 128;

// Base rotation knot dimensions — wider and more stable
KNOT_RADIUS_BASE = 40;      // Wider base for stability
KNOT_RADIUS_TOP = 30;       // Top radius
KNOT_HEIGHT = 35;           // Height of the knot

// Branch arm dimensions
BRANCH_THICKNESS_BASE = 16; // Thicker at joint end (more load)
BRANCH_THICKNESS_TIP = 10;  // Thinner at tab end
BRANCH_LENGTH = L1_UPPER_ARM - 50;

// Gear train dimensions — same as shoulder for 30:1 ratio
ZA_P = 14; ZA_W = 84; ZB_P = 16; ZB_W = 80;
d1 = GEAR_MODULE * (ZA_P + ZA_W) / 2;
d2 = GEAR_MODULE * (ZB_P + ZB_W) / 2;
MOT_X = d1 + d2;

module organic_base_knot() {
    difference() {
        union() {
            // Main root knot body — wider, more stable form
            translate([0, 0, 0]) {
                // Base section (widest)
                cylinder(h = KNOT_HEIGHT * 0.4, r1 = KNOT_RADIUS_BASE, r2 = KNOT_RADIUS_BASE * 0.85);
                
                // Middle section (swollen)
                translate([0, 0, KNOT_HEIGHT * 0.4]) {
                    cylinder(h = KNOT_HEIGHT * 0.3, r1 = KNOT_RADIUS_BASE * 0.85, r2 = KNOT_RADIUS_TOP * 1.1);
                }
                
                // Top section (tapering)
                translate([0, 0, KNOT_HEIGHT * 0.7]) {
                    cylinder(h = KNOT_HEIGHT * 0.3, r1 = KNOT_RADIUS_TOP * 1.1, r2 = KNOT_RADIUS_TOP);
                }
            }

            // Organic surface bumps — natural root texture
            translate([KNOT_RADIUS_BASE * 0.6, 0, KNOT_HEIGHT * 0.5]) {
                sphere(r = 9);
            }
            translate([-KNOT_RADIUS_BASE * 0.4, KNOT_RADIUS_BASE * 0.7, KNOT_HEIGHT * 0.3]) {
                sphere(r = 7);
            }
            translate([0, -KNOT_RADIUS_TOP * 0.9, KNOT_HEIGHT * 0.6]) {
                sphere(r = 8);
            }

            // Parent-link mounting tab — connects to base stand (downward)
            translate([-(KNOT_RADIUS_BASE + 12), -TAB_HOLE_DY * 2 - 12, KNOT_HEIGHT / 2 - 6]) {
                hull() {
                    cylinder(h = 10, r1 = BRANCH_THICKNESS_BASE/2, r2 = BRANCH_THICKNESS_TIP/2);
                    translate([-(TAB_W/2 + 10), 0, 0]) cube([TAB_W + 20, TAB_HOLE_DY * 4 + 24, 10]);
                }
            }

            // Child-link mounting tab — connects to shoulder branch (upward)
            translate([MOT_X - KNOT_RADIUS_TOP/2, KNOT_RADIUS_TOP + 10, KNOT_HEIGHT / 2 - 6]) {
                hull() {
                    cylinder(h = 10, r1 = BRANCH_THICKNESS_BASE/2, r2 = BRANCH_THICKNESS_TIP/2);
                    translate([0, TAB_W/2 + 10, 0]) cube([TAB_W, TAB_HOLE_DY * 4 + 24, 10]);
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
                translate([-(KNOT_RADIUS_BASE + 12) + i * TAB_HOLE_DX, -TAB_HOLE_DY * 2 - 12 + j * TAB_HOLE_DY, -2]) {
                    cylinder(h = KNOT_HEIGHT + 6, d = TAP_D);
                }

        for (i = [-1:1:1])
            for (j = [-1:1:1])
                translate([MOT_X - KNOT_RADIUS_TOP/2 + i * TAB_HOLE_DX, KNOT_RADIUS_TOP + 10 + j * TAB_HOLE_DY, -2]) {
                    cylinder(h = KNOT_HEIGHT + 6, d = TAP_D);
                }
    }
}

organic_base_knot();