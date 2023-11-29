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

set subj_data_dir=${data_dir}/proc/${subj}
set anatdir = ${data_dir}/proc/${subj}/anat/

if (! -d ${anatdir}) then
    echo "working directory does not exist: ${anatdir}."
    echo " Are you sure you have the correct participant ID and 3dcopy was successful?" 
    echo "Fix it and try again. Bye!"
    exit 3
endif

#:'these commands are applied to MEG dataset'
#:To make a head model, we have to do localspheres on each MEG dataset, incorporating the head position information.
#:See the NIH webpage for details.

set mri = ${anatdir}
set dspath = ${subj_data_dir}

foreach run (PWI overt beginMatch)
    set ds = ${dspath}/pic_onset_${run}.ds
    localSpheres -d $ds -s $mri/ortho.shape -M -v > ${ds}/sphereinfo.txt
    checkSpheres $ds >> ${ds}/sphereinfo.txt
    inflateSpheres $ds >> ${ds}/sphereinfo.txt
end
