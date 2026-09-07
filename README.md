# Root System Robotic Arm v3

A DIY 3D-printed robotic arm designed to look like an organic root system growing upward from the soil. Strong enough to lift 5 pounds, built from salvaged Ender-3 printer parts and controlled by Klipper firmware on a Raspberry Pi.

## Design Philosophy — Living Root System

Instead of rigid mechanical blocks bolted together, this arm uses organic, tapered forms inspired by real root systems:

- **Joint nodes** are swollen root knots where branches split — each one unique in size and shape
- **Crank arms** become curved, tapered root branches that grow naturally between joints
- **Base stand** is a root ball emerging from the soil with spreading roots for stability
- **Gripper** consists of delicate root tendrils that curl around objects to grasp them

The result looks like a living organism rather than a machine — but it's just as strong and precise.

## Specifications

- **Payload:** ~5 lb (2.3 kg) sustained at full extension
- **Reach:** ~12 inches from shoulder axis
- **Joints:** 4 rotary joints + gear-driven gripper
- **Motors:** 5 NEMA-17 steppers (salvaged from Ender-3 printer)
- **Controller:** BIGTREETECH SKR Mini E3 V3.0 with Klipper firmware
- **Brain:** Raspberry Pi 3 A+ running custom kinematics module

## What's Included

```
design/
├── lib/parts_lib.scad       — single source of truth for all dimensions
├── joints/joint_*.scad      — organic root knot joint nodes (4 variants)
├── joints/gears_*.scad      — gear kits for each joint (4 variants, 30:1/20:1/15:1 ratios)
├── links/crank_*.scad       — curved, tapered root branch connectors (4 variants)
├── base/base_stand.scad     — root ball foundation with spreading roots
└── gripper/gripper.scad     — root tendril gripper with gear-driven lead screw

tools/
├── marlin_bridge.py         — HTTP bridge for motor testing during bring-up
└── klipper_bridge.py        — HTTP bridge for final Klipper stack

docs/
└── specs.md                 — component specifications and torque calculations
```

## Getting Started

### 1. Measure Your Parts
Grab your calipers and measure these three things:
- Motor hole spacing (usually 31mm)
- Lead screw diameter (usually 8mm)
- Brass nut size (usually 20mm × 10mm)

If any differ from the usual sizes, update `design/lib/parts_lib.scad` before printing.

### 2. Compile All STLs
Run the Python compilation script:
```bash
python compile_stls.py
```
Or use the batch script on Windows:
```batch
compile_all.bat
```

This will generate all 14 STL files in the `stls/` folder.

### 3. Print Test Parts First
Don't print everything at once! Start with just enough to test that motors work:
- One root ball base (base_stand.stl)
- One shoulder node (joint_shoulder.stl)
- One shoulder gear kit (gears_shoulder.stl)

**Print settings for everything:**
- Material: PETG or ABS plastic
- Infill: 40-50% (use 60% for the gears)
- Walls: 3 or more
- No supports needed — all parts print flat

### 4. Test One Motor Before Building Anything
This is the most important step. Don't skip it!
1. Bolt one motor underneath your root ball base (faceplate up, shaft pointing up)
2. Wire that motor to ONE driver slot on your SKR board
3. Power everything on (remember: set PSU switch to 110V first!)
4. Use the marlin_bridge.py tool from your computer to jog the motor back and forth

**What you're checking:**
- Does the motor spin? ✓
- Is it spinning the right direction? (If not, swap two wires)
- Is it getting too hot after 2 minutes? (If yes, lower the current setting)

Once one motor works perfectly, test all five motors this way before building the actual arm.

### 5. Build Joint by Joint
Follow ASSEMBLY.md for detailed step-by-step instructions on assembling each joint node with its gear kit and mounting tabs.

### 6. Connect Joints with Root Branches
Connect each node to the next using your printed root branches (crank_*.stl). Slide each branch over the exposed end of one node's output rod, push it up until flush against the next node's mounting tab, add epoxy inside the bore, and bolt through with four M3×16 screws.

### 7. Install Root Tendril Gripper
The gripper is special — it has its own motor and uses a lead screw to open and close the tendrils. Follow ASSEMBLY.md for detailed instructions.

## Gear Ratios by Joint

| Joint | Ratio | Purpose |
|-------|-------|---------|
| Base rotation | 30:1 | Maximum torque for rotating entire arm |
| Shoulder | 30:1 | Maximum torque for lifting payload |
| Elbow | 20:1 | Faster movement with less torque needed |
| Wrist | 15:1 | Fastest movement for delicate manipulation |

## Hardware Required (Beyond Salvaged Parts)

- Ø6mm steel rod (~8 lengths, cut to specified sizes)
- M3 machine screws and set screws
- Slow-drying epoxy for gear bore retention
- Threadlocker for gripper lead screw hardware only
- 4-wire stepper cables with extra length for cable management

## Next Steps

After the mechanical arm is built and tested:
1. Configure Klipper firmware on the SKR board
2. Write custom kinematics module for the serial chain
3. Calibrate link lengths and test to spec
4. Add end-effector tools (suction cup, magnet, etc.)

## License

MIT — do whatever you want with it, just credit the original design if you share your version.