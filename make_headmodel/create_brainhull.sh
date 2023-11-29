#!/bin/tcsh
# Need Brainhull package for
	# Warping MRI image to ORTHO Space
	# Skull stripping
	# Approximating inner skull surface

# We set libdir just to say where the code lives for the brainhull package
set libdir = /home/jed/data/sw/brainhulllib

# Warping into ortho space
# Use 3dTagalign to "rotate" the person's original MRI into the coordinate space of CTF, defined by the three fiducial points
# The resulting brain, called "ortho" is quite slanted
cd ${workdir}/anat
3dTagalign -matvec orthomat -prefix ./ortho -master $libdir/master+orig mprage+orig

# This line is necessary for AFNI-internal reasons
3drefit -markers ortho+orig

#Strip the skull off - this command takes time
3dSkullStrip -input ortho+orig -prefix mask -mask_vol -no_avoid_eyes

# with `-mask-vol`, each pixel has one of the following values:
# 0: Voxel outside surface
# 1: Voxel just outside the surface. This means the voxel
#    center is outside the surface but inside the 
#    bounding box of a triangle in the mesh. 
# 2: Voxel intersects the surface (a triangle), but center
#    lies outside.
# 3: Voxel contains a surface node.
# etc...

# Skull stripping usually works well, but here are some options to try if it doesn't
# 3dSkullStrip -input ortho+orig -prefix mask -mask_vol -no_avoid_eyes -ld 30 -blur_fwhm 2 -visual -shrink_fac 0.5 -init_radius 75
# 3dSkullStrip -input ortho+orig -prefix mask -mask_vol -no_avoid_eyes -push_to_edge -ld 30 -use_edge -blur_fwhm 2 -visual -shrink_fac 0.5 -init_radius 70
# 3dSkullStrip -input ortho+orig -prefix mask -mask_vol -no_avoid_eyes -push_to_edge

# This is the brainhull procedure documented on the NIH webpage
# Construct the brain hull
# hull2fid program gives error so we are using hull2fid_2023 instead

3dcalc -a ortho+orig -b mask+orig -prefix brain -expr 'a * step(b - 2.9)'

brainhull mask+orig > hull
hull2fid_2023 ortho+orig hull ortho
hull2suma hull

# Visualize the hull
suma -novolreg -spec hull.spec &

# Should see all three markers in the same slice
afni -niml -dset ortho+orig
