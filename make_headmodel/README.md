
```bash
### Look out for special cases
# for 15434 special case
3dcopy /rri_disks/eugenia/meltzer_lab/mridata2023/proc/${subj}/6_T1_MPRAGE_OB-AXIAL_T1_MPRAGE_OB-AXIAL.nii ./${subj}_mprage.nii


# for 20122 special case
# Need to run this scrip twice with two different fiducial placements since we changed the fiducial location before the beginMatch run
# created anat1 and anat2 2 folders
```
## 1) Copy MRI scans to the following formats: NIfTI, ANFI.
Run this in a shell:
```bash
./3dcopy.sh
```

## 2) Mark fiducial points in AFNI
There's a video walkthrough for this part on Google Drive.

Now that we've already created the mprage file through 3dCopy,
* open `afni` (Run in a shell: `afni &`),
* open the mprage+orig anatomical file
* `EditEnv -> AFNI_LEFT_IS_LEFT` set to `no`
* open dataset in `afni`, Define `Datamode -> Plugins -> edit tagset`
* load in anatomical dataset
* paste in this as tag file, after clicking `>>read`:
    * `/home/jed/data/sw/brainhulllib/null.tag`
* open up Brainsight fiducial point screenshots using `eog` in a shell
* mark the fiducial points in AFNI accoridng to the screenshots
* save the markers in afni
* Close afni

## 3) Create brainhull
Run this in a shell:
```bash
./create_brainhull.sh
```

## 4) Warp dataset to MNI space
Run this in a shell:
```bash
./warp_anat.sh
```
## 4) Change head position coordinates
Run contents of `changeheadpos_continuous_data`.

## 5) Create spheres model
Run this in a shell:
```bash
./create_spheres.sh
```
