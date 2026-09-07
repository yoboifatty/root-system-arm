# Building Your Root System Arm — Simple Step-by-Step

This guide walks you through building your robotic arm from scratch. No prior experience needed — just follow each step in order.

## What You're Building

A 4-joint robotic arm that looks like an organic root system growing upward from the soil. It can lift about 5 pounds and reach about 12 inches from its base.

```
    [Root Tendrils] ← gripper that grabs things
         ↑
    [Wrist Node] ← joint that rotates the gripper
         ↑
    [Elbow Branch] ← tapered root connecting elbow to wrist
         ↑
    [Elbow Node] ← joint that bends like an elbow
         ↑
    [Shoulder Branch] ← tapered root connecting shoulder to elbow
         ↑
    [Shoulder Node] ← joint that swings the arm side-to-side
         ↑
    [Base Branch] ← tapered root connecting base to shoulder
         ↑
    [Base Node] ← joint that rotates the whole arm
         ↑
    [Root Ball] ← foundation sitting on your desk
```

## Before You Start: Measure Your Parts

Grab your calipers and measure these three things. Write down the numbers — you'll need them when printing.

1. **Motor hole spacing**: Put a motor face-up. Measure from the center of one mounting screw hole to the center of the next on the same side. (Usually 31mm)
2. **Lead screw diameter**: Measure across your salvaged lead screw. (Usually 8mm)
3. **Brass nut size**: Measure the outside diameter and width of your brass Z-nut. (Usually 20mm × 10mm)

If any of these differ from the usual sizes, tell me and I'll update the design files before you print.

## Step 1: Print Your Test Parts First

Don't print everything at once! Start with just enough to test that motors work.

**Print these first:**
- One "soil bed" (base_plate.scad) — this is your test bench
- One shoulder node (joint_block.scad, set CONFIG = "SHOULDER")
- One shoulder gear kit (gears_kit.scad, set CONFIG = "SHOULDER")

**Print settings for everything:**
- Material: PETG or ABS plastic
- Infill: 40-50% (use 60% for the gears)
- Walls: 3 or more
- No supports needed — all parts print flat

## Step 2: Test One Motor Before Building Anything

This is the most important step. Don't skip it!

1. Bolt one motor underneath your soil bed test bench (faceplate up, shaft pointing up)
2. Wire that motor to ONE driver slot on your SKR board
3. Power everything on (remember: set PSU switch to 110V first!)
4. Use the marlin_bridge.py tool from your computer to jog the motor back and forth

**What you're checking:**
- Does the motor spin? ✓
- Is it spinning the right direction? (If not, swap two wires)
- Is it getting too hot after 2 minutes? (If yes, lower the current setting)

Once one motor works perfectly, test all five motors this way before building the actual arm.

## Step 3: Build One Joint Node

Now you'll build your first joint — the shoulder node. This is where gears live inside an organic root knot shape.

**What you need:**
- Your printed shoulder node
- Your printed shoulder gear kit (4 gears + shim)
- Two pieces of 6mm steel rod: one ~32mm long, one ~85mm long
- One Biqu motor (the strongest ones)
- Four M3×10 screws for the motor

**Assembly order:**
1. Cut your two steel rods to length with clean square ends
2. Press each rod into its blind pocket in the node from above — they should fit snugly but not be forced
3. Slide wheel A onto the shorter rod until it rests on top of the node
4. Place the shim washer on top of wheel A
5. Slide pinion B onto the same short rod, resting on the shim
6. Slide the output wheel up the longer rod until it meshes with pinion B
7. Bolt your motor underneath the node using the four M3 screws — snug only, don't overtighten plastic threads
8. Put pinion A on the motor shaft and secure it with an M3 set screw

**Test before moving on:** Turn the motor shaft by hand. All four gears should turn together smoothly with light resistance. If anything binds or feels stuck, take it apart and check that all gears are seated properly.

## Step 4: Build the Rest of the Arm

Repeat Step 3 for each joint node (base rotate, elbow, wrist). Each uses the same process — just change the CONFIG setting when printing to get the right gear ratios.

**Gear ratios by joint:**
- Base rotate and shoulder: 30:1 (strongest)
- Elbow: 20:1
- Wrist: 15:1

## Step 5: Connect the Joints with Root Branches

Now connect each node to the next using your printed root branches (link_crank.scad).

**For each connection:**
1. Slide a root branch over the exposed end of one node's output rod
2. Push it up until its face is flush against the next node's mounting tab
3. Add one drop of slow-drying epoxy inside the branch bore to lock it in place
4. Bolt through the branch into the next node using four M3×16 screws

**Build order (bottom to top):**
1. Root ball base → Base rotate node
2. Base rotate output → Branch A → Shoulder node
3. Shoulder output → Branch B → Elbow node
4. Elbow output → Branch C → Wrist node
5. Wrist output → Branch D → Gripper

## Step 6: Install the Root Tendril Gripper

The gripper is special — it has its own motor and uses a lead screw to open and close the tendrils.

1. Put your brass Z-nut into the driven tendril's nut pocket (one drop of epoxy)
2. Trim your lead screw so it fits between the two stops in the gripper body (~60mm)
3. Key the drive gear onto the lead screw end and seat it in its pocket
4. Put the pinion on the gripper motor shaft with a set screw
5. Bolt the gripper motor to its boss using four M3 screws
6. Test by hand: turn the motor shaft — one direction should open the tendrils, the other closes them

## Step 7: Route Your Cables

All five motors need power and signal cables. Here's how to keep things tidy:

1. From each motor, run the cable straight out toward you for about 4 inches
2. Then turn all cables to your left side
3. Bundle all five cables together with zip ties every few inches
4. Leave a little slack (about an inch of loop) at each joint so cables don't pull when joints move

## Step 8: Final Testing

Once everything is assembled and wired:

1. Power on and test each joint individually — make sure they all move in the right direction
2. Move each joint through its full range slowly with nothing held
3. Pick up a light object (like a plastic cup) and test gripping
4. Gradually increase weight until you find the limit (should be around 5 pounds at full extension)

## Troubleshooting

**Joint won't move:** Check that gears are meshing properly — turn by hand first
**Motor overheating:** Lower run_current in your Klipper config
**Gripper won't close fully:** Check that lead screw is trimmed to correct length
**Arm sags under load:** Increase holding_current or check gear meshing

## What's Next?

Once the mechanical arm works, you'll write the software (Klipper configuration and kinematics module) to control it programmatically. That's Phase 2 — we'll tackle that after the hardware is solid.