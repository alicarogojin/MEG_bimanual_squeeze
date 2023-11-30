#!/bin/tcsh

# Set relevant dataset information to be preprocessed
echo "Enter the participant ID: "
set subj = "$<"

set exp_folder = '/auto/iduna/arogojin/bilateral_squeeze_test'
set workdir = ${exp_folder}/PROC/${subj}

cd ${workdir}

ds2txt \
-c HLC0011 \
-c HLC0012 \
-c HLC0013 \
-c HLC0021 \
-c HLC0022 \
-c HLC0023 \
-c HLC0031 \
-c HLC0032 \
-c HLC0033 \
-c Na \
-c Le \
-c Re \
-x \
bimanualsqueeze_grandDS.ds  

sed '1d' bimanualsqueeze_grandDS.dat > temp.txt
mv temp.txt bimanualsqueeze_grandDS.dat

