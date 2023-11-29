
## 1) Copy MRI scans to the following formats: NIfTI, ANFI.
Run this in a shell:
```bash
./3dcopy.sh
```

## 2) Mark fiducial points in AFNI
There's a video walkthrough for this part on Google Drive.

Now that we've created the mprage file through 3dCopy,
* open `afni` (Run in a shell: `afni &`)
* `EditEnv -> AFNI_LEFT_IS_LEFT` set to `no`
* define Datamode -> plugins -> edit tagset
* dataset -> select the mprage+orig file -> apply -> set
* paste this Tag File: `/auto/baucis/jed/sw/brainhulllib/null.tag` >> Read

* open up Brainsight fiducial point screenshots using `eog` command in a shell
* mark the fiducial points in AFNI accoridng to the screenshots
   * click on nasion -> match the three slices with Brainsight
   * ls
   * click set
   * repeat for left and right ear -> Save -> Done
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
