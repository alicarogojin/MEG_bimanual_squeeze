#!/bin/tcsh
# Imports the nifti data into the working directory
# Converts it to mprage format

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

mkdir ${workdir}/samresults
mkdir ${workdir}/anat

cd ${workdir}/anat
3dcopy /rri_disks/eugenia/meltzer_lab/mridata2023/proc/${subj}/5_anat-T1w_anat-T1w.nii ./${subj}_mprage.nii

# Convert to mprage format
3dcopy ${subj}_mprage.nii mprage+orig

# Now that we've created the .mprage file through 3dCopy, open AFNI for next step in analysis (marking fiducials)
# afni &
