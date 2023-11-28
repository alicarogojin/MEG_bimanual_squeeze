#!/bin/tcsh
# Add markers to each of the newly created dataset files in the MARKERS_ADDED directory
#
# DIRECTORY STRUCTURE
# Main exp_folder = "bilateral_squeeze"
# Subdirectories under bilateral_squeeze = "RAWMEG", "MARKERS_ADDED", "EPOCHED", "GRAND_DS"
# Files under bilateral_squeeze = "average_headpos.py", "baseline_corr_bilateralsqueeze.cfg", all processing scripts

# Set relevant dataset information to be preprocessed
echo "Enter the participant ID: "
set subj = "$<"

echo "Enter the date-string in YYYYMMDD: "
set date = "$<" # YYYYMMDD

set exp_folder = /auto/iduna/arogojin/bilateral_squeeze_test

# Define relative paths to the required directories for the data pipeline, make these directories if they don't exist already
if ( -e ${exp_folder}/MARKERS_ADDED/${subj} ) then
   echo "Directory ${exp_folder}/MARKERS_ADDED/${subj} exists"
else
   mkdir ${exp_folder}/MARKERS_ADDED/${subj}
   echo "Directory ${exp_folder}/MARKERS_ADDED/${subj} created"
endif

set workdir = ${exp_folder}/MARKERS_ADDED/${subj}

# Add markers
foreach run (001 002 003 004 005 006)
	set dataset = ${subj}_AEF01_${date}_${run}.ds

	cd ${workdir}

		addMarker -f -n t255_head_localizing_trigger -s UPPT002 -l blue -c 1111111100000000 ${dataset}
		addMarker -f -n t253_runStart -s UPPT002 -l darkgreen -c 1011111100000000 ${dataset}
		addMarker -f -n t254_runEnd -s UPPT002 -l darkred -c 0111111100000000 ${dataset}

		addMarker -f -n t11_blockStart_leftSlow -s UPPT002 -l green -c 1101000000000000 ${dataset}
		addMarker -f -n t12_instructions_leftSlow -s UPPT002 -l blue -c 0011000000000000 ${dataset}
		addMarker -f -n t13_tap_leftSlow -s UPPT002 -l darkorange -c 1011000000000000 ${dataset}
		addMarker -f -n t14_noTap_leftSlow -s UPPT002 -l deeppink -c 0111000000000000 ${dataset}
		addMarker -f -n t15_blockEnd_leftSlow -s UPPT002 -l red -c 1111000000000000 ${dataset}

		addMarker -f -n t21_blockStart_leftMedium -s UPPT002 -l green -c 1010100000000000 ${dataset}
		addMarker -f -n t22_instructions_leftMedium -s UPPT002 -l blue -c 0110100000000000 ${dataset}
		addMarker -f -n t23_tap_leftMedium -s UPPT002 -l darkorange -c 1110100000000000 ${dataset}
		addMarker -f -n t24_noTap_leftMedium -s UPPT002 -l deeppink -c 0001100000000000 ${dataset}
		addMarker -f -n t25_blockEnd_leftMedium -s UPPT002 -l red -c 1001100000000000 ${dataset}

		addMarker -f -n t31_blockStart_leftFast -s UPPT002 -l green -c 1111100000000000 ${dataset}
		addMarker -f -n t32_instructions_leftFast -s UPPT002 -l blue -c 0000010000000000 ${dataset}
		addMarker -f -n t33_tap_leftFast -s UPPT002 -l darkorange -c 1000010000000000 ${dataset}
		addMarker -f -n t34_noTap_leftFast -s UPPT002 -l deeppink -c 0100010000000000 ${dataset}
		addMarker -f -n t35_blockEnd_leftFast -s UPPT002 -l red -c 1100010000000000 ${dataset}

		addMarker -f -n t41_blockStart_rightSlow -s UPPT002 -l green -c 1001010000000000 ${dataset}
		addMarker -f -n t42_instructions_rightSlow -s UPPT002 -l blue -c 0101010000000000 ${dataset}
		addMarker -f -n t43_tap_rightSlow -s UPPT002 -l darkorange -c 1101010000000000 ${dataset}
		addMarker -f -n t44_noTap_rightSlow -s UPPT002 -l deeppink -c 0011010000000000 ${dataset}
		addMarker -f -n t45_blockEnd_rightSlow -s UPPT002 -l red -c 1011010000000000 ${dataset}

		addMarker -f -n t51_blockStart_rightMedium -s UPPT002 -l green -c 1100110000000000 ${dataset}
		addMarker -f -n t52_instructions_rightMedium -s UPPT002 -l blue -c 0010110000000000 ${dataset}
		addMarker -f -n t53_tap_rightMedium -s UPPT002 -l darkorange -c 1010110000000000 ${dataset}
		addMarker -f -n t54_noTap_rightMedium -s UPPT002 -l deeppink -c 0110110000000000 ${dataset}
		addMarker -f -n t55_blockEnd_rightMedium -s UPPT002 -l red -c 1110110000000000 ${dataset}

		addMarker -f -n t61_blockStart_rightFast -s UPPT002 -l green -c 1011110000000000 ${dataset}
		addMarker -f -n t62_instructions_rightFast -s UPPT002 -l blue -c 0111110000000000 ${dataset}
		addMarker -f -n t63_tap_rightFast -s UPPT002 -l darkorange -c 1111110000000000 ${dataset}
		addMarker -f -n t64_noTap_rightFast -s UPPT002 -l deeppink -c 0000001000000000 ${dataset}
		addMarker -f -n t65_blockEnd_rightFast -s UPPT002 -l red -c 1000001000000000 ${dataset}

		addMarker -f -n t71_blockStart_inphaseSlow -s UPPT002 -l green -c 1110001000000000 ${dataset}
		addMarker -f -n t72_instructions_inphaseSlow -s UPPT002 -l blue -c 0001001000000000 ${dataset}
		addMarker -f -n t73_tap_inphaseSlow -s UPPT002 -l darkorange -c 1001001000000000 ${dataset}
		addMarker -f -n t74_noTap_inphaseSlow -s UPPT002 -l deeppink -c 0101001000000000 ${dataset}
		addMarker -f -n t75_blockEnd_inphaseSlow -s UPPT002 -l red -c 1101001000000000 ${dataset}

		addMarker -f -n t81_blockStart_inphaseMedium -s UPPT002 -l green -c 1000101000000000 ${dataset}
		addMarker -f -n t82_instructions_inphaseMedium -s UPPT002 -l blue -c 0100101000000000 ${dataset}
		addMarker -f -n t83_tap_inphaseMedium -s UPPT002 -l darkorange -c 1100101000000000 ${dataset}
		addMarker -f -n t84_noTap_inphaseMedium -s UPPT002 -l deeppink -c 0010101000000000 ${dataset}
		addMarker -f -n t85_blockEnd_inphaseMedium -s UPPT002 -l red -c 1010101000000000 ${dataset}

		addMarker -f -n t91_blockStart_inphaseFast -s UPPT002 -l green -c 1101101000000000 ${dataset}
		addMarker -f -n t92_instructions_inphaseFast -s UPPT002 -l blue -c 0011101000000000 ${dataset}
		addMarker -f -n t93_tap_inphaseFast -s UPPT002 -l darkorange -c 1011101000000000 ${dataset}
		addMarker -f -n t94_noTap_inphaseFast -s UPPT002 -c 0111101000000000 ${dataset}
		addMarker -f -n t95_blockEnd_inphaseFast -s UPPT002 -l red -c 1111101000000000 ${dataset}

		addMarker -f -n t101_blockStart_L_antiphaseSlow -s UPPT002 -l green -c 1010011000000000 ${dataset}
		addMarker -f -n t102_instructions_L_antiphaseSlow -s UPPT002 -l blue -c 0110011000000000 ${dataset}
		addMarker -f -n t103_tap_L_antiphaseSlow -s UPPT002 -l darkorange -c 1110011000000000 ${dataset}
		addMarker -f -n t104_noTap_L_antiphaseSlow -s UPPT002 -l deeppink -c 0001011000000000 ${dataset}
		addMarker -f -n t105_blockEnd_L_antiphaseSlow -s UPPT002 -l red -c 1001011000000000 ${dataset}

		addMarker -f -n t111_blockStart_L_antiphaseMedium -s UPPT002 -l green -c 1111011000000000 ${dataset}
		addMarker -f -n t112_instructions_L_antiphaseMedium -s UPPT002 -l blue -c 0000111000000000 ${dataset}
		addMarker -f -n t113_tap_L_antiphaseMedium -s UPPT002 -l darkorange -c 1000111000000000 ${dataset}
		addMarker -f -n t114_noTap_L_antiphaseMedium -s UPPT002 -l deeppink -c 0100111000000000 ${dataset}
		addMarker -f -n t115_blockEnd_L_antiphaseMedium -s UPPT002 -l red -c 1100111000000000 ${dataset}

		addMarker -f -n t121_blockStart_L_antiphaseFast -s UPPT002 -l green -c 1001111000000000 ${dataset}
		addMarker -f -n t122_instructions_L_antiphaseFast -s UPPT002 -l blue -c 0101111000000000 ${dataset}
		addMarker -f -n t123_tap_L_antiphaseFast -s UPPT002 -l darkorange -c 1101111000000000 ${dataset}
		addMarker -f -n t124_noTap_L_antiphaseFast -s UPPT002 -l deeppink -c 0011111000000000 ${dataset}
		addMarker -f -n t125_blockEnd_L_antiphaseFast -s UPPT002 -l red -c 1011111000000000 ${dataset}

		addMarker -f -n t131_blockStart_R_antiphaseSlow -s UPPT002 -l green -c 1100000100000000 ${dataset}
		addMarker -f -n t132_instructions_R_antiphaseSlow -s UPPT002 -l blue -c 0010000100000000 ${dataset}
		addMarker -f -n t133_tap_R_antiphaseSlow -s UPPT002 -l darkorange -c 1010000100000000 ${dataset}
		addMarker -f -n t134_noTap_R_antiphaseSlow -s UPPT002 -l deeppink -c 0110000100000000 ${dataset}
		addMarker -f -n t135_blockEnd_R_antiphaseSlow -s UPPT002 -l red -c 1110000100000000 ${dataset}

		addMarker -f -n t141_blockStart_R_antiphaseSlow -s UPPT002 -l green -c 1011000100000000 ${dataset}
		addMarker -f -n t142_instructions_R_antiphaseSlow -s UPPT002 -l blue -c 0111000100000000 ${dataset}
		addMarker -f -n t143_tap_R_antiphaseMedium -s UPPT002 -l darkorange -c 1111000100000000 ${dataset}
		addMarker -f -n t144_noTap_R_antiphaseMedium -s UPPT002 -l deeppink -c 0000100100000000 ${dataset}
		addMarker -f -n t145_blockEnd_R_antiphaseSlow -s UPPT002 -l red -c 1000100100000000 ${dataset}

		addMarker -f -n t151_blockStart_R_antiphaseSlow -s UPPT002 -l green -c 1110100100000000 ${dataset}
		addMarker -f -n t152_instructions_R_antiphaseSlow -s UPPT002 -l blue -c 0001100100000000 ${dataset}
		addMarker -f -n t153_tap_R_antiphaseFast -s UPPT002 -l darkorange -c 1001100100000000 ${dataset}
		addMarker -f -n t154_noTap_R_antiphaseFast -s UPPT002 -l deeppink -c 0101100100000000 ${dataset}
		addMarker -f -n t155_blockEnd_R_antiphaseSlow -s UPPT002 -l red -c 1101100100000000 ${dataset}

		addMarker -f -n t161_blockStart_rest -s UPPT002 -l green -c 1000010100000000 ${dataset}
		addMarker -f -n t162_instructions_rest -s UPPT002 -l blue -c 0100010100000000 ${dataset}
		addMarker -f -n t163_rest -s UPPT002 -l darkorange -c 1100010100000000 ${dataset}
		addMarker -f -n t165_blockEnd_rest -s UPPT002 -l red -c 1010010100000000 ${dataset}
end
