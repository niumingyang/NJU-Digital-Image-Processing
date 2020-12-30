function image_filtering(img, filt)
    figure;
    % 原图
    [m, n] = size(img);
    subplot(2, 2, 1);
    imshow(img);
    title('原图');
    
    % 空间域滤波
    h = get_filter(filt);
    [r, c] = size(h);
    f = im2double(img);
    g = f;
    % 对原图进行0填充以便空间域滤波
    p = m + r - 1;
    q = n + c - 1;
    f = [zeros(m, (q-n)/2), f, zeros(m, (q-n)/2)];
    f = [zeros((p-m)/2, q); f; zeros((p-m)/2, q)];
    % 通过相关操作进行空间域滤波
    for i = 1:m
        for j = 1:n
            tmp = f(i:i+r-1, j:j+c-1);
            tmp = tmp .* h;
            g(i, j) = sum(sum(tmp));
        end
    end
%     g = imfilter(img, h);
    subplot(2, 2, 2);
    imshow(g, []);
    title('空间域滤波');
    
    % 频率域滤波算子图像
    h = get_filter(filt);
    [r, c] = size(h);
    % 找到零填充后的大小p,q
    p = m + r - 1;
    if mod(p, 2)
        p = p+1;
    end
    q = n + c - 1;
    if mod(q, 2)
        q = q+1;
    end
    % 对空间域滤波算子进行零填充
    if mod(q-c, 2)
        h = [zeros(r, (q-c+1)/2), h, zeros(r, (q-c-1)/2)];
        h = [zeros((p-r+1)/2, q); h; zeros((p-r-1)/2, q)];
    else
        h = [zeros(r, (q-c)/2), h, zeros(r, (q-c)/2)];
        h = [zeros((p-r)/2, q); h; zeros((p-r)/2, q)];
    end
    transform = ones(p, q);
    for i = 1:p
        for j = 1:q
            transform(i, j) = (-1)^(i+j);
        end
    end
    % 将h乘以(-1)^(x+y)，将频率域算子移到中心
    H = fft2(h .* transform);
%     H = H - real(H);
    % 将h移到hp的中心
    H = H .* transform;
%     H = freqz2(h, p, q);
    subplot(2, 2, 3);
    imshow(abs(H), []);
    title('频率域算子');
    
    % 频率域滤波结果
    f = im2double(img);
    % 将频率域图像移到中心
    for i = 1:m
        for j = 1:n
            f(i, j) = f(i, j)*((-1)^(i+j));
        end
    end
    % 有零填充的傅里叶变换
    F = fft2(f, p, q);
    % 频率域滤波
    F = F .* H;
    % 返回空间域并裁减
    g = real(ifft2(F)) .* transform;
    g = g(1:m, 1:n);
    subplot(2, 2, 4);
    imshow(g, []);
    title('频率域滤波');
    
    % 产生空间滤波算子
    function [output]=get_filter(str)
        % output的size只能为奇数
        switch str
            case 'sobel'
                [output] = [-1,0,1; -2,0,2; -1,0,1];
%                 [output] = [1,0,-1; 2,0,-2; 1,0,-1];
            case 'laplacian'
                [output] = [0,1,0; 1,-4,1; 0,1,0];
            case 'laplacian2'
                [output] = [1,1,1; 1,-8,1; 1,1,1];
            case 'average'
                size = 9;
                [output] = ones(size, size) ./ (size^2);
            otherwise
                [output] = ones(1, 1);
        end
    end
end