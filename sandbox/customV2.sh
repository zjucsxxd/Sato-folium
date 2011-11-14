#!/bin/bash
#Leaf Biometrics Script
#Author: Hugh Pearse

if [ "$#" == "0" ]
then
	echo "You need to pass an image as an argument"
	exit;
fi

#Basic environment tests
errors="0";
test -e ./autotrim.sh
errors=$(($? + $errors))
mogrify -version &> /dev/null 
errors=$(($? + $errors))

if [ "$errors" -gt "0" ]
then
	echo "Your environment is not set up properly.";
	echo "You may be missing some dependancies."
	echo "Check that all the necessary scripts are in the correct folder"
	exit;
fi
#----------File Conversion----------
	
	#Take a filename from the standard input
	#Shell expansion to replace the file extension with ".png"
	pic=${1/\.*/.png}
	
	#Convert file format to PNG
	convert $1 png:$pic
	
	#Segment leaf from uniform background color
	convert -transparent '#000000' -fuzz 10% $pic seg_$pic
	
	#Crop image border to leaf edges
	./autotrim.sh -c "0,0" seg_$pic seg_cr_$pic
	
	#Create segmented silhouette of leaf for measuring shape information
	convert seg_cr_$pic -channel 'RGB' -black-threshold 96% -colorspace "Gray" seg_cr_sil_$pic
	
	#Create black on white silhouette for measuring perimeter information
	convert seg_cr_sil_$pic -background "#FFFFFF" -alpha Background -alpha Off seg_cr_bwsil_$pic
	
	#Create image outline of leaf perimeter
	convert seg_cr_bwsil_$pic -edge 1 seg_cr_bwsil_edge_$pic
	
	#Split cropped color photo into 3 color chanels for histograms
	#Note: this creates 3 files with filenames ending in "-3.png"
	convert seg_cr_$pic -separate -channel RGB seg_cr_rgb_$pic
	
#----------Biometrics----------
	
	#Extract information for Red, Green and blue color channel
	#Note the shell expansion deleting the current file extension
	identify -verbose seg_cr_rgb_${pic/.png/}-0.png | egrep "Colors:|deviation" | tr -s ' ' | awk '{printf $3 "\n"}'
	identify -verbose seg_cr_rgb_${pic/.png/}-1.png | egrep "Colors:|deviation" | tr -s ' ' | awk '{printf $3 "\n"}'
	identify -verbose seg_cr_rgb_${pic/.png/}-2.png | egrep "Colors:|deviation" | tr -s ' ' | awk '{printf $3 "\n"}'
	
	#Calculate relative surface area of the leaf
	#Take the total number of black pixles and empty
	#pixles to get the total surface area of the image.
	#Divide the black pixles by the total to get the ratio of leaf to image.
	none=`identify -verbose seg_cr_sil_$pic | sed '33,35!d' | egrep "black|none" | awk '{printf $1}' | tr ':' " " | awk '{printf $1}'`
	black=`identify -verbose seg_cr_sil_$pic | sed '33,35!d' | egrep "black|none" | awk '{printf $1}' | tr ':' " " | awk '{printf $2}'`
	pixsum=`echo "$none + $black" | bc`
	ratio=`echo "scale=5; $black / $pixsum" | bc`
	echo $ratio
	
	#Calculate the leaf preimeter to surface area ratio
	#The edge should be 1px wide
	#we can count all of the white pixles to sum up the total perimeter
	#then divide the perimeter by the surface area
	black=`identify -verbose seg_cr_sil_$pic | sed '33,35!d' | egrep "black|none" | awk '{printf $1}' | tr ':' " " | awk '{printf $2}'`
	perimeter=``