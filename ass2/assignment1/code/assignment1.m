img = imread('..\asset\432.tif');
subplot(1, 3, 1);
imshow(img);
title('原图');

% 无0填充
[m, n] = size(img);
f = im2double(img);
for i = 1:m
    for j = 1:n
        f(i, j) = f(i, j)*((-1)^(i+j));
    end
end
% 作傅里叶变换
F = fft2(f);
% 计算高斯低通滤波器
u = (-m/2):(m/2-1);
v = -(n/2):(n/2-1);
[U, V] = meshgrid(u, v);
D = sqrt(U.^2 + V.^2);
D0 = 20;
H = exp(-(D.^2)./(2*(D0^2)));
% figure, imshow(H .* 256);
% 进行滤波
G = F .* H;
% 回到空间域
g = ifft2(G);
g = real(g);
for i = 1:m
    for j = 1:n
        g(i, j) = g(i, j)*((-1)^(i+j));
    end
end
subplot(1, 3, 2);
imshow(g);
title('无0填充');

% 有0填充
[m, n] = size(img);
p = 2 * m;
q = 2 * n;
f = im2double(img);
for i = 1:m
    for j = 1:n
        f(i, j) = f(i, j)*((-1)^(i+j));
    end
end
% 作傅里叶变换
F = fft2(f, p, q);
% 计算高斯低通滤波器
u = (-p/2):(p/2-1);
v = -(q/2):(q/2-1);
[U, V] = meshgrid(u, v);
D = sqrt(U.^2 + V.^2);
D0 = 20;
H = exp(-(D.^2)./(2*(D0^2)));
% figure, imshow(H .* 256);
% 进行滤波
G = F .* H;
% 回到空间域并提取子块
g = ifft2(G);
g = g(1:m, 1:n);
g = real(g);
for i = 1:m
    for j = 1:n
        g(i, j) = g(i, j)*((-1)^(i+j));
    end
end
subplot(1, 3, 3);
imshow(g);
title('有0填充');