// ============================================================
// crank_a_base.scad — BASE ROOT BRANCH
// ------------------------------------------------------------
// A thick, sturdy root branch connecting the base stand to the
// base rotation node. Like a main root emerging from the soil.
// ============================================================

include <../lib/parts_lib.scad>;

$fn = 128;

// Branch dimensions — thickest of all branches (most load)
BRANCH_R_BASE = 16 / 2;   // Radius at joint end (thickest)
BRANCH_R_TIP  = 10 / 2;   // Radius at tab end
BRANCH_LENGTH = 120 - 63.5;  // Length from base stand to base rotation node

// Organic curve — natural root bend
CURVE_AMOUNT = 6;  // mm of curve along the length

module organic_base_branch() {
    difference() {
        union() {
            // Main tapered branch with organic curve
            translate([0, 0, 0]) {
                for (i = [0:10]) {
                    let(t = i / 10);
                    let(x = BRANCH_LENGTH * t);
                    let(y = CURVE_AMOUNT * sin(PI * t));
                    translate([x, y, 0]) {
                        cylinder(h = BRANCH_LENGTH/10 + 2, r1 = BRANCH_R_BASE * (1 - t*0.3), r2 = BRANCH_R_TIP * (1 - t*0.3));
                    }
                }
            }

            // Tab face at the tip — where it bolts to base rotation node
            translate([BRANCH_LENGTH, CURVE_AMOUNT, 0]) {
                hull() {
                    cylinder(h = 10, r1 = BRANCH_R_TIP, r2 = TAB_W/2);
                    cube([TAB_W + 4, TAB_HOLE_DY * 4 + 20, 10]);
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
        for (i = [-1:1:1])
            for (j = [-1:1:1])
                translate([BRANCH_LENGTH + i * TAB_HOLE_DX, CURVE_AMOUNT + j * TAB_HOLE_DY, -1]) {
                    cylinder(h = 10 + 2, d = HOLE_D + 0.8);   // Clearance holes
                }
    }
}

organic_base_branch();