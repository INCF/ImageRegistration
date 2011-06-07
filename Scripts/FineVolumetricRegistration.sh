#
# Here we will use ANTS to perform the Deformable registration of slices versus
# the 3D atlas.
#
#
#   Put here the scripts that Gang developed at UPenn...
#
#
# This will produce as output an set of CompositeTransforms (one per original slice)
# each combining a Deformation field with several Affine Transforms.
#

#
# register each slice of 3D atlas to the corresponding slice of 
# reconstruction histology 3D volume from user
#

# 
# 1) cut 2D slices from the 3D altas after the affine registration
#  saved in $ATLAS_SLICE_DIR and $ATLAS_SLICE_DIR/label
#

$ANTSDIR/ConvertImageSeries $ATLAS_SLICE_DIR \
     canon_hist_affined_slice%05d.nii.gz \
     "$OUTPUT_DIR/canon_hist_affined.nii.gz" 

$ANTSDIR/ConvertImageSeries $ATLAS_SLICE_DIR/label \
     canon_hist_label_affined_slice%05d.nii.gz \
    "$OUTPUT_DIR/canon_hist_label_affined.nii.gz"

# 
# 2) register 2D reference atlas slice to 2D user histology slice
# assuming 2D user histology slices are all in 
# $HISTO_SLICE_DIR naming as histo_slice%05d, base from 0.
# Also, assuming for each 2D user histology slice, a mask is already obtained
# in $HISTO_MASK_SLICE_DIR, with naming histo_mask_slice%05d, base from 0
#
# Output: each 2D pair generates a deformation field and an affine transform, 
# stored as
# $TX_PATH/2Ddeform_M2H_%05d_Warp.nii.gz (a 2D vector field)
# and
# $TX_PATH/2Ddeform_M2H_%05d_Affine.txt (an affine parameter file)
#
# The warped 2D atlas and labels are stored as
# $WARPED_ATLAS_SLICE_DIR/2Ddeform_M2H_%05d.nii.gz
# and 
# $WARPED_ATLAS_SLICE_DIR/label/2Ddeform_M2H_label_%05d.nii.gz
#

# get number of slices by counting the MRI slices
nslices=`ls -1 $ATLAS_SLICE_DIR | grep "\.nii\.gz" | wc -l`
echo $nslices

for ((k=0;k<nslices;k++))
do
	kpad=`printf %05d $k`
    histoslice=histo_slice${kpad}
    histomaskslice=histo_mask_slice${kpad}
    mrislice=canon_hist_affined_slice${kpad}
    mrilabelslice=canon_hist_label_affined_slice${kpad}


    $ANTSDIR/ANTS 2 -m MI["$HISTO_SLICE_DIR/${histoslice}.nii.gz","$ATLAS_SLICE_DIR/${mrislice}.nii.gz",1,32] \
                -t SyN[0.25] \
                -r Gauss[3] \
                -o "$TX_PATH/2Ddeform_M2H_${kpad}_" \
                --affine-metric-type MI --MI-option 32x10000 \
                --rigid-affine false \
                -i 10x10\
                -x $HISTO_MASK_SLICE_DIR/${histomaskslice}.nii.gz \
                --continue-affine true
                



    $ANTSDIR/WarpImageMultiTransform 2 "$ATLAS_SLICE_DIR/${mrislice}.nii.gz" \
                                   "$WARPED_ATLAS_SLICE_DIR/2Ddeform_M2H_${kpad}.nii.gz" \
                                   "$TX_PATH/2Ddeform_M2H_${kpad}_Warp.nii.gz" \
                                   "$TX_PATH/2Ddeform_M2H_${kpad}_Affine.txt" \
                                -R "$HISTO_SLICE_DIR/${histoslice}.nii.gz"
                

    $ANTSDIR/WarpImageMultiTransform 2 "$ATLAS_SLICE_DIR/label/${mrilabelslice}.nii.gz" \
                                   "$WARPED_ATLAS_SLICE_DIR/label/2Ddeform_M2H_label_${kpad}.nii.gz" \
                                   "$TX_PATH/2Ddeform_M2H_${kpad}_Warp.nii.gz" \
                                   "$TX_PATH/2Ddeform_M2H_${kpad}_Affine.txt" \
                                -R "$HISTO_SLICE_DIR/${histoslice}.nii.gz" --use-NN
                                
done

#
# 3) stacking 2D slices of warped atlas and corresponding label into 3D volume
# 
# Apply Luis's tool here?
#