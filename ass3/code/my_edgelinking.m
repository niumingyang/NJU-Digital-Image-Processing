function output = my_edgelinking(binary_image, row, col)
    [m, n] = size(binary_image);
    if row < 1 || row > m 
        error("row fault");
    elseif col < 1 || col > n
        error("col fault");
    elseif binary_image(row, col) == 0
        error("wrong point");
    end
    used = zeros(m, n);
    neighbour = [-1, 0; -1, -1; 0, -1; 1, -1; 1, 0; 1, 1; 0, 1; -1, 1];
    % 表示方向为   上     左上   左     左下    下    右下  右     右上
    % 对应dir为    0      1      2      3      4      5    6       7
    nowi = row;
    nowj = col;
    output = [row, col];
    dir = 2;
    while used(nowi, nowj) ~= 1
        dir = mod(dir-2, 8);
        used(nowi, nowj) = 1;
        output = [output; [nowi, nowj]];
        for k = 0:7
            nowdir = mod(dir+k, 8);
            tmpi = nowi+neighbour(nowdir+1,1);
            tmpj = nowj+neighbour(nowdir+1,2);
            if binary_image(tmpi, tmpj) == 1 && used(tmpi, tmpj) ~= 1
                nowi = tmpi;
                nowj = tmpj;
                dir = nowdir;
                break;
            end
        end
    end
end