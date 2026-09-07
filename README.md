# Root System Robotic Arm

A DIY 3D-printed robotic arm designed to look like an organic root system growing upward from the soil. Strong enough to lift 5 pounds, built from salvaged Ender-3 printer parts and controlled by Klipper firmware on a Raspberry Pi.

## Design Philosophy

Instead of rigid mechanical blocks bolted together, this arm uses organic, tapered forms inspired by real root systems:

- **Joint nodes** are swollen root knots where branches split
- **Crank arms** become tapered root branches that curve naturally between joints
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
├── joints/joint_block.scad  — root node joint blocks (set CONFIG: SHOULDER|BASE_ROTATE|ELBOW|WRIST)
├── joints/gears_kit.scad    — gear kits for each joint (same CONFIG as its block)
├── links/link_crank.scad    — tapered root branch connectors (CONFIG: A_BASE|B_SHOULDER|C_ELBOW|D_WRIST)
├── base/base_stand.scad     — root ball foundation with spreading roots
├── gripper/gripper.scad     — root tendril gripper with gear-driven lead screw
└── base_plate/base_plate.scad — soil bed test bench for bring-up testing

tools/
├── marlin_bridge.py         — HTTP bridge for motor testing during bring-up
└── klipper_bridge.py        — HTTP bridge for final Klipper stack

docs/
└── specs.md                 — component specifications and torque calculations
```

## Getting Started

1. **Measure your parts** with calipers (motor hole spacing, lead screw diameter, brass nut size)
2. **Print test parts first:** soil bed + one shoulder node + its gear kit
3. **Test one motor** before building anything — verify it spins correctly and doesn't overheat
4. **Build joint by joint** following ASSEMBLY.md
5. **Connect joints** with root branch connectors
6. **Install gripper** and test gripping action
7. **Route cables** neatly along the left side of the arm

## Print Settings

- **Material:** PETG or ABS
- **Infill:** 40-50% (use 60% for gears)
- **Walls:** 3 or more
- **Bed size:** All parts fit on a 256mm bed (Bambu P1S compatible)

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