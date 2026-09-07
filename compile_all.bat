@echo off
REM Root System Arm - Compile all SCAD files to STLs
REM Run this from the root-system-arm-main directory

set OPENSCAD="C:\Program Files\OpenSCAD\openscad.exe"
set DESIGN=design
set STLS=stls

if not exist %STLS% mkdir %STLS%

echo Compiling joint nodes...
%OPENSCAD% -o %STLS%\joint_shoulder.stl %DESIGN%\joints\joint_shoulder.scad
%OPENSCAD% -o %STLS%\joint_base_rotate.stl %DESIGN%\joints\joint_base_rotate.scad
%OPENSCAD% -o %STLS%\joint_elbow.stl %DESIGN%\joints\joint_elbow.scad
%OPENSCAD% -o %STLS%\joint_wrist.stl %DESIGN%\joints\joint_wrist.scad

echo Compiling gear kits...
%OPENSCAD% -o %STLS%\gears_shoulder.stl %DESIGN%\joints\gears_shoulder.scad
%OPENSCAD% -o %STLS%\gears_base_rotate.stl %DESIGN%\joints\gears_base_rotate.scad
%OPENSCAD% -o %STLS%\gears_elbow.stl %DESIGN%\joints\gears_elbow.scad
%OPENSCAD% -o %STLS%\gears_wrist.stl %DESIGN%\joints\gears_wrist.scad

echo Compiling root branches...
%OPENSCAD% -o %STLS%\crank_a_base.stl %DESIGN%\links\crank_a_base.scad
%OPENSCAD% -o %STLS%\crank_b_shoulder.stl %DESIGN%\links\crank_b_shoulder.scad
%OPENSCAD% -o %STLS%\crank_c_elbow.stl %DESIGN%\links\crank_c_elbow.scad
%OPENSCAD% -o %STLS%\crank_d_wrist.stl %DESIGN%\links\crank_d_wrist.scad

echo Compiling base and gripper...
%OPENSCAD% -o %STLS%\base_stand.stl %DESIGN%\base\base_stand.scad
%OPENSCAD% -o %STLS%\gripper.stl %DESIGN%\gripper\gripper.scad

echo Done! All STLs are in the stls/ folder.
pause