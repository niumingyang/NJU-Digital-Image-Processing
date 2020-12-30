img = imread('..\asset\436.tif');
subplot(3, 3, 1);
imshow(img);

[m, n] = size(img);
p = 2 * m;
q = 2 * n;
f = im2double(img);
% 做0填充
f = [f, zeros(m, q-n)];
f = [f; zeros(p-m, q)];
subplot(3, 3, 2);
imshow(f);
% 乘(-1)^(x+y)
for i = 1:m
    for j = 1:n
        f(i, j) = f(i, j)*((-1)^(i+j));
    end
end
subplot(3, 3, 3);
imshow(f);
% 作傅里叶变换
F = fft2(f);
Fabs = abs(F);
Max = max(max(Fabs));
Fabs = Fabs/Max*256;
c = 256/log(256);
Flog = c*log(1+Fabs);
subplot(3, 3, 4);
imshow(Flog);
% 计算高斯低通滤波器
u = (-p/2):(p/2-1);
v = -(q/2):(q/2-1);
[U, V] = meshgrid(u, v);
D = sqrt(U.^2 + V.^2);
D0 = 20;
H = exp(-(D.^2)./(2*(D0^2)));
subplot(3, 3, 5);
imshow(H*256);
% 进行滤波
G = F .* H;
Gabs = abs(G);
Max = max(max(Gabs));
Gabs = Gabs/Max*256;
c = 256/log(256);
Glog = c*log(1+Gabs);
subplot(3, 3, 6);
imshow(Glog);
% 回到空间域并提取子块
g = ifft2(G);
g = real(g);
for i = 1:p
    for j = 1:q
        g(i, j) = g(i, j)*((-1)^(i+j));
    end
end
subplot(3, 3, 7);
imshow(g);
g = g(1:m, 1:n);
subplot(3, 3, 8);
imshow(g);