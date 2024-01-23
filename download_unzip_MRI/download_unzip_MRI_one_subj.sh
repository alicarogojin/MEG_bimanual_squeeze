#!/bin/tcsh

set Usage="Usage: $0 -s subject_id -d date(yyyymmdd) -p project_id"

echo $Usage

set ParsedArgs=(`getopt -s tcsh -o d:p:s: -- $argv:q`)
if ($? != 0) then
    echo "Bad args. You can call this script again. Bye!"
    exit 1
endif

# set the parsed args back to argv
eval set argv=\($ParsedArgs:q\)

while (1)
    switch ($argv[1]:q)
        case '-d':
            set ScanDate=${argv[2]:q}
            echo "found d"
            shift; shift
            breaksw
        case '-s':
            set SubjectID=${argv[2]:q}
            echo "found s"
            shift; shift
            breaksw
        case '-p':
            set ProjectID=${argv[2]:q}
            echo "found p"
            shift; shift
            breaksw
        case "--":
            shift
            break
        default:
            echo "unexpected command line option"
            exit 1
    endsw
end

if (! $?ProjectID) then
    set ProjectID=185
    echo "You did not give a project ID, so we will assume 185 here"
endif

# all three params needed; if something is missing, ask user to try again
if (! ($?ScanDate && $?SubjectID && $?ProjectID)) then
    echo "Missing args. You can call this script again. Bye!"
    exit 1
endif

# don't change these ones!
set ProjectLabel = MeJe_M${ProjectID}_BA
set RrinidSubj = ${ProjectLabel}_${SubjectID}
set MriDirName = ${RrinidSubj}_MRI_${ScanDate}
set PhysDirName = ${RrinidSubj}_PhysioData_${ScanDate}

# XNAT REST API endpoint(s)
set XnatUrlProject = "https://rrinid.rotman-baycrest.on.ca/spred/data/projects"

#----------------------------------------
# STEP ONE - DOWNLOAD THE MRI SCANS
#----------------------------------------
# 

set MriStorageDir = /rri_disks/eugenia/meltzer_lab/bilateral_squeeze/
# create directory to download to 
set DownloadDir = ${MriStorageDir}/MRI/${SubjectID}/raw/
echo $DownloadDir
mkdir $DownloadDir
cd $DownloadDir


# to see list of subject IDs
echo "##################################################################"
echo "List of SubjectIDs:"
curl ${MRI_CURL_COMMON_ARGS} -X GET --url "${XnatUrlProject}/${ProjectLabel}/subjects?format=csv"  | awk -F'["_]' '$2 == "spred" {print $0}' | awk -F'["]' '{print $6}' | awk -F'[_]' '{print $NF}'

# to see sessions for a given subject
echo "##################################################################"
echo "List of sessions:"
curl ${MRI_CURL_COMMON_ARGS} -X GET --url "${XnatUrlProject}/${ProjectLabel}/subjects/${RrinidSubj}/experiments?format=csv"  | awk -F'["]' '$2 ~ /^spred/ {print $10}' | cut -d'_' -f 5- 

echo "OK to start the download now? (yes/no)"
set is_ready_to_download=$<
if ($is_ready_to_download == "no") then
    echo "Bye!"
    exit 0
endif

echo "Subject ID ${SubjectID}, Scan date ${ScanDate}, Project ID ${ProjectID}"

# to download scans for a given subject
echo "##################################################################"
echo "Downloading MRI and PHYSIO Data"
curl ${MRI_CURL_COMMON_ARGS} -o ${MriDirName}.zip -X GET --url "${XnatUrlProject}/${ProjectLabel}/subjects/${RrinidSubj}/experiments/${MriDirName}/scans/ALL/resources/DICOM/files?format=zip"
curl ${MRI_CURL_COMMON_ARGS} -o ${PhysDirName}.zip -X GET --url "${XnatUrlProject}/${ProjectLabel}/subjects/${RrinidSubj}/experiments/${PhysDirName}/scans/ALL/files?format=zip"
echo "Download Complete"

# unzip the zipped MRI files
echo "##################################################################"
echo "Unzipping MRI Data"
unzip ${MriDirName}





#----------------------------------------
# STEP TWO - CONVERT TO .NII
#----------------------------------------

set RawDirRoot = ${MriStorageDir}/MRI/${SubjectID}/raw/${MriDirName}/scans

set ProcDir = ${MriStorageDir}/MRI/${SubjectID}/

mkdir $ProcDir
cd $RawDirRoot

##### IMPORTANT STEP - CHECK SCAN NAMES #####
# check to confirm which scan number is which
ls $RawDirRoot


#### Start Conversion #####
#-i N -n Y -s N -v Y -x N
# /rri_disks/artemis/meltzer_lab/ffaisal/MRI/XNAT_data/
echo "##################################################################"
echo "Starting DICOM to Nii conversion"
# dcm2niix -i n -b n -ba n -f %s_%p_%d -o ${ProcDir} ./1-anat_scout/resources/DICOM/files
# dcm2niix -i n -b n -ba n -f %s_%p_%d -o ${ProcDir} ./2-anat_scout_MPR_sag/resources/DICOM/files
# dcm2niix -i n -b n -ba n -f %s_%p_%d -o ${ProcDir} ./3-anat_scout_MPR_cor/resources/DICOM/files
# dcm2niix -i n -b n -ba n -f %s_%p_%d -o ${ProcDir} ./4-anat_scout_MPR_tra/resources/DICOM/files
dcm2niix -i n -b n -ba n -f %s_%p_%d -o ${ProcDir} ./5-anat_T1w/resources/DICOM/files
# dcm2niix -i n -b n -ba n -f %s_%p_%d -o ${ProcDir} ./6-anat_T1w_MPR_cor/resources/DICOM/files
# dcm2niix -i n -b n -ba n -f %s_%p_%d -o ${ProcDir} ./7-anat_T1w_MPR_tra/resources/DICOM/files
echo "##################################################################"
echo "Conversion complete"

echo "##################################################################"
echo "Removing unzipped raw data"
cd $DownloadDir
rm -r ${MriDirName}
echo "##################################################################"
echo "DONE!"
