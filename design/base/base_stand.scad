// ============================================================
// base_stand.scad — ROOT BALL FOUNDATION
// ------------------------------------------------------------
// The foundation of the arm, looking like a root ball emerging
// from soil. Wide and stable with spreading roots for balance.
// Motor mounts underneath for base rotation.
// ============================================================

include <../lib/parts_lib.scad>;

$fn = 128;

// Root ball dimensions — wide and stable
BALL_RADIUS = 60;          // Radius of the root ball
BALL_HEIGHT = 40;          // Height of the root ball

// Spreading roots for stability
ROOT_LENGTH = 50;          // Length of spreading roots
ROOT_THICKNESS = 8;        // Thickness of spreading roots

module organic_root_ball() {
    difference() {
        union() {
            // Main root ball body — wide, stable form
            translate([0, 0, 0]) {
                // Base section (widest)
                cylinder(h = BALL_HEIGHT * 0.4, r1 = BALL_RADIUS, r2 = BALL_RADIUS * 0.9);
                
                // Middle section (swollen)
                translate([0, 0, BALL_HEIGHT * 0.4]) {
                    cylinder(h = BALL_HEIGHT * 0.3, r1 = BALL_RADIUS * 0.9, r2 = BALL_RADIUS * 0.7);
                }
                
                // Top section (tapering)
                translate([0, 0, BALL_HEIGHT * 0.7]) {
                    cylinder(h = BALL_HEIGHT * 0.3, r1 = BALL_RADIUS * 0.7, r2 = BALL_RADIUS * 0.5);
                }
            }

            // Organic surface bumps — natural root texture
            translate([BALL_RADIUS * 0.6, 0, BALL_HEIGHT * 0.5]) {
                sphere(r = 12);
            }
            translate([-BALL_RADIUS * 0.4, BALL_RADIUS * 0.7, BALL_HEIGHT * 0.3]) {
                sphere(r = 10);
            }
            translate([0, -BALL_RADIUS * 0.8, BALL_HEIGHT * 0.6]) {
                sphere(r = 11);
            }

            // Spreading roots for stability — like real root ball
            for (i = [0:5]) {
                let(angle = i * 60);
                translate([BALL_RADIUS * cos(angle), BALL_RADIUS * sin(angle), BALL_HEIGHT * 0.2]) {
                    rotate([90, 0, angle]) {
                        cylinder(h = ROOT_LENGTH, r1 = ROOT_THICKNESS/2, r2 = ROOT_THICKNESS/4);
                    }
                }
            }

            // Mounting tab for base rotation node — root branch extending up
            translate([-(BALL_RADIUS + 15), -TAB_HOLE_DY * 2 - 15, BALL_HEIGHT / 2 - 8]) {
                hull() {
                    cylinder(h = 12, r1 = 16/2, r2 = 10/2);
                    translate([-(TAB_W/2 + 12), 0, 0]) cube([TAB_W + 24, TAB_HOLE_DY * 4 + 30, 12]);
                }
            }
        }

        // Motor shaft pass-through — motor hangs below the root ball
        translate([0, 0, -2]) cylinder(h = BALL_HEIGHT + 4, d = SHAFT_D + 1.5);

        // Motor corner screws — M3 tap-in-plastic on measured pattern
        for (i = [-1:1:1])
            for (j = [-1:1:1])
                translate([i * MOTOR_HOLE_SPACING / 2, j * MOTOR_HOLE_SPACING / 2, -2]) {
                    cylinder(h = BALL_HEIGHT + 6, d = TAP_D);
                }

        // Tab holes — M3 tap-in-plastic
        for (i = [-1:1:1])
            for (j = [-1:1:1])
                translate([-(BALL_RADIUS + 15) + i * TAB_HOLE_DX, -TAB_HOLE_DY * 2 - 15 + j * TAB_HOLE_DY, -2]) {
                    cylinder(h = BALL_HEIGHT + 6, d = TAP_D);
                }

        // Counterweight pocket — for balancing the arm
        translate([0, 0, BALL_HEIGHT/2]) {
            cylinder(h = BALL_HEIGHT * 0.5, r1 = 30, r2 = 25);
        }
    }
}

organic_root_ball();