#!/bin/tcsh

# Set relevant dataset information to be preprocessed
echo "Enter the participant ID: "
set subj = "$<"

echo "Enter the date-string in YYYYMMDD: "
set date = "$<" # YYYYMMDD

# If the subject directory in EPOCHED doesn't exist, create it
if ( -e /rri_disks/eugenia/meltzer_lab/bilateral_squeeze/EPOCHED/${subj} ) then
   echo "Directory EPOCHED/${subj} exists"
else
   mkdir /rri_disks/eugenia/meltzer_lab/bilateral_squeeze/EPOCHED/${subj}
   echo "Directory EPOCHED/${subj} created"
endif

set exp_folder = /rri_disks/eugenia/meltzer_lab/bilateral_squeeze
set workdir = ${exp_folder}/EPOCHED/${subj}

# Epoch raw dataset based on the new 1-second markers added with test_setup_epochs_1sec.sh
foreach run (001 002 003 004 005 006)
  set dataset = ${subj}_AEF01_${date}_${run}.ds

  set marker_list = "leftSlow leftMedium leftFast rightSlow rightMedium rightFast inphaseSlow inphaseMedium inphaseFast antiphaseSlow antiphaseMedium antiphaseFast rest"
  foreach code (${marker_list})

    set inDS = ${exp_folder}/MARKERS_ADDED/${subj}/${dataset}
    set tmpDS = ${workdir}/temp_${code}_${run}.ds
    set outDS = ${workdir}/${code}_${run}.ds

    newDs -f -all \
    -marker ${code}_${run}_1sec \
    -time -0.1 0.9 \
    -overlap 0 \
    -includeBadChannels \
    -includeBad \
    $inDS \
    $tmpDS

    # baseline correction
    set filter_config = '/rri_disks/eugenia/meltzer_lab/bilateral_squeeze/code/baseline_corr_bilateralsqueeze.cfg'
    newDs -f -all \
    -filter ${filter_config} \
    -includeBadChannels \
    -includeBad \
    $tmpDS \
    $outDS

    # Now that the data are baseline-corrected and epoched, remove the temporary dataset
    rm -r $tmpDS
  end
end

# Combine all 6 epoched datasets into single, marker-specific datasets

# If the subject directory in GRAND_DS doesn't exist, create it
if ( -e /rri_disks/eugenia/meltzer_lab/bilateral_squeeze/GRAND_DS/${subj} ) then
   echo "Directory GRAND_DS/${subj} exists"
else
   mkdir /rri_disks/eugenia/meltzer_lab/bilateral_squeeze/GRAND_DS/${subj}
   echo "Directory GRAND_DS/${subj} created"
endif

cd ${workdir}

# add all other runs when they're ready

grandDs -f \
leftSlow_001.ds \
leftMedium_001.ds \
leftFast_001.ds \
rightSlow_001.ds \
rightMedium_001.ds \
rightFast_001.ds \
inphaseSlow_001.ds \
inphaseMedium_001.ds \
inphaseFast_001.ds \
antiphaseSlow_001.ds \
antiphaseMedium_001.ds \
antiphaseFast_001.ds \
rest_001.ds \
leftSlow_002.ds \
leftMedium_002.ds \
leftFast_002.ds \
rightSlow_002.ds \
rightMedium_002.ds \
rightFast_002.ds \
inphaseSlow_002.ds \
inphaseMedium_002.ds \
inphaseFast_002.ds \
antiphaseSlow_002.ds \
antiphaseMedium_002.ds \
antiphaseFast_002.ds \
rest_002.ds \
leftSlow_003.ds \
leftMedium_003.ds \
leftFast_003.ds \
rightSlow_003.ds \
rightMedium_003.ds \
rightFast_003.ds \
inphaseSlow_003.ds \
inphaseMedium_003.ds \
inphaseFast_003.ds \
antiphaseSlow_003.ds \
antiphaseMedium_003.ds \
antiphaseFast_003.ds \
rest_003.ds \
leftSlow_004.ds \
leftMedium_004.ds \
leftFast_004.ds \
rightSlow_004.ds \
rightMedium_004.ds \
rightFast_004.ds \
inphaseSlow_004.ds \
inphaseMedium_004.ds \
inphaseFast_004.ds \
antiphaseSlow_004.ds \
antiphaseMedium_004.ds \
antiphaseFast_004.ds \
rest_004.ds \
leftSlow_005.ds \
leftMedium_005.ds \
leftFast_005.ds \
rightSlow_005.ds \
rightMedium_005.ds \
rightFast_005.ds \
inphaseSlow_005.ds \
inphaseMedium_005.ds \
inphaseFast_005.ds \
antiphaseSlow_005.ds \
antiphaseMedium_005.ds \
antiphaseFast_005.ds \
rest_005.ds \
leftSlow_006.ds \
leftMedium_006.ds \
leftFast_006.ds \
rightSlow_006.ds \
rightMedium_006.ds \
rightFast_006.ds \
inphaseSlow_006.ds \
inphaseMedium_006.ds \
inphaseFast_006.ds \
antiphaseSlow_006.ds \
antiphaseMedium_006.ds \
antiphaseFast_006.ds \
rest_006.ds \
${exp_folder}/GRAND_DS/${subj}/bimanualsqueeze_grandDS.ds

# use scanMarker() to combine each run's condition into a single condition name (e.g. rightSlow_001_1sec ... rightSlow_006_1sec into rightSlow_1sec)
set grandDs = ${exp_folder}/GRAND_DS/${subj}/bimanualsqueeze_grandDS.ds
set marker_list = "leftSlow leftMedium leftFast rightSlow rightMedium rightFast inphaseSlow inphaseMedium inphaseFast antiphaseSlow antiphaseMedium antiphaseFast rest"

foreach code (${marker_list})
  scanMarkers -f -includeBad -marker ${code}_001_1sec -marker ${code}_002_1sec -marker ${code}_003_1sec -marker ${code}_004_1sec -marker ${code}_005_1sec -marker ${code}_006_1sec -overlap 0 -time 0 0 -add ${code}_1sec ${grandDs} ${exp_folder}/GRAND_DS/${subj}/${code}_1sec.evt
end

# copy '${subj}_grandDS.ds' folder to PROC directory
scp -rv arogojin@172.24.4.37:/rri_disks/eugenia/meltzer_lab/bilateral_squeeze/GRAND_DS/${subj}/bimanualsqueeze_grandDS.ds/ arogojin@172.24.4.37:/rri_disks/eugenia/meltzer_lab/bilateral_squeeze/PROC/${subj}
