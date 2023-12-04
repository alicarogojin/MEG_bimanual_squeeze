#!/bin/tcsh

# Copy each line separately into Terminal/MobaXTerm, it does not run as a script on its own since you have to
# do some work in Step 2 before it can run the rest

#-----------------------Step 1--------------------------------#
# Import the nifti data into the working directory
# Convert it to mprage format

# Set relevant dataset information to be preprocessed
echo "Enter the participant ID: "
set subj = "$<"

# If the subject directory in PROC doesn't exist, create it
if ( -e /auto/iduna/arogojin/bilateral_squeeze_test/PROC/${subj} ) then
   echo "Directory PROC/${subj} exists"
else
   mkdir /auto/iduna/arogojin/bilateral_squeeze_test/PROC/${subj}
   echo "Directory PROC/${subj} created"
endif

set exp_folder = /auto/iduna/arogojin/bilateral_squeeze_test
set workdir = ${exp_folder}/PROC/${subj}

mkdir ${workdir}/samresults
mkdir ${workdir}/anat

cd ${workdir}/anat
3dcopy /rri_disks/eugenia/meltzer_lab/mridata2023/proc/${subj}/5_anat-T1w_anat-T1w.nii ./${subj}_mprage.nii

# Convert to mprage format
3dcopy ${subj}_mprage.nii mprage+orig

# Now that we've created the .mprage file through 3dCopy, open AFNI
afni &
#-------------------------------------------------------------#


#-----------------------Step 2--------------------------------#
# Define Datamode -> plugins -> edit tagset
# Dataset -> select the mprage+orig file -> apply -> set
# Paste this Tag File: /auto/baucis/jed/sw/brainhulllib/null.tag >> Read

# Open up Brainsight fiducial point screenshots using $eog command
# Click on Nasion -> Match the three slices with Brainsight
# ls

# Click set
# Repeat for left and right ear -> Save -> Done

#-------------------------------------------------------------#


#-----------------------Step 3--------------------------------#
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

#-------------------------------------------------------------#


#-----------------------Step 4--------------------------------#
#Strip the skull off - this command takes time
3dSkullStrip -input ortho+orig -prefix mask -mask_vol -no_avoid_eyes

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
#-------------------------------------------------------------#


#-----------------------Step 5--------------------------------#
# Warp the dataset from ortho space to MNI space
# When we warp to MNI space, we have to specify the resolution of the final map. Our original resolution is pretty coarse.
# 5 or 7mm is typical - you can ask the CTF software to compute results on a finer grid,
# but given the limited resolution of beamforming, you will basically get the same numbers interpolated to a finer degree, not much more information.
# When you warp, if you warp it to a 1mm grid, you are needlessly inflating the size of the dataset by a huge factor.
# So we use an MNI brain in "low resolution" - 5mm, as our reference for specifying the interpolation.

set anatdir = ${workdir}/anat
cd $anatdir

# Getting the MNI brain from Jed's reference
set refdir = /home/jed/data/refbrains
set reference = ${refdir}/MNI_avg152T1.nii.gz
set loresreference = /home/jed/data/refbrains/MNI_avg152T1_5mm.nii.gz
cp ${reference} .

# Convert the skull stripped ortho brain into a gzipped file ANTS i.e., the MNI warp calculator needs a gzipped file as input
3dcopy brain+orig orthoanat.nii.gz

# We first call ANTS to compute the warp from the stripped ortho brain to MNI space

ANTS 3 -m PR\[${reference}, orthoanat.nii.gz,1,2\] -o orthoanat_to_mni_SYN.nii.gz -r Gauss\[2,0\] -t SyN\[0.5\] -i 30x99x11 -use-Histogram-Matching

# As a quality control step, we warp then use this ANTS command to APPLY the warp computed above to the anatomical image,
# producing a high resolution brain in MNI space. You should check that it worked well.
# Open the MNI brain and the newly warped brain in two AFNI viewers linked together, and click on various points ensuring that they match up.

WarpImageMultiTransform 3 orthoanat.nii.gz mnisyn_orthoanat.nii.gz -R ${reference} orthoanat_to_mni_SYNWarp.nii.gz orthoanat_to_mni_SYNAffine.txt
3drefit -space MNI mnisyn_orthoanat.nii.gz

# This next step is because at some point you may want to use the AFNI volume render plugin to make pretty pictures,
# and it requires the anatomical underlay image to be stored as "short" numbers. So we are copying into short format.

3dcalc -a mnisyn_orthoanat.nii.gz -expr a -prefix mnisyn_orthoanat_short+tlrc -datum short
#-------------------------------------------------------------#


#-----------------------Step 6--------------------------------#
# This step does an inverse warp from MNI space (with 116 marked regions) to the individual's ortho space
# Now to warp the 116 atlas locations FROM MNI space TO the individual - we are applying the previously computed warp BACKWARDS.
# Pay close attention to the order of the arguments for WarpImageMultiTransform - you have to reverse the order of the affine part
# (a matrix in a text file) and the nonlinear part (a whole image).

set samresultsdir = ${workdir}/samresults
mv mnisyn_orthoanat_short+tlrc.* $samresultsdir

cd $anatdir
cp ${refdir}/mni_coord116_3sphvals.nii.gz .

WarpImageMultiTransform 3 ${refdir}/mni_coord116_3sphvals.nii.gz ${anatdir}/ortho_coord116_3sphvals.nii.gz -R orthoanat.nii.gz --use-NN -i orthoanat_to_mni_SYNAffine.txt orthoanat_to_mni_SYNInverseWarp.nii.gz

# Set ROIs for each atlas brain regions by taking the middle location of each region
# Now we use 3dclust to extract the center of each sphere in AFNI coordinates in the individual's native "ortho" space.

3dclust -isomerge 0 2 ortho_coord116_3sphvals.nii.gz > ortho_coord116_clustreport.txt

# Now we use a python script to convert those coordinates into CTF format, to make a target file that can be fed to
# SAMsrc to produce beamformer weights.

clustreport_to_ctf_coords2023.py ortho_coord116_clustreport.txt ${refdir}/coord116_vals.txt targets116

###### Check models to make sure they look ok
###### At this stage open the raw datasets one by one and look for artifacts
# To mark an artifact use the middle mouse button and drag cursor over, right click on area and select 'bad data segment'
# Save dataset
#-------------------------------------------------------------#


#----------------------------Step 7----------------------------#
# Open and run the "changeheadpos_continuous_data.py" script
# Run the commands in "headposcommands.txt" generated by the above python code
#python /home/jed/data/jedcode/NIBS/rhythm/average_headpos_rhythm_pre.py $workdir
#chmod 774 changeheadposcommand_pre.txt
#./changeheadposcommand_pre.txt
#-------------------------------------------------------------#


#-----------------------------Step 8----------------------------#
# These commands are applied to MEG dataset
# To make a head model, we have to do localspheres on each MEG dataset, incorporating the head position information.
# See the NIH webpage for details.
set mri = ${workdir}/anat
set ds = ${exp_folder}/GRAND_DS/${subj}/${subj}_grandDS.ds

localSpheres -d $ds -s $mri/ortho.shape -M -v > ${ds}/sphereinfo.txt
checkSpheres $ds >> ${ds}/sphereinfo.txt
inflateSpheres $ds >> ${ds}/sphereinfo.txt

# Check that there are no errors or warnings
head ${ds}/sphereinfo.txt
tail ${ds}/sphereinfo.txt

# Copy everything over to the ${exp_folder}/MRI directory to have as a backup
scp -r ${workdir}/anat /auto/iduna/arogojin/bilateral_squeeze_test/MRI/${subj}
scp -r ${workdir}/samresults /auto/iduna/arogojin/bilateral_squeeze_test/MRI/${subj}

#-------------------------------------------------------------#
