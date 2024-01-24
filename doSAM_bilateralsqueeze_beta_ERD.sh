#!/bin/tcsh

# do SAM for beta ERD contrasting between conditions

echo "Enter the participant ID: "
set subj = "$<"

set exp_folder = '/rri_disks/eugenia/meltzer_lab/bilateral_squeeze'

# code directory
set codedir = ${exp_folder}/code

# sam parameters directory
set paramdir = ${codedir}/samparam

#### beta 15-30Hz

echo "Begin processing beta"

# setup
set workdir = ${exp_folder}/PROC/${subj}
set anatdir = ${workdir}/anat
set loresreference = /home/jed/data/refbrains/MNI_avg152T1_5mm.nii.gz

set samresultsdir = ${workdir}/samresults
mkdir ${samresultsdir}

set logdir = ${workdir}/logs
mkdir ${logdir}

echo '' > ${logdir}/samlog_alphabeta_ERD.log

set ds = ${exp_folder}/GRAND_DS/${subj}/bimanualsqueeze_grandDS.ds
set tdir = ${ds}/SAM/
mkdir ${tdir}

# loop frequency bands
foreach band ('15 30')
  set bandtemp = `echo $band`
  set lo = $bandtemp[1]
  set hi = $bandtemp[2]

  # loop conditions and timeframes
  #rightSlow_rest_0_0.99 rightFast_rest_0_0.99 leftSlow_rest_0_0.99 leftFast_rest_0_0.99 rightSlow_leftSlow_0_0.99 rightFast_leftFast_0_0.99
  # antiphaseSlow_rest_0_0.99 antiphaseFast_rest_0_0.99 inphaseSlow_rest_0_0.99 inphaseFast_rest_0_0.99 antiphaseSlow_inphaseSlow_0_0.99 antiphaseFast_inphaseFast_0_0.99
  foreach cond (antiphaseMedium_inphaseSlow_0_0.99)
    ## do the SAM beamforming
    cp ${paramdir}/${cond} $tdir

    # SAM jackknife procedure
    # The jackknife programs (SAMJcov and SAMJsrc) are used to produce true statistical maps within subjects
    # Generally we use these jackknife results (JD2 files) to examine findings in a single subject
    SAMJcov -r ${ds} -f "${lo} ${hi}" -m ${cond} \
    >>& ${logdir}/samlog_alphabeta_ERD.log

    # SAMsrc produces images in a format called .svl, for SAM volume
    SAMJsrc -r ${ds} -x '-10 12' -y '-8 8' -z '0 14' -s 0.7 -c ${cond},${lo}-${hi}Hz -D2 -p -v \
    >>& ${logdir}/samlog_alphabeta_ERD.log

    # now warp results to MNI space so later we can do group stats
    cd $tdir

    # use AFNI program 3dcopy to convert the svl files to nifti format temporarily
    3dcopy ${cond},${lo}-${hi}Hz,JD2.svl tmp_${cond},${lo}-${hi}Hz,JD2.nii.gz

    # warp them to MNI space using the ANTS program WarpImageMultiTransform
    WarpImageMultiTransform 3 tmp_${cond},${lo}-${hi}Hz,JD2.nii.gz \
    warped_${cond},${lo}-${hi}Hz,JD2.nii.gz -R ${loresreference} \
    ${anatdir}/orthoanat_to_mni_SYNWarp.nii.gz ${anatdir}/orthoanat_to_mni_SYNAffine.txt

    3drefit -space MNI -view tlrc warped_${cond},${lo}-${hi}Hz,JD2.nii.gz

    mv warped_${cond},${lo}-${hi}Hz,JD2.nii.gz ${samresultsdir}
    rm tmp_${cond},${lo}-${hi}Hz,JD2.nii.gz

  end
end

cd ${samresultsdir}
afni &
