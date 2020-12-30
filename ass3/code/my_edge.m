% method can be 'roberts' 'prewitt' 'sobel' 'MarrHildreth' 'Canny'
function output = my_edge(input_image)
      % noise.jpg需要中值滤波
%     input_image = midfilter(input_image);
%     figure; imshow(input_image);
%     title('中值滤波');

    method = 'Canny';
    % parameters for 'roberts' 'prewitt' 'sobel'
    aversize = 1;
    bound = 0.06;
    % parameters for 'MarrHildreth'
    sigma = 2;
    rate = 0.1;
    % parameters for 'Canny'
    sigma2 = 2;
    lowTH = 0.05;
    highTH = 2 * lowTH;
    switch method
        case 'roberts'
            rx = [-1,0;0,1];
            ry = [0,-1;1,0];
            output = common_edge_detection(input_image, rx, ry, aversize, bound);
        case 'prewitt'
            px = [-1,-1,-1;0,0,0;1,1,1];
            py = [-1,0,1;-1,0,1;-1,0,1];
            output = common_edge_detection(input_image, px, py, aversize, bound);
        case 'sobel'
            sx = [-1,-2,-1;0,0,0;1,2,1];
            sy = [-1,0,1;-2,0,2;-1,0,1];
            output = common_edge_detection(input_image, sx, sy, aversize, bound);
        case 'MarrHildreth'
            % 确定大小
            n = floor(6 * sigma);
            if mod(n, 2) == 0
                n = n+1;
            end
            % LoG算子滤波
            G = zeros(n, n);
            h = (n+1)/2;
            for i = 1:n
                for j = 1:n
                    x = i-h;
                    y = j-h;
                    G(i,j) = ((x^2+y^2-2*(sigma^2))/(sigma^4))*exp(-(x^2+y^2)/(2*(sigma^2))); 
                end
            end
            g = imfilter(input_image, G);
            % 找零交叉点
            output = g;
            [m, n] = size(g);
            threshold = max(max(g))*rate;
            for i=2:m-1
                for j=2:n-1
                    output(i, j) = 0;
                    if g(i, j+1)*g(i, j-1) < 0 && abs(g(i, j+1)-g(i, j-1)) > threshold
                        output(i, j) = 1;
                    elseif g(i+1, j)*g(i-1, j) < 0 && abs(g(i+1, j)-g(i-1, j)) > threshold
                        output(i, j) = 1;
                    elseif g(i+1, j+1)*g(i-1, j-1) < 0 && abs(g(i+1, j+1)-g(i-1, j-1)) > threshold
                        output(i, j) = 1;
                    elseif g(i-1, j+1)*g(i+1, j-1) < 0 && abs(g(i-1, j+1)-g(i+1, j-1)) > threshold
                        output(i, j) = 1;
                    end
                end
            end
        case 'Canny'
            % 高斯算子滤波
            n = floor(6 * sigma);
            if mod(n, 2) == 0
                n = n+1;
            end
            G = fspecial('Gaussian', [n, n], sigma2);
            F = imfilter(input_image, G);
            % 计算梯度大小和方向
            [m, n] = size(F);
            gx = imfilter(F, [-1,0,1;-1,0,1;-1,0,1]);
            gy = imfilter(F, [-1,-1,-1;0,0,0;1,1,1]);
            M = (gx.^2+gy.^2).^0.5 ;
            theta = atand(gx./gy);
            % 非最大抑制
            gN = zeros(m, n);
            for i = 2:(m-1)
                for j = 2:(n-1) 
                    if theta(i, j) < 67.5 && theta(i, j) > 22.5
                        if M(i, j) >= M(i+1,j+1) && M(i,j) >= M(i-1,j-1)
                            gN(i, j) = M(i, j);
                        else
                            gN(i, j) = 0;
                        end
                    elseif theta(i, j) < -22.5 && theta(i, j) > -67.5
                        if M(i, j) >= M(i+1,j-1) && M(i,j) >= M(i-1,j+1)
                            gN(i, j) = M(i, j);
                        else
                            gN(i, j) = 0;
                        end
                    elseif theta(i, j) < 22.5 && theta(i, j) > -22.5
                        if M(i, j) >= M(i+1,j) && M(i,j) >= M(i-1,j)
                            gN(i, j) = M(i, j);
                        else
                            gN(i, j) = 0;
                        end
                    else
                        if M(i, j) >= M(i,j-1) && M(i,j) >= M(i,j+1)
                            gN(i, j) = M(i, j);
                        else
                            gN(i, j) = 0;
                        end
                    end
                end
            end
            % 滞后阈值
            output = zeros(m, n);
            for i = 2:(m-1)
                for j = 2:(n-1)
                    if gN(i, j) < lowTH
                        output(i, j) = 0;
                    elseif gN(i, j) > highTH
                        output(i, j) = 1;
                    else
                        Max = max(max([gN(i-1, j-1), gN(i-1, j), gN(i-1, j+1);
                                       gN(i, j-1),   gN(i, j),   gN(i, j+1);
                                       gN(i+1, j-1), gN(i+1, j), gN(i+1, j+1)]));
                        if  Max > highTH
                            output(i, j) = 1;
                        else
                            output(i,j) = 0;
                        end
                    end
                end
            end
    end
    function output = common_edge_detection(img, fx, fy, size, bound)
        aver = fspecial('average', size);
        f = imfilter(img, aver);
        wx = imfilter(f, fx);
        wy = imfilter(f, fy);
        w = abs(wx) + abs(wy);
        thr = max(max(w))*bound;
        w(w > thr) = 1;
        w(w <= thr) = 0;
        output = w;
    end
    function output = midfilter(img)
        [a, b] = size(img);
        output = img;
        for p = 5:(a-4)
            for q = 5:(b-4)
                output(p, q) = median(reshape(img(p-4:p+4, q-4:q+4), [9*9, 1]));
            end
        end
    end
end