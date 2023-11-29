#!/bin/tcsh

## cd to the participant's anat directory

set subj = 19952

cd /rri_disks/eugenia/meltzer_lab/wenjing_backup/picture_naming/data/proc/${subj}

foreach run (PWI overt beginMatch)
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
    pic_onset_${run}.ds  

    sed '1d' pic_onset_${run}.dat > temp.txt
    mv temp.txt pic_onset_${run}.dat
end

