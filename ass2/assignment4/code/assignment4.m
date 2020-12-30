showimg('..\asset\woman.png');
showimg('..\asset\lenna.tif');
showimg('..\asset\3.jpg');
showimg('..\asset\4.jpg');

function showimg(str)
    img = imread(str);
    res = improve(img);
    figure;
    subplot(1,2,1);
    imshow(img);
    title('‘≠Õº');
    subplot(1,2,2);
    imshow(res);
    title('√¿—’');
end