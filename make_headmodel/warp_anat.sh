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

#: '### now to warp dataset to mni space'
#:'When we warp to MNI space, we have to specify the resolution of the final map. Our original resolution is pretty coarse. '
#:'5 or 7mm is typical - you can ask the CTF software to compute results on a finer grid, '
#:'but given the limited resolution of beamforming, you will basically get the same numbers interpolated to a finer degree, not much more information.' 
#:'When you warp, if you warp it to a 1mm grid, you are needlessly inflating the size of the dataset by a huge factor. '
#:'So we use an MNI brain in "low resolution" - 5mm, as our reference for specifying the interpolation. '

set refdir = /home/jed/data/refbrains
set reference = ${refdir}/MNI_avg152T1.nii.gz
set loresreference = /home/jed/data/refbrains/MNI_avg152T1_5mm.nii.gz
cp ${reference} .
3dcopy brain+orig orthoanat.nii.gz

#:'We first call ANTS to compute the warp from the stripped ortho brain to MNI space. '

ANTS 3 -m PR\[${reference}, orthoanat.nii.gz,1,2\] -o orthoanat_to_mni_SYN.nii.gz \
-r Gauss\[2,0\] -t SyN\[0.5\] -i 30x99x11 -use-Histogram-Matching 

#:'As a quality control step, we warp then use this ANTS command to APPLY the warp computed above to the anatomical image, '
#:'producing a high resolution brain in MNI space. You should check that it worked well. '
#:'Open the MNI brain and the newly warped brain in two AFNI viewers linked together, '
#:'and click on various points ensuring that they match up. '

WarpImageMultiTransform 3 orthoanat.nii.gz mnisyn_orthoanat.nii.gz -R ${reference} orthoanat_to_mni_SYNWarp.nii.gz \
orthoanat_to_mni_SYNAffine.txt 
3drefit -space MNI mnisyn_orthoanat.nii.gz

#:'This next step is because at some point you may want to use the AFNI volume render plugin to make pretty pictures, '
#:'and it requires the anatomical underlay image to be stored as "short" numbers. So we are copying into short format. '

3dcalc -a mnisyn_orthoanat.nii.gz -expr a -prefix mnisyn_orthoanat_short+tlrc -datum short




#:'Inverse wrap from mni space to individual brains for the 116 atlas brain regions'
#:Now to warp the 116 atlas locations FROM MNI space TO the individual - we are applying the previously computed warp BACKWARDS. 
#:Pay close attention to the order of the arguments for WarpImageMultiTransform - you have to reverse the order of the affine part 
#:(a matrix in a text file) and the nonlinear part (a whole image). 

set samresultsdir = ${workdir}/samresults
mv mnisyn_orthoanat_short+tlrc.* $samresultsdir
cd $anatdir

WarpImageMultiTransform 3 ${refdir}/mni_coord116_3sphvals.nii.gz ${anatdir}/ortho_coord116_3sphvals.nii.gz \
-R orthoanat.nii.gz --use-NN -i orthoanat_to_mni_SYNAffine.txt \
orthoanat_to_mni_SYNInverseWarp.nii.gz 

#:'set ROIs for each atlas brain regions by taking the middle location of each regions'
#:Now we use 3dclust to extract the center of each sphere in AFNI coordinates in the individual's native "ortho" space. 

3dclust -isomerge 0 2 ortho_coord116_3sphvals.nii.gz > ortho_coord116_clustreport.txt

#:Now we use a python script to convert those coordinates into CTF format, to make a target file that can be fed to 
#:SAMsrc to produce beamformer weights. 

clustreport_to_ctf_coords2023.py ortho_coord116_clustreport.txt ${refdir}/coord116_vals.txt targets116
