// ============================================================
// joint_block.scad — ROOT NODE for one rotary joint
// ------------------------------------------------------------
// Looks like a swollen root knot where branches split. The motor
// mounts underneath, gears sit inside the node cavity, and two
// branch arms extend out (one up to next stage, one down to previous).
// Change CONFIG before rendering/exporting.
// ============================================================

include <../lib/parts_lib.scad>;

$fn = 96;

// ---------------- CONFIG — pick the joint you are printing --------
CONFIG = "SHOULDER";   // options: SHOULDER | BASE_ROTATE | ELBOW | WRIST
// ------------------------------------------------------------------

if (CONFIG == "ELBOW") { ZA_W = 70; ZB_W = 64; }         // 20:1 train
else if (CONFIG == "WRIST") { ZA_W = 70; ZB_W = 48; }    // 15:1 train
else { ZA_W = 84; ZB_W = 80; }                            // 30:1 train (shoulder + base rotate)

ZA_P = 14; ZB_P = 16;   // pinion tooth counts (same for all joints)

// Gear math — center distances by construction
d1    = GEAR_MODULE * (ZA_P + ZA_W) / 2;   // motor axis -> intermediate axis
d2    = GEAR_MODULE * (ZB_P + ZB_W) / 2;   // intermediate axis -> joint axis
MOT_X = d1 + d2;                          // motor center position

// Root node dimensions — swollen organic form
NODE_R_BASE = JOINT_NODE_RADIUS_BASE;      // base radius of the root knot
NODE_R_TOP  = NODE_R_BASE * JOINT_NODE_TAPER; // tapered top
NODE_H      = JOINT_NODE_HEIGHT;           // height of the knot

module tab_holes(x_pos, y_pos) {
    for (i = [-1:1:1])
        for (j = [-1:1:1])
            translate([x_pos + i * TAB_HOLE_DX, y_pos + j * TAB_HOLE_DY, -1]) {
                cylinder(h = NODE_H + 4, d = HOLE_D);
            }
}

// ================= ROOT NODE JOINT BLOCK ======================================
module joint_block() {
    difference() {
        union() {
            // Main root node — tapered organic knot shape
            translate([0, 0, 0]) {
                // Base of the knot (wider)
                cylinder(h = NODE_H * 0.3, r1 = NODE_R_BASE, r2 = NODE_R_BASE * 0.95);
                // Middle section (swollen)
                translate([0, 0, NODE_H * 0.3]) {
                    cylinder(h = NODE_H * 0.4, r1 = NODE_R_BASE * 0.95, r2 = NODE_R_TOP * 1.1);
                }
                // Top section (tapering)
                translate([0, 0, NODE_H * 0.7]) {
                    cylinder(h = NODE_H * 0.3, r1 = NODE_R_TOP * 1.1, r2 = NODE_R_TOP);
                }
            }

            // Parent-link mounting tab — looks like a root branch extending down
            translate([-(NODE_R_BASE + 5), -TAB_HOLE_DY * 2 - 8, NODE_H / 2 - 3]) {
                hull() {
                    cylinder(h = 6, r1 = BRANCH_THICKNESS_BASE/2, r2 = BRANCH_THICKNESS_TIP/2);
                    translate([-(TAB_W/2 + 5), 0, 0]) cube([TAB_W + 10, TAB_HOLE_DY * 4 + 16, 6]);
                }
            }

            // Child-link mounting tab — root branch extending up and forward
            translate([MOT_X - NODE_R_BASE/2, NODE_R_TOP + 5, NODE_H / 2 - 3]) {
                hull() {
                    cylinder(h = 6, r1 = BRANCH_THICKNESS_BASE/2, r2 = BRANCH_THICKNESS_TIP/2);
                    translate([0, TAB_W/2 + 5, 0]) cube([TAB_W, TAB_HOLE_DY * 4 + 16, 6]);
                }
            }
        }

        // Blind rod pockets — where steel rods press-fit in from above
        translate([d2, 0, -0.5]) cylinder(h = NODE_H - 4 + 0.5, d = ROD_D + BORE_CLR);   // intermediate rod
        translate([0,  0, -0.5]) cylinder(h = NODE_H - 4 + 0.5, d = ROD_D + BORE_CLR);   // output / joint axis

        // Motor shaft pass-through — motor hangs below the node
        translate([MOT_X, 0, -1]) cylinder(h = NODE_H + 2, d = SHAFT_D + 1.5);

        // Motor corner screws — M3 tap-in-plastic on measured pattern
        for (i = [-1:1:1])
            for (j = [-1:1:1])
                translate([MOT_X + i * MOTOR_HOLE_SPACING / 2, j * MOTOR_HOLE_SPACING / 2, -1]) {
                    cylinder(h = NODE_H + 4, d = TAP_D);
                }

        // Tab holes (both tabs)
        tab_holes(-(NODE_R_BASE + 5), 0);
        tab_holes(MOT_X - NODE_R_BASE/2, NODE_R_TOP + TAB_HOLE_DY * 2 + 8);
    }
}

joint_block();