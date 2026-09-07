// ============================================================
// base_stand.scad — ROOT BALL emerging from soil
// ------------------------------------------------------------
// The foundation of the arm. Looks like a tangled root ball
// growing up out of the ground, with spreading roots for stability.
// Mates with the BASE_ROTATE joint node's parent tab.
// ============================================================

include <../lib/parts_lib.scad>;

$fn = 96;

AXIS_H   = 170;    // base joint axis height above desk
X0_OFF   = 63.5;   // parent-tab pattern center sits this far below its own block's axis
PATT_Z   = AXIS_H - X0_OFF;   // cheek pattern center height

// Root ball dimensions — organic, irregular shape
BALL_R_BASE = 45;     // radius at soil level (widest)
BALL_R_TOP  = 30;     // radius where main root emerges
BALL_HEIGHT = 120;    // height of the root ball above soil
SOIL_DEPTH  = 20;     // depth below soil line for stability

// Spreading roots — 4 roots radiating outward at base
ROOT_LENGTH = 60;     // length of spreading roots
ROOT_R      = 8;      // radius of spreading roots

module pattern_clear() {
    for (i = [-1:1:1])
        for (j = [-1:1:1])
            translate([i * TAB_HOLE_DX, -(BALL_R_TOP/2) - 5, PATT_Z + j * TAB_HOLE_DY]) {
                rotate([90, 0, 0]) cylinder(h = BALL_R_TOP + 10, d = HOLE_D + 0.8);
            }
}

// ================= ROOT BALL BASE STAND ======================================
difference() {
    union() {
        // Main root ball — tapered organic form emerging from soil
        translate([0, 0, -SOIL_DEPTH]) {
            // Below soil (hidden stability mass)
            cylinder(h = SOIL_DEPTH + 5, r1 = BALL_R_BASE * 1.2, r2 = BALL_R_BASE);

            // Above soil — the visible root ball
            translate([0, 0, SOIL_DEPTH]) {
                // Lower section (wider at base)
                cylinder(h = BALL_HEIGHT * 0.4, r1 = BALL_R_BASE, r2 = BALL_R_TOP * 1.3);

                // Middle section (swollen root knot)
                translate([0, 0, BALL_HEIGHT * 0.4]) {
                    sphere(r = BALL_R_TOP * 1.2);
                }

                // Upper section (tapering to main root)
                translate([0, 0, BALL_HEIGHT * 0.6]) {
                    cylinder(h = BALL_HEIGHT * 0.4, r1 = BALL_R_TOP * 1.2, r2 = BALL_R_TOP);
                }
            }
        }

        // Spreading roots — 4 roots radiating outward at base for stability
        for (angle = [0:90:270]) {
            translate([0, 0, -SOIL_DEPTH + 5]) {
                rotate([0, 0, angle]) {
                    hull() {
                        // Root emerges from ball
                        cylinder(h = 10, r1 = ROOT_R * 1.2, r2 = ROOT_R);

                        // Root spreads outward and slightly down
                        translate([ROOT_LENGTH/2, 0, -5]) {
                            cylinder(h = 10, r1 = ROOT_R, r2 = ROOT_R * 0.6);
                        }
                    }
                }
            }
        }

        // Main root stem — where the arm connects
        translate([0, -(BALL_R_TOP/2), PATT_Z - 3]) {
            cube([BALL_R_TOP + 10, BALL_R_TOP + 10, 6]);
        }
    }

    // Mounting pattern clearance holes (clearance side — screws thread into joint node)
    pattern_clear();

    // Optional desk anchor slots at base
    for (k = [-1:1]) {
        translate([k * 40, BALL_R_BASE - 5, -SOIL_DEPTH - 1]) {
            union() {
                cube([36, 8, SOIL_DEPTH + 2]);
                translate([-18, 0, 0]) cylinder(h = SOIL_DEPTH + 2, d = 5.5);
                translate([18, 0, 0])  cylinder(h = SOIL_DEPTH + 2, d = 5.5);
            }
        }
    }
}