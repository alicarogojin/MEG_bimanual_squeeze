#!/bin/tcsh
##### Epoch data into custom 1-second epochs using custom python script test_make_epoch_times_1sec.py

# Set relevant dataset information to be preprocessed
set subj = 20284
set date = 20230718 # YYYYMMDD

#### Rest conditions
foreach run (001 002 003 004 005 006)
  set dataset = ${subj}_AEF01_${date}_${run}.ds
  set work_dir = /rri_disks/eugenia/meltzer_lab/bilateral_squeeze/MARKERS_ADDED/${subj}

  cd $work_dir
  # Call custom test_make_epoch_times_1sec Python script
  # This script will generate a custom .prn file specifying the onset times for the intended 1 second epochs
  set input_file = "rest_${run}_epoch_begintimes.evt"
  set output_file = "rest_${run}_1sec_times.prn"
  python /rri_disks/eugenia/meltzer_lab/bilateral_squeeze/code/make_epoch_times_1sec.py "$input_file" "$output_file"

  # addMarkers based based on the .prn files
  addMarker -f -n rest_${run}_1sec -p "$output_file" ${dataset}
end
