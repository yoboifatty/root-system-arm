// ============================================================
// joint_elbow.scad — ELBOW ROOT NODE
// ------------------------------------------------------------
// A smaller, more elongated root knot that allows the arm to bend.
// Like a secondary root branching off the main trunk.
// 20:1 gear ratio for faster movement with less torque.
// ============================================================

include <../lib/parts_lib.scad>;

$fn = 128;

// Elbow knot dimensions — smaller and more elongated
KNOT_RADIUS_BASE = 28;      // Smaller than shoulder/base
KNOT_RADIUS_TOP = 20;       // Top radius
KNOT_HEIGHT = 35;           // Height of the knot

// Branch arm dimensions
BRANCH_THICKNESS_BASE = 12; // Thinner than lower joints
BRANCH_THICKNESS_TIP = 7;   // Even thinner at tip
BRANCH_LENGTH = L2_FOREARM - 40;

// Gear train dimensions — 20:1 ratio for elbow
ZA_P = 14; ZA_W = 70; ZB_P = 16; ZB_W = 64;
d1 = GEAR_MODULE * (ZA_P + ZA_W) / 2;
d2 = GEAR_MODULE * (ZB_P + ZB_W) / 2;
MOT_X = d1 + d2;

module organic_elbow_knot() {
    difference() {
        union() {
            // Main root knot body — elongated, smaller form
            translate([0, 0, 0]) {
                // Base section
                cylinder(h = KNOT_HEIGHT * 0.35, r1 = KNOT_RADIUS_BASE, r2 = KNOT_RADIUS_BASE * 0.8);
                
                // Middle section (swollen)
                translate([0, 0, KNOT_HEIGHT * 0.35]) {
                    cylinder(h = KNOT_HEIGHT * 0.3, r1 = KNOT_RADIUS_BASE * 0.8, r2 = KNOT_RADIUS_TOP * 1.1);
                }
                
                // Top section (tapering)
                translate([0, 0, KNOT_HEIGHT * 0.65]) {
                    cylinder(h = KNOT_HEIGHT * 0.35, r1 = KNOT_RADIUS_TOP * 1.1, r2 = KNOT_RADIUS_TOP);
                }
            }

            // Organic surface bumps — natural root texture
            translate([KNOT_RADIUS_BASE * 0.6, 0, KNOT_HEIGHT * 0.4]) {
                sphere(r = 7);
            }
            translate([-KNOT_RADIUS_BASE * 0.5, KNOT_RADIUS_BASE * 0.6, KNOT_HEIGHT * 0.3]) {
                sphere(r = 5);
            }
            translate([0, -KNOT_RADIUS_TOP * 0.8, KNOT_HEIGHT * 0.7]) {
                sphere(r = 6);
            }

            // Parent-link mounting tab — connects to shoulder branch (downward)
            translate([-(KNOT_RADIUS_BASE + 8), -TAB_HOLE_DY * 2 - 8, KNOT_HEIGHT / 2 - 4]) {
                hull() {
                    cylinder(h = 7, r1 = BRANCH_THICKNESS_BASE/2, r2 = BRANCH_THICKNESS_TIP/2);
                    translate([-(TAB_W/2 + 6), 0, 0]) cube([TAB_W + 12, TAB_HOLE_DY * 4 + 16, 7]);
                }
            }

            // Child-link mounting tab — connects to wrist branch (upward)
            translate([MOT_X - KNOT_RADIUS_TOP/2, KNOT_RADIUS_TOP + 6, KNOT_HEIGHT / 2 - 4]) {
                hull() {
                    cylinder(h = 7, r1 = BRANCH_THICKNESS_BASE/2, r2 = BRANCH_THICKNESS_TIP/2);
                    translate([0, TAB_W/2 + 6, 0]) cube([TAB_W, TAB_HOLE_DY * 4 + 16, 7]);
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
                translate([-(KNOT_RADIUS_BASE + 8) + i * TAB_HOLE_DX, -TAB_HOLE_DY * 2 - 8 + j * TAB_HOLE_DY, -2]) {
                    cylinder(h = KNOT_HEIGHT + 6, d = TAP_D);
                }

        for (i = [-1:1:1])
            for (j = [-1:1:1])
                translate([MOT_X - KNOT_RADIUS_TOP/2 + i * TAB_HOLE_DX, KNOT_RADIUS_TOP + 6 + j * TAB_HOLE_DY, -2]) {
                    cylinder(h = KNOT_HEIGHT + 6, d = TAP_D);
                }
    }
}

organic_elbow_knot();