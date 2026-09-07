// ============================================================
// gripper.scad — ROOT TENDRILS that curl around objects
// ------------------------------------------------------------
// Bidirectional lead-screw actuator with organic, tapered jaws
// that look like root tendrils reaching out and grasping.
// Gear-driven: wrist motor -> pinion -> drive gear on lead screw.
// ============================================================

include <../lib/parts_lib.scad>;

$fn = 96;

LEAD_D   = 8.0;    // MEASURE YOUR SALVAGED LEAD SCREW (diameter)
NUT_OD   = 20.0;   // MEASURE your brass Z-nut OD
NUT_W    = 10.0;   // ...and its width along the screw

// Root tendril dimensions — tapered, organic forms
TENDRIL_R_BASE = 10;     // radius at base (thicker)
TENDRIL_R_TIP  = 4;      // radius at tip (delicate)
TENDRIL_LENGTH = 80;     // length of each tendril jaw

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

        // Gear pockets — cavities where pinion + drive gear sit
        translate([0, TENDRIL_R_BASE * 2 - 5, 18]) {
            cylinder(h = GEAR_H + 2, r1 = GM * Z_PIN / 2 + 3, r2 = GM * Z_PIN / 2 + 3);
        }
        translate([GM * (Z_PIN + Z_DRV) / 2, TENDRIL_R_BASE * 2 - 5, 18]) {
            cylinder(h = GEAR_H + 2, r1 = GM * Z_DRV / 2 + 3, r2 = GM * Z_DRV / 2 + 3);
        }

        // Motor shaft bore along Y at the motor axis
        translate([0, TENDRIL_R_BASE * 2 + MOTOR_FACE/2 + 5, 20]) rotate([90, 0, 0]) {
            cylinder(h = MOTOR_FACE + 10, d = SHAFT_D + 0.5);
        }

        // Lead-screw clearance bore along Y
        translate([GM * (Z_PIN + Z_DRV) / 2, -TENDRIL_R_BASE * 2 - 5, 20]) rotate([90, 0, 0]) {
            cylinder(h = TENDRIL_R_BASE * 4 + 10, d = LEAD_D + 0.5);
        }

        // Driven-jaw channel — open-ended slot where tendril slides
        translate([GM * (Z_PIN + Z_DRV) / 2 - NUT_OD/2 - 6, JAW_OPEN - 4, 10]) {
            cube([(TENDRIL_LENGTH + 8) - (GM * (Z_PIN + Z_DRV) / 2 - NUT_OD/2 - 6),
                  (JAW_CLOSED + 5) - (JAW_OPEN - 4),
                  TENDRIL_R_BASE * 3]);
        }

        // Wrist mounting face — M3 tap-in-plastic on shared tab pattern
        tap_holes(-TENDRIL_R_BASE * 2, 0);
    }
}

// ================= DRIVEN ROOT TENDRIL (nut-driven) =============================
module driven_tendril() {
    difference() {
        union() {
            // Tendril jaw — tapered organic form that curls slightly at tip
            translate([TENDRIL_LENGTH/2, -(JAW_CLOSED + TENDRIL_R_TIP), 15]) {
                hull() {
                    cylinder(h = TENDRIL_R_BASE * 2, r1 = TENDRIL_R_BASE, r2 = TENDRIL_R_TIP);

                    // Slight curl at the tip — organic grasping motion
                    translate([0, -TENDRIL_R_TIP/2, TENDRIL_LENGTH/2]) {
                        sphere(r = TENDRIL_R_TIP * 1.5);
                    }
                }
            }

            // Nut boss around the screw line — root nodule shape
            translate([GM * (Z_PIN + Z_DRV) / 2, -(JAW_CLOSED + TENDRIL_R_TIP), 20]) {
                sphere(r = NUT_OD/2 + 3);
            }
        }

        // Nut pocket — brass Z-nut slip-fits here; one drop of epoxy locks it in
        translate([GM * (Z_PIN + Z_DRV) / 2, -(JAW_CLOSED + TENDRIL_R_TIP) - (NUT_W + 0.4)/2, 20]) {
            rotate([90, 0, 0]) cylinder(h = NUT_W + 0.4, d = NUT_OD);
        }
    }
}

// ================= LAYOUT FOR ONE PRINT ==================================
union() {
    gripper_body();                                             // origin
    translate([TENDRIL_LENGTH + 25, -TENDRIL_R_BASE]) driven_tendril();   // right of body

    // Pinion (motor shaft) and drive gear (lead-screw end), laid side by side
    translate([TENDRIL_LENGTH + 30, TENDRIL_R_BASE * 2]) {
        drive_gear(Z_PIN, SHAFT_D + 0.2, pilot = true);
    }
    translate([TENDRIL_LENGTH + 58, TENDRIL_R_BASE * 2]) {
        drive_gear(Z_DRV, LEAD_D - 0.1, flat_key = true);
    }
}

// Assembly:
// 1. Pinion onto the wrist motor's D-cut shaft; M3 set screw through its pilot.
// 2. Drive gear keyed onto the lead-screw's end (the internal flat stops it spinning).
// 3. Driven tendril onto the screw with the nut in its pocket (epoxy dab); verify it slides freely.
// 4. Wrist motor faceplate against the drive boss, four M3 screws; jog from Klipper console:
//    one direction walks the tendril out = OPEN, reverse = CLOSE against fixed jaw.