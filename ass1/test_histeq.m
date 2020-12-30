%test histeq
I = imread('gray.jpg');
[J] = Histogram_equalization(I);
figure, imshow(I);
figure, imshow(J);
%imwrite(J, "histeq_gray.jpg");

I = imread('gray2.jpg');
[J] = Histogram_equalization(I);
figure, imshow(I);
figure, imshow(J);
%imwrite(J, "histeq_gray2.jpg");

I = imread('color.jpg');
[J] = Histogram_equalization(I);
figure, imshow(I);
figure, imshow(J);
%imwrite(J, "histeq_color.jpg");

I = imread('color2.jpg');
[J] = Histogram_equalization(I);
figure, imshow(I);
figure, imshow(J);
%imwrite(J, "histeq_color2.jpg");

I = imread('color3.jpg');
[J] = Histogram_equalization(I);
figure, imshow(I);
figure, imshow(J);
%imwrite(J, "histeq_color3.jpg");