#!/bin/tcsh

# We will start with an MRI that has already been tagged for markers.
# But here are some brief instructions on tagging.
# full instructions at http://kurage.nimh.nih.gov/meglab/Meg/Brainhull


### Look out for special cases
# for 15434 special case
#3dcopy /rri_disks/eugenia/meltzer_lab/mridata2023/proc/${subj}/6_T1_MPRAGE_OB-AXIAL_T1_MPRAGE_OB-AXIAL.nii ./${subj}_mprage.nii

# for 20122 special case
# Need to run this scrip twice with two different fiducial placements since we changed the fiducial location before the beginMatch run
# created anat1 and anat2 2 folders

set this_dir = `dirname $0`
source $this_dir/../common_cli_vars/get_participant_id.sh
if ($status != 0) then
    echo "Unable to get participant ID from your interactive input"
    echo "Please try again. Bye!"
endif

# get data_dir
source ${this_dir}/../common_cli_vars/path_vars.sh
if ($?data_dir) then
    echo "Please define data_dir in picture_naming_code/common_cli_vars/path_vars.sh"
    echo "and try again. Bye!"
    exit 4
endif

##'We start from here'

set subj=${participant_id}

echo "copying participant ${subj}'s MRI scan"

set workdir = ${data_dir}/proc/${subj}
if (! -d ${workdir}) then
    echo "working directory does not exist: ${workdir}. Are you sure you have the correct participant ID? 
    Fix it and try again. Bye!"
    exit 1
endif

mkdir ${workdir}/samresults
mkdir ${workdir}/anat

cd ${workdir}/anat
3dcopy /rri_disks/eugenia/meltzer_lab/mridata2023/proc/${subj}/5_anat-T1w_anat-T1w.nii ./${subj}_mprage.nii

3dcopy ${subj}_mprage.nii mprage+orig
