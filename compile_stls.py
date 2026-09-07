#!/usr/bin/env python3
"""
Root System Arm - Compile all SCAD files to STLs using OpenSCAD.

Usage: python compile_stls.py [openscad_path]

If openscad_path is not provided, it will try to find OpenSCAD in PATH or at
the default Windows installation location.
"""

import os
import sys
import subprocess
from pathlib import Path

def find_openscad():
    """Find the OpenSCAD executable."""
    # Try command line argument first
    if len(sys.argv) > 1:
        return sys.argv[1]
    
    # Try PATH
    try:
        result = subprocess.run(['which', 'openscad'], capture_output=True, text=True)
        if result.returncode == 0:
            return result.stdout.strip()
    except Exception:
        pass
    
    # Try Windows default location
    windows_path = r'C:\Program Files\OpenSCAD\openscad.exe'
    if os.path.exists(windows_path):
        return windows_path
    
    raise FileNotFoundError("Could not find OpenSCAD. Please provide the path as an argument.")

def compile_scad(openscad, scad_file, stl_file):
    """Compile a single SCAD file to STL."""
    cmd = [openscad, '-o', str(stl_file), str(scad_file)]
    print(f"  Compiling {scad_file.name} -> {stl_file.name}")
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode != 0:
            print(f"    ERROR: {result.stderr.strip()}")
            return False
        else:
            print(f"    OK")
            return True
    except Exception as e:
        print(f"    ERROR: {e}")
        return False

def main():
    # Find OpenSCAD
    openscad = find_openscad()
    print(f"Using OpenSCAD at: {openscad}")
    
    # Change to script directory
    script_dir = Path(__file__).parent
    os.chdir(script_dir)
    
    # Create stls directory if it doesn't exist
    stls_dir = script_dir / 'stls'
    stls_dir.mkdir(exist_ok=True)
    
    # List of SCAD files to compile
    scad_files = [
        ('design/joints/joint_shoulder.scad', 'stls/joint_shoulder.stl'),
        ('design/joints/joint_base_rotate.scad', 'stls/joint_base_rotate.stl'),
        ('design/joints/joint_elbow.scad', 'stls/joint_elbow.stl'),
        ('design/joints/joint_wrist.scad', 'stls/joint_wrist.stl'),
        ('design/joints/gears_shoulder.scad', 'stls/gears_shoulder.stl'),
        ('design/joints/gears_base_rotate.scad', 'stls/gears_base_rotate.stl'),
        ('design/joints/gears_elbow.scad', 'stls/gears_elbow.stl'),
        ('design/joints/gears_wrist.scad', 'stls/gears_wrist.stl'),
        ('design/links/crank_a_base.scad', 'stls/crank_a_base.stl'),
        ('design/links/crank_b_shoulder.scad', 'stls/crank_b_shoulder.stl'),
        ('design/links/crank_c_elbow.scad', 'stls/crank_c_elbow.stl'),
        ('design/links/crank_d_wrist.scad', 'stls/crank_d_wrist.stl'),
        ('design/base/base_stand.scad', 'stls/base_stand.stl'),
        ('design/gripper/gripper.scad', 'stls/gripper.stl')
    ]
    
    print(f"\nCompiling {len(scad_files)} SCAD files to STLs...")
    print("=" * 60)
    
    success_count = 0
    for scad, stl in scad_files:
        if compile_scad(openscad, script_dir / scad, script_dir / stl):
            success_count += 1
    
    print("=" * 60)
    print(f"Done! {success_count}/{len(scad_files)} files compiled successfully.")
    
    if success_count < len(scad_files):
        sys.exit(1)

if __name__ == '__main__':
    main()