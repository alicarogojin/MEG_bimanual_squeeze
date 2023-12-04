#!/bin/tcsh

## create the 116 atlas ROI virtual channels on each participant
## 0s until 0.99s after hand squeeze for all conditions


################################################

# Set relevant dataset information to be preprocessed
echo "Enter the participant ID: "
set subj = "$<"

set exp_folder = /auto/iduna/arogojin/bilateral_squeeze_test
set workdir = ${exp_folder}/PROC/${subj}

set window_name = win_allCond_0_0.99
set targetfilepath = ${workdir}/anat/
set targetfilename = targets116

set cov = ${window_name},0-100Hz

set ds = ${workdir}/bimanualsqueeze_grandDS.ds
set newdsname = ${workdir}/virt116_bimanualsqueeze_grandDS.ds
cp ${targetfilepath}/${targetfilename} ${ds}/SAM
echo "running make_virt_chans, timestamp: `date`" > >! ${workdir}/samlogvirt.txt

cp ${exp_folder}/code/samparam/${window_name} ${ds}/SAM/

SAMcov -v -m ${window_name} -r $ds -f "0 100" >> ${workdir}/samlogvirt.txt
set cov_status = $status 
if ($cov_status != 0) then 
    echo "SAMcov return status $cov_status" >> ${workdir}/samlogvirt.txt
    echo "SAMcov failed during run ${run}, exit now" >> ${workdir}/samlogvirt.txt
    exit 1
endif

SAMsrc -r $ds -c $cov -t $targetfilename -W 0 -Z >> ${workdir}/samlogvirt.txt

newDs2 -marker allCond_bimanual_squeeze -time 0 0.99 -band 0 100 -includeSAM ${cov},${targetfilename}.wts $ds $newdsname


##Then import into eeglab (import data from ctf folder (MEG), choose channels 341:456*, and save as virt116_bimanual_squeeze.set, delete the virtual .ds dataset

# -excludeMEG
