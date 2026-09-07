// ============================================================
// gripper.scad — ROOT TENDRIL GRIPPER
// ------------------------------------------------------------
// Delicate root tendrils that curl around objects to grasp them.
// Bidirectional lead-screw actuator with organic, tapered jaws.
// Gear-driven: wrist motor -> pinion -> drive gear on lead screw.
// ============================================================

include <../lib/parts_lib.scad>;

$fn = 128;

LEAD_D   = 8.0;    // MEASURE YOUR SALVAGED LEAD SCREW (diameter)
NUT_OD   = 20.0;   // MEASURE your brass Z-nut OD
NUT_W    = 10.0;   // ...and its width along the screw

// Root tendril dimensions — tapered, organic forms
TENDRIL_R_BASE = 10;     // Radius at base (thicker)
TENDRIL_R_TIP  = 4;      // Radius at tip (delicate)
TENDRIL_LENGTH = 80;     // Length of each tendril jaw

// Drive train: small involute pair, module 0.8 — printable with 3+ walls
GM        = 0.8;                 // gear module for the gripper drive pair
Z_PIN     = 12;                  // pinion teeth (on motor shaft)
Z_DRV     = 12;                  // drive gear teeth (keyed on lead-screw end); 1:1
GEAR_H    = 5;                   // gear thickness

// Jaw travel limits
JAW_CLOSED = 3;                  // inner face from centerline when closed -> 6 mm gap
JAW_OPEN   = 18;                 // nominal full open

module tap_holes(x_pos, y_pos) {
    for (i = [-1:1:1])
        for (j = [-1:1:1])
            translate([x_pos + i * TAB_HOLE_DX, y_pos + j * TAB_HOLE_DY, -1]) {
                cylinder(h = 30 + 4, d = TAP_D);
            }
}

// ---------- small involute gear with bore (+ optional features) -----------
// Uses OpenSCAD's built-in involute() from standard library
module drive_gear(z, bore_d, pilot = false, flat_key = false) {
    difference() {
        linear_extrude(height = GEAR_H) involute(module = GM, n = z);
        cylinder(h = GEAR_H + 2, d = bore_d, center = true);
        if (pilot) {
            translate([bore_d / 2 - 1, 0, GEAR_H / 2]) rotate([0, 90, 0]) {
                cylinder(h = GM * z / 2 + 6, d = 2.5);
            }
        }
        if (flat_key) {
            translate([-(bore_d / 2) - 1, -(GEAR_H / 2), bore_d / 4]) {
                cube([bore_d + 2, GEAR_H, bore_d / 2]);
            }
        }
    }
}

// ================= ROOT TENDRIL GRIPPER BODY ==================================
module gripper_body() {
    difference() {
        union() {
            // Main body — organic root knot shape
            translate([0, 0, 0]) {
                // Base of the tendril cluster (wider)
                cylinder(h = 15, r1 = TENDRIL_R_BASE * 2.5, r2 = TENDRIL_R_BASE * 2);

                // Middle section (swollen root knot)
                translate([0, 0, 15]) {
                    sphere(r = TENDRIL_R_BASE * 1.8);
                }

                // Upper section (tapering to tendrils)
                translate([0, 0, 30]) {
                    cylinder(h = 15, r1 = TENDRIL_R_BASE * 1.8, r2 = TENDRIL_R_BASE * 1.2);
                }
            }

            // Motor drive boss — looks like a root nodule
            translate([0, TENDRIL_R_BASE * 2 + 5, 20]) {
                sphere(r = MOTOR_FACE/2 + 3);
            }

            // Fixed tendril jaw (integral extension) — tapered organic form
            translate([TENDRIL_LENGTH/2, JAW_CLOSED, 15]) {
                hull() {
                    cylinder(h = TENDRIL_R_BASE * 2, r1 = TENDRIL_R_BASE, r2 = TENDRIL_R_TIP);
                    translate([0, 0, TENDRIL_LENGTH/2 - TENDRIL_R_BASE]) {
                        sphere(r = TENDRIL_R_TIP);
                    }
                }
            }

            // Gate ring at the back — organic stop for jaw travel
            translate([-TENDRIL_R_BASE * 1.5, 0, 20]) {
                cylinder(h = TENDRIL_R_BASE * 3, r1 = LEAD_D + 2, r2 = NUT_OD/2 + 5);
            }
        }

        // Lead screw channel — where the screw slides through
        translate([TENDRIL_LENGTH/2 - 5, JAW_OPEN, 20]) {
            cylinder(h = TENDRIL_R_BASE * 3, d = LEAD_D + 1);
        }

        // Driven tendril jaw — moves along the lead screw channel
        translate([TENDRIL_LENGTH/2 - 5, JAW_OPEN, 20]) {
            hull() {
                cylinder(h = TENDRIL_R_BASE * 2, r1 = TENDRIL_R_BASE, r2 = TENDRIL_R_TIP);
                translate([0, 0, TENDRIL_LENGTH/2 - TENDRIL_R_BASE]) {
                    sphere(r = TENDRIL_R_TIP);
                }
            }
        }

        // Motor mounting holes — M3 tap-in-plastic on measured pattern
        for (i = [-1:1:1])
            for (j = [-1:1:1])
                translate([0 + i * MOTOR_HOLE_SPACING / 2, TENDRIL_R_BASE * 2 + 5 + j * MOTOR_HOLE_SPACING / 2, -1]) {
                    cylinder(h = 30 + 4, d = TAP_D);
                }

        // Mounting tab holes — bolt to wrist node output rod
        tap_holes(0, -(TENDRIL_R_BASE * 2.5));
    }
}

// ================= DRIVE TRAIN ==============================================\nmodule drive_train() {\n    // Pinion on motor shaft (D-cut bore + set-screw pilot)\n    translate([0, TENDRIL_R_BASE * 2 + 5, 20]) {\n        rotate([90, 0, 0]) {\n            drive_gear(Z_PIN, SHAFT_D + 0.2, pilot = true);\n        }\n    }\n\n    // Drive gear on lead screw end (flat keyway)\n    translate([TENDRIL_LENGTH/2 - 5, JAW_OPEN, 20]) {\n        rotate([90, 0, 0]) {\n            drive_gear(Z_DRV, LEAD_D + 0.1, flat_key = true);\n        }\n    }\n}\n\n// ================= ASSEMBLY ==================================================\ngripper_body();\ndrive_train();