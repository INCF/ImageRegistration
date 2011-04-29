#
# This script illustrates how to take an input 3D volume image (a Nifti file format in this case) and 
# extract from it all the slices and save them in to individual files.
#
# The ImageReadImageSeriesWrite executable is build out of the source code in the following repository
#
#      https://github.com/INCF/ImageReconstruction
#
#

./ImageReadImageSeriesWrite    canon_hist.nii.gz   /temp/Slices/canon_hist_    png


#
#
# The purpose of doing this is to generate a baseline data for testing.
# Using these generated slices as input to the real pipeline, should produce
# correct results, given that they will be a trivial case of slices that are
# already perfectly aligned.
#
#
# Example of the same command in Asif's laptop
#

cd C:\Asif\work\projects\birn\smartatlas\itk\tools\INCF GIT\ImageReconstruction Bin\Release>


ImageReadImageSeriesWrite.exe C:\Asif\work\projects\birn\smartatlas\i
\tools\images\canon_hist.nii.gz C:\Asif\work\projects\birn\smartatlas\itk\tools\images\Output\slices\canon_hist png


