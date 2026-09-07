// ============================================================
// base_plate.scad — SOIL BED for bring-up testing
// ------------------------------------------------------------
// A flat bed with 3 motor stations to power-test any joint before
// committing it to the structure. Looks like a soil bed where roots
// would grow, with organic mounting points.
// Print TWO of these sections (= all 5 motors testable).
// ============================================================

include <../lib/parts_lib.scad>;

$fn = 64;

PITCH    = 70;     // motor center-to-center along X
N_MOTORS = 3;      // per printed section
PLATE_H  = 8;
MARGIN   = 15;     // edge margin around outer motors

W = (N_MOTORS - 1) * PITCH + MOTOR_FACE + MARGIN * 2;   // ~212 mm for N=3
H = MOTOR_FACE + MARGIN * 2;                             // ~72 mm
YC = H / 2;                                              // midline — everything centers here

module motor_station(x_pos) {
    // Organic root nodule under the whole faceplate (stiffens the tap holes):
    translate([x_pos - (MOTOR_FACE + 8) / 2, YC - (MOTOR_FACE + 8) / 2, 0]) {
        hull() {
            cylinder(h = PLATE_H, r1 = MOTOR_FACE/2 + 4, r2 = MOTOR_FACE/2 + 6);
            translate([0, 0, PLATE_H/2]) sphere(r = MOTOR_FACE/2 + 5);
        }
    }

    // Shaft pass-through — motor hangs BELOW the plate, Ø5 D-cut shaft up:
    translate([x_pos, YC, -1]) cylinder(h = PLATE_H + 2, d = SHAFT_D + 1.5);

    // Corner screws — M3 tap-in-plastic on the MEASURED pattern (centered!):
    for (i = [-1:1:1])
        for (j = [-1:1:1])
            translate([x_pos + i * MOTOR_HOLE_SPACING / 2, YC + j * MOTOR_HOLE_SPACING / 2, -1]) {
                cylinder(h = PLATE_H + 4, d = TAP_D);
            }
}

difference() {
    union() {
        // Main soil bed — organic shape with rounded edges
        translate([0, 0, 0]) {
            hull() {
                cylinder(h = PLATE_H, r1 = W/2 - 5, r2 = W/2);
                translate([0, H, 0]) cylinder(h = PLATE_H, r1 = W/2 - 5, r2 = W/2);
            }
        }

        // Motor stations — organic root nodules
        for (k = [0:N_MOTORS-1]) motor_station(MARGIN + MOTOR_FACE / 2 + k * PITCH);
    }

    // Cable exit notch — looks like a root channel
    translate([W / 2 - 8, -1, -1]) {
        hull() {
            cylinder(h = PLATE_H + 2, r1 = 6, r2 = 8);
            translate([0, 14, 0]) cylinder(h = PLATE_H + 2, r1 = 6, r2 = 8);
        }
    }
}

// Usage: bolt a motor faceplate-up against the underside of the plate with
// four M3 screws (tap-in-plastic), shaft pointing UP — exactly like the real
// joints. Wire it to ONE SKR driver slot and jog from the Klipper console
// before trusting that joint with structure or payload.