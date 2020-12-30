% Load the test image
% path can be
% '..\asset\image\ayu.jpg'
% '..\asset\image\giraffe.jpg'
% '..\asset\image\leaf.jpg'
% '..\asset\image\noise.jpg'
% '..\asset\image\rubberband_cap.png'
path = '..\asset\image\rubberband_cap.png';
imgTest = im2double(imread(path));
imgTestGray = rgb2gray(imgTest);
figure; clf;
imshow(imgTestGray);

% edge detection
%img_edge = edge(imgTestGray);
img_edge = my_edge(imgTestGray);
figure;clf;
imshow(img_edge);
% title('robertsËã×Ó');
% title('prewittËã×Ó');
% title('sobelËã×Ó');
% title('Marr-Hildreth±ßÔµ¼ì²âÆ÷');
% title('Canny±ßÔµ¼ì²âÆ÷');

% edge linking
%imtool(img_edge);
%Bxpc = bwtraceboundary(img_edge, [164, 419], 'N');
background = im2bw(img_edge, 1);
figure;clf;
imshow(background);
point = [151,445; 118,311; 146,128; 141,125; 90, 292;
         94 ,292; 316,227; 229, 80; 161,433; 177,427;
         174,431; 159,392; 138,426; 134,431];
[m, n] = size(point);
for i = 1:m
    Bxpc = my_edgelinking(img_edge, point(i, 1), point(i, 2));
    hold on
    plot(Bxpc(:,2), Bxpc(:,1), 'w', 'LineWidth', 1);
end