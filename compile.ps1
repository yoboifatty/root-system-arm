# Root System Arm - Compile all SCAD files to STLs using OpenSCAD

$openscad = "C:\Program Files\OpenSCAD\openscad.exe"
$design = "design"
$stls = "stls"

if (!(Test-Path $stls)) {
    New-Item -ItemType Directory -Path $stls | Out-Null
}

Write-Host "Compiling joint nodes..."
& $openscad -o "$stls\joint_shoulder.stl" "$design\joints\joint_shoulder.scad"
& $openscad -o "$stls\joint_base_rotate.stl" "$design\joints\joint_base_rotate.scad"
& $openscad -o "$stls\joint_elbow.stl" "$design\joints\joint_elbow.scad"
& $openscad -o "$stls\joint_wrist.stl" "$design\joints\joint_wrist.scad"

Write-Host "Compiling gear kits..."
& $openscad -o "$stls\gears_shoulder.stl" "$design\joints\gears_shoulder.scad"
& $openscad -o "$stls\gears_base_rotate.stl" "$design\joints\gears_base_rotate.scad"
& $openscad -o "$stls\gears_elbow.stl" "$design\joints\gears_elbow.scad"
& $openscad -o "$stls\gears_wrist.stl" "$design\joints\gears_wrist.scad"

Write-Host "Compiling root branches..."
& $openscad -o "$stls\crank_a_base.stl" "$design\links\crank_a_base.scad"
& $openscad -o "$stls\crank_b_shoulder.stl" "$design\links\crank_b_shoulder.scad"
& $openscad -o "$stls\crank_c_elbow.stl" "$design\links\crank_c_elbow.scad"
& $openscad -o "$stls\crank_d_wrist.stl" "$design\links\crank_d_wrist.scad"

Write-Host "Compiling base and gripper..."
& $openscad -o "$stls\base_stand.stl" "$design\base\base_stand.scad"
& $openscad -o "$stls\gripper.stl" "$design\gripper\gripper.scad"

Write-Host "Done! All STLs are in the stls/ folder."