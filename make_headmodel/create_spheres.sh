#!/bin/tcsh
# These commands are applied to MEG dataset
# To make a head model, we have to do localspheres on each MEG dataset, incorporating the head position information.
# See the NIH webpage for details.

# Set relevant dataset information to be preprocessed
echo "Enter the participant ID: "
set subj = "$<"

# If the subject directory in PROC doesn't exist, create it
if ( -e /rri_disks/eugenia/meltzer_lab/bilateral_squeeze/PROC/${subj} ) then
   echo "Directory PROC/${subj} exists"
else
   mkdir /rri_disks/eugenia/meltzer_lab/bilateral_squeeze/PROC/${subj}
   echo "Directory PROC/${subj} created"
endif

set exp_folder = '/rri_disks/eugenia/meltzer_lab/bilateral_squeeze'
set workdir = ${exp_folder}/PROC/${subj}
set mri = ${workdir}/anat
set ds = ${exp_folder}/PROC/${subj}/bimanualsqueeze_grandDS.ds

localSpheres -d $ds -s $mri/ortho.shape -M -v > ${ds}/sphereinfo.txt
checkSpheres $ds >> ${ds}/sphereinfo.txt
inflateSpheres $ds >> ${ds}/sphereinfo.txt

# Check that there are no errors or warnings
head ${ds}/sphereinfo.txt
tail ${ds}/sphereinfo.txt

# Copy everything over to the ${exp_folder}/MRI directory to have as a backup
scp -r ${workdir}/anat /rri_disks/eugenia/meltzer_lab/bilateral_squeeze/MRI/${subj}
scp -r ${workdir}/samresults /rri_disks/eugenia/meltzer_lab/bilateral_squeeze/MRI/${subj}
