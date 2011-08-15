#
# Warp reference (canon) volume using the affine transform computed from 
# RoughVolumetricRegistration.sh or RoughVolumetricRegistrationWithMask.sh
#

# input:
#  canon_hist.nii.gz
#  $OUTPUT_DIR/canon_to_user_Affine.txt (the affine transform)
# output:
#  $OUTPUT_DIR/canon_hist_affined.nii.gz (the warped canon reference using affine)


#
# This will produce as output an Affine transform file, we can validate the affine by applying 
# the affine transform to canon_hist.nii.gz.
# The same transform is also applied to the atlas label file
#
$ANTSDIR/WarpImageMultiTransform 3 canon_hist.gz \
                                   "$OUTPUT_DIR/canon_hist_affined.nii.gz" \
                                   "$OUTPUT_DIR/canon_to_user_Affine.txt" \
                                  -R user.nii.gz  

# $ANTSDIR/WarpImageMultiTransform 3 canon_hist_label.gz \
#                                   "$OUTPUT_DIR/canon_hist_label_affined.nii.gz" \
#                                   "$OUTPUT_DIR/canon_to_user_Affine.txt" \
#                                  -R user.nii.gz --use-NN \
