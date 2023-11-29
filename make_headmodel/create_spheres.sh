#!/bin/tcsh
# These commands are applied to MEG dataset
# To make a head model, we have to do localspheres on each MEG dataset, incorporating the head position information.
# See the NIH webpage for details.
set mri = ${workdir}/anat
set ds = ${exp_folder}/GRAND_DS/${subj}/${subj}_grandDS.ds

localSpheres -d $ds -s $mri/ortho.shape -M -v > ${ds}/sphereinfo.txt
checkSpheres $ds >> ${ds}/sphereinfo.txt
inflateSpheres $ds >> ${ds}/sphereinfo.txt

# Check that there are no errors or warnings
head ${ds}/sphereinfo.txt
tail ${ds}/sphereinfo.txt

# Copy everything over to the ${exp_folder}/MRI directory to have as a backup
scp -r ${workdir}/anat /auto/iduna/arogojin/bilateral_squeeze_test/MRI/${subj}
scp -r ${workdir}/samresults /auto/iduna/arogojin/bilateral_squeeze_test/MRI/${subj}
