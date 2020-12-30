function image_filtering(img, filt)
    figure;
    % ԭͼ
    [m, n] = size(img);
    subplot(2, 2, 1);
    imshow(img);
    title('ԭͼ');
    
    % �ռ����˲�
    h = get_filter(filt);
    [r, c] = size(h);
    f = im2double(img);
    g = f;
    % ��ԭͼ����0����Ա�ռ����˲�
    p = m + r - 1;
    q = n + c - 1;
    f = [zeros(m, (q-n)/2), f, zeros(m, (q-n)/2)];
    f = [zeros((p-m)/2, q); f; zeros((p-m)/2, q)];
    % ͨ����ز������пռ����˲�
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
    title('�ռ����˲�');
    
    % Ƶ�����˲�����ͼ��
    h = get_filter(filt);
    [r, c] = size(h);
    % �ҵ�������Ĵ�Сp,q
    p = m + r - 1;
    if mod(p, 2)
        p = p+1;
    end
    q = n + c - 1;
    if mod(q, 2)
        q = q+1;
    end
    % �Կռ����˲����ӽ��������
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
    % ��h����(-1)^(x+y)����Ƶ���������Ƶ�����
    H = fft2(h .* transform);
%     H = H - real(H);
    % ��h�Ƶ�hp������
    H = H .* transform;
%     H = freqz2(h, p, q);
    subplot(2, 2, 3);
    imshow(abs(H), []);
    title('Ƶ��������');
    
    % Ƶ�����˲����
    f = im2double(img);
    % ��Ƶ����ͼ���Ƶ�����
    for i = 1:m
        for j = 1:n
            f(i, j) = f(i, j)*((-1)^(i+j));
        end
    end
    % �������ĸ���Ҷ�任
    F = fft2(f, p, q);
    % Ƶ�����˲�
    F = F .* H;
    % ���ؿռ��򲢲ü�
    g = real(ifft2(F)) .* transform;
    g = g(1:m, 1:n);
    subplot(2, 2, 4);
    imshow(g, []);
    title('Ƶ�����˲�');
    
    % �����ռ��˲�����
    function [output]=get_filter(str)
        % output��sizeֻ��Ϊ����
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