// ============================================================
// link_crank.scad — ROOT BRANCHES connecting joint nodes
// ------------------------------------------------------------
// Tapered, curved root branches that connect each joint's output
// to the next stage. Looks like a living root growing between knots.
// CONFIG: A_BASE | B_SHOULDER | C_ELBOW | D_WRIST
// ============================================================

include <../lib/parts_lib.scad>;

$fn = 96;

CONFIG = "B_SHOULDER";   // A_BASE | B_SHOULDER | C_ELBOW | D_WRIST

// Calculate radial reach based on desired axis spacing
if      (CONFIG == "A_BASE")     { RADIAL = 120 - 63.5; }                    // = 56.5 -> shoulder axis 120 out
else if (CONFIG == "B_SHOULDER") { RADIAL = L1_UPPER_ARM - 54.75; }         // = 65.3 -> elbow axis at L1=120
else if (CONFIG == "C_ELBOW")    { RADIAL = L2_FOREARM   - 54.75; }         // = 35.3 -> wrist axis at L2=90
else                             { RADIAL = 30; }                            // grip zone lands ~120 past wrist

// Root branch dimensions — tapered organic form
BRANCH_R_BASE = BRANCH_THICKNESS_BASE / 2;   // radius at joint end (thicker)
BRANCH_R_TIP  = BRANCH_THICKNESS_TIP / 2;    // radius at tab end (thinner)
BRANCH_LENGTH = RADIAL + 10;                 // total length including overlap

module tab_holes_clear(x_pos, y_pos) {
    for (i = [-1:1:1])
        for (j = [-1:1:1])
            translate([x_pos + i * TAB_HOLE_DX, y_pos + j * TAB_HOLE_DY, -1]) {
                cylinder(h = 8 + 2, d = HOLE_D + 0.8);   // clearance holes
            }
}

module root_branch() {
    difference() {
        union() {
            // Main tapered branch — thicker at joint end, thinner at tip
            translate([0, 0, 0]) {
                cylinder(h = BRANCH_LENGTH, r1 = BRANCH_R_BASE, r2 = BRANCH_R_TIP);
            }

            // Tab face at the tip — where it bolts to next joint node
            translate([BRANCH_LENGTH - 5, 0, 0]) {
                hull() {
                    cylinder(h = 8, r1 = BRANCH_R_TIP, r2 = TAB_W/2);
                    cube([TAB_W + 4, TAB_HOLE_DY * 4 + 16, 8]);
                }
            }

            // Organic swelling at the joint end — looks like root knot connection
            translate([-5, 0, 0]) {
                sphere(r = BRANCH_R_BASE * 1.3);
            }
        }

        // Press-fit bore on the driving stage's output rod
        cylinder(h = BRANCH_LENGTH + 2, d = ROD_D - 0.25, center = true);

        // Mating 4-hole pattern (clearance holes) at tab face
        tab_holes_clear(BRANCH_LENGTH - 5, 0);
    }
}

root_branch();