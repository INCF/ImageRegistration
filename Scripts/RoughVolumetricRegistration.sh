#
# Here we will use ANTS to perform the Affine registration of two 3D Volumes
# stored in nifti files.
#

# ANT 3 -m MI[user.nii.gz,canon_hist.nii.gz,1,32]  -o TEST -i 0  --rigid-affine  true

#
# 1) use binary masks for both user histology 3D volume and reference (canon) 3D volume 
# to initialize affine registration
#

$ANTSDIR/ANTS 3 -m MI[user_mask.nii.gz,canon_hist_mask.nii.gz,1,32] \
                -o "$TMP_DIR/init_" \
                -i 0 \
                --affine-metric-type MI \
                --MI-option 8x32000 \
                --number-of-affine-iterations 10000x10000x10000
# 
# 2)
# affine registration: 
# fixed image:  user.nii.gz 
# moving image: canon_hist.nii.gz
# output affine parameters (in ITK affine transform parameter file)
#  "$OUTPUT_DIR/canon_to_user_Affine.txt"
# 
$ANTSDIR/ANTS 3 -m MI[user.nii.gz,canon_hist.nii.gz,1,32] \
                    -o "$OUTPUT_DIR/canon_to_user_" \
                    -a "$TMP_DIR/init_Affine.txt"  \
                    -i 0 \
                    --affine-metric-type MI \
                    --MI-option 32x16000 \
                    --number-of-affine-iterations 10000x10000x10000 

#
# This will produce as output an Affine transform file, we can validate the affine by applying 
# the affine transform to canon_hist.nii.gz.
# The same transform is also applied to the atlas label file
#
$ANTSDIR/WarpImageMultiTransform 3 canon_hist.gz \
                                   "$OUTPUT_DIR/canon_hist_affined.nii.gz" \
                                   "$OUTPUT_DIR/canon_to_user_Affine.txt" \
                                  -R user.nii.gz  

$ANTSDIR/WarpImageMultiTransform 3 canon_hist_label.gz \
                                   "$OUTPUT_DIR/canon_hist_label_affined.nii.gz" \
                                   "$OUTPUT_DIR/canon_to_user_Affine.txt" \
                                  -R user.nii.gz --use-NN \
