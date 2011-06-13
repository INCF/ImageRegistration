#
# Here we will use ANTS to perform the Affine registration of two 3D Volumes
# stored in nifti files.
#

# ANT 3 -m MI[user.nii.gz,canon_hist.nii.gz,1,32]  -o TEST -i 0  --rigid-affine  true


# input: 
#  user.nii.gz, 
#  canon_hist.nii.gz, 
# output: 
#  $OUTPUT_DIR/canon_to_user_Affine.txt (the affine transform)


# 
# 1)
# affine registration: 
# fixed image:  user.nii.gz 
# moving image: canon_hist.nii.gz
# output affine parameters (in ITK affine transform parameter file)
#  "$OUTPUT_DIR/canon_to_user_Affine.txt"
# 
$ANTSDIR/ANTS 3 -m MI[user.nii.gz,canon_hist.nii.gz,1,32] \
                    -o "$OUTPUT_DIR/canon_to_user_" \
                    -i 0 \
                    --affine-metric-type MI \
                    --MI-option 32x16000 \
                    --number-of-affine-iterations 10000x10000x10000 

