// ============================================================
// crank_b_shoulder.scad — SHOULDER ROOT BRANCH
// ------------------------------------------------------------
// A tapered, curved root branch connecting the base rotation
// node to the shoulder node. Looks like a living root growing
// between two knots.
// ============================================================

include <../lib/parts_lib.scad>;

$fn = 128;

// Branch dimensions — tapered organic form
BRANCH_R_BASE = BRANCH_THICKNESS_BASE / 2;   // Radius at joint end (thicker)
BRANCH_R_TIP  = BRANCH_THICKNESS_TIP / 2;    // Radius at tab end (thinner)
BRANCH_LENGTH = L1_UPPER_ARM - 50;           // Length of the branch

// Organic curve — makes it look like a natural root, not a straight rod
CURVE_AMOUNT = 8;  // mm of curve along the length

module organic_branch() {
    difference() {
        union() {
            // Main tapered branch with organic curve
            translate([0, 0, 0]) {
                // Create curved path using multiple segments
                for (i = [0:10]) {
                    let(t = i / 10);
                    let(x = BRANCH_LENGTH * t);
                    let(y = CURVE_AMOUNT * sin(PI * t));  // Sine curve for natural bend
                    translate([x, y, 0]) {
                        cylinder(h = BRANCH_LENGTH/10 + 2, r1 = BRANCH_R_BASE * (1 - t*0.4), r2 = BRANCH_R_TIP * (1 - t*0.4));
                    }
                }
            }

            // Tab face at the tip — where it bolts to next joint node
            translate([BRANCH_LENGTH, CURVE_AMOUNT, 0]) {
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
        for (i = [-1:1:1])
            for (j = [-1:1:1])
                translate([BRANCH_LENGTH + i * TAB_HOLE_DX, CURVE_AMOUNT + j * TAB_HOLE_DY, -1]) {
                    cylinder(h = 8 + 2, d = HOLE_D + 0.8);   // Clearance holes
                }
    }
}

organic_branch();