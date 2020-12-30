function [output] = Histogram_equalization(input_image)
if numel(size(input_image)) == 3

%     r=input_image(:,:,1);
%     v=input_image(:,:,2);
%     b=input_image(:,:,3);
%     r1 = hist_equal(r);
%     v1 = hist_equal(v);
%     b1 = hist_equal(b);
%     output = cat(3,r1,v1,b1);  
    
    Input_image = double(input_image);
    r = Input_image(:,:,1);
    g = Input_image(:,:,2);
    b = Input_image(:,:,3);
    [M, N] = size(r);
    %计算H
    theta = acos(0.5.*((r-g)+(r-b))./(sqrt((r-g).^2+(r-b).*(g-b))));
    if (b > g) 
        H = 2*pi - theta;
    else
        H = theta;
    end
    %计算S
    [S] = 1-3.*(min(min(r,g),b))./(r+g+b);
    %计算I
    [I] = uint8((r+g+b)/3);
    %均衡化I
    I = double(hist_equal(I));
    %计算rgb值
    for k = 1:M
        for l = 1:N 
            if (H(k,l) >= 0) && (H(k,l) < 2*pi/3)
                b(k,l) = I(k,l) .* (1 - S(k,l));
                r(k,l) = I(k,l) .* (1 + S(k,l) .* cos(H(k,l)) ./ cos(pi/3-H(k,l)));
                g(k,l) = 3 * I(k,l) - (r(k,l) + b(k,l));
            end
            if (H(k,l) >= 2*pi/3) && (H(k,l) < 4*pi/3)
                H(k,l)=H(k,l) - 2*pi/3;
                r(k,l)=I(k,l) .* (1 - S(k,l));
                g(k,l)=I(k,l) .* (1 + S(k,l) .* cos(H(k,l) - 2*pi/3) ./ cos(pi-H(k,l)));
                b(k,l)=3*I(k,l) - (r(k,l) + g(k,l));     
            end
            if (H(k,l) >= 4*pi/3) && (H(k,l) < 2*pi)
                H(k,l) = H(k,l) - 4*pi/3;
                g(k,l) = I(k,l) .* (1 - S(k,l));
                b(k,l) = I(k,l) .* (1 + S(k,l) .* cos(H(k,l) - 4*pi/3) ./ cos(5*pi/3-H(k,l)));
                r(k,l) = 3*I(k,l) - (g(k,l) + b(k,l));
            end
        end
    end
    r = uint8(r);
    g = uint8(g);
    b = uint8(b);
    output = cat(3,r,g,b); 
    
else
    [output] = hist_equal(input_image);
    
end

    function [output2] = hist_equal(input_channel)
    [m, n] = size(input_channel);
    [output2] = uint8(zeros(m, n));
    [grayscale_hist] = zeros(256, 1);
    for i = 1:m
        for j = 1:n
            grayscale_hist(input_channel(i, j)+1) = grayscale_hist(input_channel(i, j)+1) + 1;
        end
    end
    for i = 2:256
        grayscale_hist(i) = grayscale_hist(i) + grayscale_hist(i-1);
    end
    for i = 1:256
        grayscale_hist(i) = round(grayscale_hist(i)*255/(m*n));
    end
    for i = 1:m
        for j = 1:n
            output2(i, j) = grayscale_hist(input_channel(i, j)+1);
        end
    end
    end
end