% 'sobel' 'laplacian' 'laplacian2' 'average'
filter = 'average';

img = imread('..\asset\1.jpg');
image_filtering(img, filter);

img = imread('..\asset\2.tif');
image_filtering(img, filter);