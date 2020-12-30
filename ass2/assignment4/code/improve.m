function [output] = improve(input_image)
    if numel(size(input_image)) == 3
        r = input_image(:,:,1);
        g = input_image(:,:,2);
        b = input_image(:,:,3);
        r = improve_with_flt(r);
        g = improve_with_flt(g);
        b = improve_with_flt(b);
        output = cat(3,r,g,b);
    else
        output = improve_with_flt(input_image);
    end
    
    function [output] = improve_with_flt(img)
        f = im2double(img);
        output = f;
        [m, n] = size(f);
        % 大小为(2k+1)^2的高斯双边滤波器
        k = 5; wa = 3; wb = 0.1;
        f = padarray(f, [k, k], 'both');
        % 滤波
        [U, V] = meshgrid(-k:k);
        D = exp(-(U.^2+V.^2)/(2*wa^2));
        for i = 1:m
            for j = 1:n
                tmp = f(i:i+2*k, j:j+2*k);
                R = exp(-((tmp-tmp(k, k)).^2)./(2*wb^2));
                W = D .* R;
                output(i, j) = sum(sum(W .* tmp)) / sum(sum(W));
            end
        end
    end
end