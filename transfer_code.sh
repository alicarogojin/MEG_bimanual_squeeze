#!/bin/tcsh
# Transfer data from MEG to lab server

# Set relevant code file name to be transferred
echo "Enter the code path and filename (e.g., active_code/addMarkers.sh)"
set filename = "$<"

set exp_folder = /rri_disks/eugenia/meltzer_lab/bilateral_squeeze
set work_dir = ${exp_folder}/code

# Copy code files from local computer to magneto server
scp /Users/connectome/Documents/Postdoc/Baycrest/MEG_bimanual/MEG/iduna_code-test/${filename} arogojin@172.24.4.37:${work_dir}
# meg server pwd: meg1lab
# enter Baycrest password
