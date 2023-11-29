#!/bin/tcsh
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
