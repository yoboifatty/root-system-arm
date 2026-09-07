// ============================================================
// joint_wrist.scad — WRIST ROOT NODE
// ------------------------------------------------------------
// The smallest, most delicate root knot at the end of the arm.
// Like a fine root tip that can rotate and manipulate objects.
// 15:1 gear ratio for fastest movement with least torque.
// ============================================================

include <../lib/parts_lib.scad>;

$fn = 128;

// Wrist knot dimensions — smallest of all joints
KNOT_RADIUS_BASE = 22;      // Smallest base radius
KNOT_RADIUS_TOP = 16;       // Top radius
KNOT_HEIGHT = 30;           // Height of the knot

// Branch arm dimensions
BRANCH_THICKNESS_BASE = 10; // Thinnest at joint end
BRANCH_THICKNESS_TIP = 6;   // Very thin at tip
BRANCH_LENGTH = GRIPPER_EXT - 30;

// Gear train dimensions — 15:1 ratio for wrist
ZA_P = 14; ZA_W = 70; ZB_P = 16; ZB_W = 48;
d1 = GEAR_MODULE * (ZA_P + ZA_W) / 2;
d2 = GEAR_MODULE * (ZB_P + ZB_W) / 2;
MOT_X = d1 + d2;

module organic_wrist_knot() {
    difference() {
        union() {
            // Main root knot body — small, delicate form
            translate([0, 0, 0]) {
                // Base section
                cylinder(h = KNOT_HEIGHT * 0.35, r1 = KNOT_RADIUS_BASE, r2 = KNOT_RADIUS_BASE * 0.75);
                
                // Middle section (swollen)
                translate([0, 0, KNOT_HEIGHT * 0.35]) {
                    cylinder(h = KNOT_HEIGHT * 0.3, r1 = KNOT_RADIUS_BASE * 0.75, r2 = KNOT_RADIUS_TOP * 1.1);
                }
                
                // Top section (tapering)
                translate([0, 0, KNOT_HEIGHT * 0.65]) {
                    cylinder(h = KNOT_HEIGHT * 0.35, r1 = KNOT_RADIUS_TOP * 1.1, r2 = KNOT_RADIUS_TOP);
                }
            }

            // Organic surface bumps — natural root texture
            translate([KNOT_RADIUS_BASE * 0.6, 0, KNOT_HEIGHT * 0.4]) {
                sphere(r = 5);
            }
            translate([-KNOT_RADIUS_BASE * 0.5, KNOT_RADIUS_BASE * 0.6, KNOT_HEIGHT * 0.3]) {
                sphere(r = 4);
            }
            translate([0, -KNOT_RADIUS_TOP * 0.8, KNOT_HEIGHT * 0.7]) {
                sphere(r = 5);
            }

            // Parent-link mounting tab — connects to elbow branch (downward)
            translate([-(KNOT_RADIUS_BASE + 6), -TAB_HOLE_DY * 2 - 6, KNOT_HEIGHT / 2 - 3]) {
                hull() {
                    cylinder(h = 6, r1 = BRANCH_THICKNESS_BASE/2, r2 = BRANCH_THICKNESS_TIP/2);
                    translate([-(TAB_W/2 + 4), 0, 0]) cube([TAB_W + 8, TAB_HOLE_DY * 4 + 12, 6]);
                }
            }

            // Child-link mounting tab — connects to gripper (upward)
            translate([MOT_X - KNOT_RADIUS_TOP/2, KNOT_RADIUS_TOP + 4, KNOT_HEIGHT / 2 - 3]) {
                hull() {
                    cylinder(h = 6, r1 = BRANCH_THICKNESS_BASE/2, r2 = BRANCH_THICKNESS_TIP/2);
                    translate([0, TAB_W/2 + 4, 0]) cube([TAB_W, TAB_HOLE_DY * 4 + 12, 6]);
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
                translate([-(KNOT_RADIUS_BASE + 6) + i * TAB_HOLE_DX, -TAB_HOLE_DY * 2 - 6 + j * TAB_HOLE_DY, -2]) {
                    cylinder(h = KNOT_HEIGHT + 6, d = TAP_D);
                }

        for (i = [-1:1:1])
            for (j = [-1:1:1])
                translate([MOT_X - KNOT_RADIUS_TOP/2 + i * TAB_HOLE_DX, KNOT_RADIUS_TOP + 4 + j * TAB_HOLE_DY, -2]) {
                    cylinder(h = KNOT_HEIGHT + 6, d = TAP_D);
                }
    }
}

organic_wrist_knot();