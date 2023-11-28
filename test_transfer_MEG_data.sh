#!/bin/tcsh
# Transfer data from MEG to lab server

# Set relevant dataset information to be preprocessed
echo "Enter the participant ID: "
set subj = "$<"

echo "Enter the date-string in YYYYMMDD: "
set date = "$<" # YYYYMMDD

# If the subject directory in RAWMEG doesn't exist, create it
if ( -e /auto/iduna/arogojin/bilateral_squeeze_test/RAWMEG/${subj} ) then
   echo "Directory RAWMEG/${subj} exists"
else
   mkdir /auto/iduna/arogojin/bilateral_squeeze_test/RAWMEG/${subj}
   echo "Directory RAWMEG/${subj} created"
endif

# If the subject directory in MARKERS_ADDED doesn't exist, create it
if ( -e /auto/iduna/arogojin/bilateral_squeeze_test/MARKERS_ADDED/${subj} ) then
   echo "Directory MARKERS_ADDED/${subj} exists"
else
   mkdir /auto/iduna/arogojin/bilateral_squeeze_test/MARKERS_ADDED/${subj}
   echo "Directory MARKERS_ADDED/${subj} created"
endif

set exp_folder = /auto/iduna/arogojin/bilateral_squeeze_test
set rawdir = ${exp_folder}/RAWMEG/${subj}
set mdir = ${exp_folder}/MARKERS_ADDED/${subj}

# meg server pwd: meg1lab

# Copy MEG files from server to RAWMEG folder to always have an untouched copy
echo "********** Copy the RAW DATASETS from the MEG SERVER to the RAWMEG FOLDER in Eugenia"
	echo "Copying RAW files to RAWMEG DIRECTORY..."
		scp -r meg@172.24.4.22:/data/meg/${date}/${subj}_AEF01_${date}\* ${rawdir}
	echo "...Copying COMPLETE"
echo " "

# Also make a copy of the RAW MEG datasets into the MARKERS_ADDED directory
# Will work with these files in the analysis (like in the next step when adding markers)
echo "********** Copy the RAW DATASETS from the MEG SERVER to the MARKERS_ADDED FOLDER in Eugenia"
	echo "Copying RAW files to MARKERS_ADDED DIRECTORY..."
		scp -r meg@172.24.4.22:/data/meg/${date}/${subj}_AEF01_${date}\* ${mdir}
	echo "...Copying COMPLETE"
echo " "
