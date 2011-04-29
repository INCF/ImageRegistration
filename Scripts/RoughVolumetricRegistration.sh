#
# Here we will use ANTS to perform the Affine registration of two 3D Volumes
# stored in nifti files.
#

ANT 3 -m MI[user.nii.gz,canon_hist.nii.gz,1,32]  -o TEST -i 0  --rigid-affine  true

#
# This will produce as output an Affine transform file
#
