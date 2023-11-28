#!/bin/tcsh
##### Epoch data into custom 1-second epochs using custom python script test_make_epoch_times_1sec.py

# Set relevant dataset information to be preprocessed
set subj = 20353
set date = 20230719 # YYYYMMDD

#### Left, right, and inphase conditions
foreach run (001 002 003 004 005 006)
    set dataset = ${subj}_AEF01_${date}_${run}.ds
    set work_dir = /auto/iduna/arogojin/bilateral_squeeze_test/MARKERS_ADDED/${subj}

    cd $work_dir

		# Define a list of event marker codes that will be used as the start of each epoch block
		set marker_list = "t14_noTap_leftSlow t24_noTap_leftMedium t34_noTap_leftFast t44_noTap_rightSlow t54_noTap_rightMedium t64_noTap_rightFast t74_noTap_inphaseSlow t84_noTap_inphaseMedium t94_noTap_inphaseFast"

		# Iterate through the event marker codes and generate event markers
		foreach code (${marker_list})

				# Extract the part of the code after "tXX_noTap_" or "tXXX_noTap_" to name outputs
				# Use scanMarkers to capture the first instance of each condition's noTap trigger
				set evt_code = `echo ${code} | sed 's/^.*_//g'`
		    scanMarkers -f -includeBad -marker ${code} -overlap 0 -time 0 0 -excludeEvent1 ${code} -2.1 -0.1 -add ${evt_code}_${run}_begin ${dataset} ${evt_code}_${run}_epoch_begintimes.evt
		end

		set options = ("leftSlow" "leftMedium" "leftFast" "rightSlow" "rightMedium" "rightFast" "inphaseSlow" "inphaseMedium" "inphaseFast")

		# Iterate through the options and call custom test_make_epoch_times_1sec Python script
		# This script will generate a custom .prn file specifying the onset times for the intended 1 second epochs
		foreach option ($options)
				set input_file = "${option}_${run}_epoch_begintimes.evt"
				set output_file = "${option}_${run}_1sec_times.prn"
				python /auto/iduna/arogojin/bilateral_squeeze_test/code/test_make_epoch_times_1sec.py "$input_file" "$output_file"

        # addMarkers based based on the .prn files
        addMarker -f -n ${option}_${run}_1sec -p "$output_file" ${dataset}
		end
end

#### Antiphase conditions
foreach run (001 002 003 004 005 006)
    set dataset = ${subj}_AEF01_${date}_${run}.ds
    set work_dir = /auto/iduna/arogojin/bilateral_squeeze_test/MARKERS_ADDED/${subj}

    cd $work_dir

    # Define marker pairs as separate variables
    set marker_pair1 = ("t104_noTap_R_antiphaseSlow t134_noTap_L_antiphaseSlow")
    set marker_pair2 = ("t114_noTap_R_antiphaseMedium t144_noTap_L_antiphaseMedium")
    set marker_pair3 = ("t124_noTap_R_antiphaseFast t154_noTap_L_antiphaseFast")

    # Iterate through the marker pairs
    foreach marker_pair ("$marker_pair1" "$marker_pair2" "$marker_pair3")
        echo "Processing marker pair: $marker_pair"  # Debugging output
        # Split the marker pair into marker1 and marker2
        set markers = ($marker_pair)
        set marker1 = $markers[1]
        set marker2 = $markers[2]

        # Extract the part of the name in marker1 after "noTap_"
        set extracted_name = `echo $marker1 | sed 's/^.*_//g'`

        # Execute the first two scanMarkers commands and save their output to temporary files
        set output1 = "R_${extracted_name}_${run}_begin"
        set output2 = "L_${extracted_name}_${run}_begin"

        scanMarkers -f -includeBad -marker $marker1 -overlap 0 -time 0 0 -excludeEvent1 $marker1 -2.1 -0.1 -add $output1 $dataset R_${extracted_name}_epoch_begintimes.evt
        scanMarkers -f -includeBad -marker $marker2 -overlap 0 -time 0 0 -excludeEvent1 $marker2 -2.1 -0.1 -add $output2 $dataset L_${extracted_name}_epoch_begintimes.evt

        # Combine the outputs of the first two scanMarkers commands into one
        scanMarkers -f -includeBad -marker ${output1} -marker ${output2} -overlap 0 -time 0 0 -add ${extracted_name}_${run}_begin $dataset ${extracted_name}_${run}_epoch_begintimes.evt

        # Clean up the temporary files if needed
        rm -f "R_${extracted_name}_epoch_begintimes.evt" "L_${extracted_name}_epoch_begintimes.evt"
    end

    set options = ("antiphaseSlow" "antiphaseMedium" "antiphaseFast")

    foreach option ($options)
        set input_file = "${option}_${run}_epoch_begintimes.evt"
        set output_file = "${option}_${run}_1sec_times.prn"
        python /auto/iduna/arogojin/bilateral_squeeze_test/code/test_make_epoch_times_1sec.py "$input_file" "$output_file"

        # addMarkers based based on the .prn files
        addMarker -f -n ${option}_${run}_1sec -p "$output_file" ${dataset}
    end
end

#### Rest conditions
foreach run (001 002 003 005 006)
  set dataset = ${subj}_AEF01_${date}_${run}.ds
  set work_dir = /auto/iduna/arogojin/bilateral_squeeze_test/MARKERS_ADDED/${subj}
  cd $work_dir

  # Iterate through the event marker codes and generate event markers
  scanMarkers -f -includeBad -marker t133_rest -overlap 0 -time 0 0 -excludeEvent1 t133_rest -10 -0.1 -add rest_${run}_begin ${dataset} rest_${run}_epoch_begintimes.evt
end

foreach run (004)
  set dataset = ${subj}_AEF01_${date}_${run}.ds
  set work_dir = /auto/iduna/arogojin/bilateral_squeeze_test/MARKERS_ADDED/${subj}
  cd $work_dir

  # Iterate through the event marker codes and generate event markers
  scanMarkers -f -includeBad -marker t133_rest -overlap 0 -time 0 0 -excludeEvent1 t133_rest -2.1 -0.1 -add rest_${run}_begin ${dataset} rest_${run}_epoch_begintimes.evt
end

## then need to go in and manually delete all times except for ~171s and ~460s for the rest_${run}_epoch_begintimes.evt files
## then proceed to run "test_run_batch_epoch_20353_rest.sh"
