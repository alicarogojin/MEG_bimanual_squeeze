#!/bin/tcsh

## create the 116 atlas ROI virtual channels on each participant
## .5s before till 2.5s after picture onset for all conditions


################################################

# modify subj, project_dir and data_dir for your own project
set subj = 19995
set project_dir=/rri_disks/eugenia/meltzer_lab/wenjing_backup/picture_naming/
set data_dir=${project_dir}/data

set workdir = ${data_dir}/proc/${subj}

set window_name = win_allCond_pic_-.5-2.5
set targetfilepath = ${workdir}/anat/
set targetfilename = targets116

set cov = ${window_name},0-100Hz


foreach run (PWI overt beginMatch)

    set ds = ${workdir}/pic_onset_${run}.ds
    set newdsname = ${workdir}/virt116_pic_onset_${run}.ds
    cp ${targetfilepath}/${targetfilename} ${ds}/SAM
    echo "running make_virt_chans, timestamp: `date`" > >! ${workdir}/samlogvirt.txt

    cp /rri_disks/eugenia/meltzer_lab/picture_naming/code/samparam/${window_name} ${ds}/SAM/

    SAMcov -v -m ${window_name} -r $ds -f "0 100" >> ${workdir}/samlogvirt.txt
    set cov_status = $status 
    if ($cov_status != 0) then 
        echo "SAMcov return status $cov_status" >> ${workdir}/samlogvirt.txt
        echo "SAMcov failed during run ${run}, exit now" >> ${workdir}/samlogvirt.txt
        exit 1
    endif

    SAMsrc -r $ds -c $cov -t $targetfilename -W 0 -Z >> ${workdir}/samlogvirt.txt

    newDs2 -marker allCond_pic -time -.5 2.5 -band 0 100 \
        -includeSAM ${cov},${targetfilename}.wts  $ds $newdsname
end


##Then import into eeglab (import data from ctf folder (MEG), choose channels 341:456*, and save as virt116_pic_onset.set, delete the virtual .ds dataset

# -excludeMEG
