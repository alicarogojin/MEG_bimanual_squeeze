#!/bin/tcsh

set this_dir = `dirname $0`
source ${this_dir}/../common_cli_vars/get_participant_id.sh
if ($status != 0) then
    echo "Unable to get participant ID from your interactive input"
    echo "Please try again. Bye!"
endif

set subj=${participant_id}

# get data_dir
source ${this_dir}/../common_cli_vars/path_vars.sh
if ($?data_dir) then
    echo "Please define data_dir in picture_naming_code/common_cli_vars/path_vars.sh"
    echo "and try again. Bye!"
    exit 4
endif

set anatdir = $data_dir/proc/${subj}/anat/

if (! -d ${anatdir}) then
    echo "working directory does not exist: ${anatdir}."
    echo " Are you sure you have the correct participant ID and 3dcopy was successful?" 
    echo "Fix it and try again. Bye!"
    exit 3
endif

cd $anatdir

#'we set libdir just to say where the code lives for the brainhull package, '
#'then use 3dTagalign to "rotate" the person's original MRI into the coordinate space of CTF, defined by the three fiducial points. '
#'The resulting brain, called "ortho" is quite slanted. '

set libdir = /home/jed/data/sw/brainhulllib
3dTagalign -matvec orthomat -prefix ./ortho -master $libdir/master+orig mprage+orig

#:'This line is necessary for AFNI-internal reasons. '

3drefit -markers ortho+orig

#:' Strip the skull off. This command takes time'

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

#:'Skull stripping usually works well, but here are some options to try if it doesn't. '
#:3dSkullStrip -input ortho+orig -prefix mask -mask_vol -no_avoid_eyes -ld 30 -blur_fwhm 2 -visual -shrink_fac 0.5 -init_radius 75
#:3dSkullStrip -input ortho+orig -prefix mask -mask_vol -no_avoid_eyes -push_to_edge -ld 30 -use_edge -blur_fwhm 2 -visual -shrink_fac 0.5 -init_radius 70
#:3dSkullStrip -input ortho+orig -prefix mask -mask_vol -no_avoid_eyes -push_to_edge


#:'This is the brainhull procedure documented on the NIH webpage. '
#:'hull2fid program gives error so we are using hull2fid_2023 instead
# step(b - 2.9) -> returns 0 iff b < 3
3dcalc -a ortho+orig -b mask+orig -prefix brain -expr 'a * step(b - 2.9)'
brainhull mask+orig > hull
hull2fid_2023 ortho+orig hull ortho

hull2suma hull
suma -novolreg -spec hull.spec &
afni -niml -dset ortho+orig
