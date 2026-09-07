// ============================================================
// parts_lib.scad — SINGLE SOURCE OF TRUTH for all dimensions.
// Root System Arm v2 — organic, tapered forms that look like
// a living root system growing upward from the soil.
// ============================================================

// ---------- MEASURE FIRST (calipers, before ANY printing) ----------
MOTOR_HOLE_SPACING = 31;   // center-to-center of motor mounting holes
MOTOR_FACE = 42;           // motor faceplate size
SHAFT_D = 5.0;             // shaft diameter

// M3 tap-in-plastic screw holes
TAP_D  = 2.6;
HOLE_D = TAP_D;

// Steel shafts for gear axes
ROD_D    = 6.0;
BORE_CLR = 0.3;

// ---------- Gear train (all rotary joints) ----------
GEAR_MODULE = 1.25;        // tooth size — keeps parts printable on 256mm bed
GEAR_H    = 8;             // gear thickness
LEVEL_GAP = 2;             // shim thickness between mesh levels

// ---------- Arm geometry ----------
L1_UPPER_ARM = 120;   // shoulder axis -> elbow axis, mm
L2_FOREARM   = 90;    // elbow axis -> wrist axis, mm
GRIPPER_EXT  = 70;    // wrist axis -> payload center

// ---------- Shared mounting-tab hole pattern ----------
TAB_HOLE_DX = 14;     // half-spacing in X
TAB_HOLE_DY = 9;      // half-spacing in Y
TAB_W = TAB_HOLE_DX * 2 + HOLE_D + 6;   // tab width containing full pattern

// ---------- Root system aesthetic parameters ----------
ROOT_TAPER = 0.7;     // how much thinner tips are vs base (0.5-0.9)
NODE_SWELL = 1.4;     // how much joints swell compared to branches
BRANCH_CURVE = 8;     // mm of curve in branch arms

// Joint node dimensions (swollen root knots)
JOINT_NODE_RADIUS_BASE = 25;   // radius at base of joint node
JOINT_NODE_HEIGHT = 30;        // height of joint node
JOINT_NODE_TAPER = 0.8;        // taper from base to top

// Branch arm dimensions (tapered root branches)
BRANCH_THICKNESS_BASE = 12;    // thickness at joint end
BRANCH_THICKNESS_TIP = 8;      // thickness at tab end