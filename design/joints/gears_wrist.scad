// ============================================================
// gears_kit.scad — the FOUR GEARS + one shim for a rotary joint,
// laid out side by side on the bed in a single print.
// ------------------------------------------------------------
//   [1] pinion A  -> MOTOR shaft (D-cut bore + M3 set-screw pilot)
//   [2] wheel A   -> intermediate rod, LEVEL 1, rests ON THE PLATE
//   [3] shim      -> thin washer between wheel A and pinion B
//   [4] pinion B  -> same intermediate rod, LEVEL 2, rests on the shim
//   [5] output    -> axis rod, LEVEL 2; LIGHT PRESS-FIT bore
//
// Real involute teeth from OpenSCAD's standard library.
// ============================================================

include <../lib/parts_lib.scad>;

$fn = 96;

// ---------------- CONFIG — must match the joint_block you're building ----
CONFIG = "WRIST";   // options: SHOULDER | BASE_ROTATE | ELBOW | WRIST
// ------------------------------------------------------------------------

// OpenSCAD uses ternary operators for conditional assignment
ZA_P = 14;
ZA_W = (CONFIG == "ELBOW") ? 70 : ((CONFIG == "WRIST") ? 70 : 84);
ZB_P = 16;
ZB_W = (CONFIG == "ELBOW") ? 64 : ((CONFIG == "WRIST") ? 48 : 80);

// Bore fits over the Ø6 rod:
BORE_LOOSE  = ROD_D + 0.2;    // wheel A / pinion B — easy to slide on
BORE_TIGHT  = ROD_D - 0.15;   // output wheel — light press-fit so it can't walk down

// Grid pitch sized so no two parts' teeth collide
PITCH = GEAR_MODULE * (ZA_W + ZB_W) / 2 / sqrt(2) + 14;
SHIM_X = PITCH + 64;

// ---------- gear with bore (+ optional radial set-screw pilot) -----------
// Uses OpenSCAD's built-in involute() from standard library
module gear(z, bore_d, pilot = false) {
    difference() {
        linear_extrude(height = GEAR_H) involute(module = GEAR_MODULE, n = z);
        cylinder(h = GEAR_H + 2, d = bore_d, center = true);
        if (pilot) {
            // radial M3 pilot from the bore wall out just past the rim:
            translate([bore_d / 2 - 1, 0, GEAR_H / 2]) rotate([0, 90, 0]) {
                cylinder(h = GEAR_MODULE * z / 2 + 6, d = 2.5);
            }
        }
    }
}

// ================= GEAR KIT ==============================================
union() {
    // [1] PINION A — motor shaft (D-cut), set-screw pilot:
    translate([0, 0])                  gear(ZA_P, SHAFT_D + 0.2, pilot = true);

    // [2] WHEEL A — intermediate rod, level 1 (rests on plate top face):
    translate([PITCH, 0])              gear(ZA_W, BORE_LOOSE);

    // [3] PINION B — same intermediate rod, level 2 (rests on the shim):
    translate([0, PITCH])              gear(ZB_P, BORE_LOOSE);

    // [4] OUTPUT WHEEL — axis rod, level 2 (press-fit bore):
    translate([PITCH, PITCH])          gear(ZB_W, BORE_TIGHT);

    // [5] SHIM — spacer washer between wheel A and pinion B:
    translate([SHIM_X, 0]) difference() {
        cylinder(h = LEVEL_GAP + 0.01, d = 10);
        cylinder(h = LEVEL_GAP + 0.02, d = ROD_D + 0.4);
    }
}

// Assembly order (per joint) — cut both rods ~30 mm long:
//   1. Press each rod bottom into its blind pocket in the node (threadlocker dab).
//   2. Intermediate rod: wheel A down to rest on the node, then shim, then pinion B resting on the shim.
//   3. Axis rod: slide the output wheel up until it meshes with pinion B.
//   4. Motor under the node (4 corner screws), pinion A on its shaft, set screw.
// Meshing check before bolting anything down: turn the motor shaft by hand —
// all four gears should step together with light drag and no binding.