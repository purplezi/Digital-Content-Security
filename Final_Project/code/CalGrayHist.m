function [G_hist] = CalGrayHist(r,c,gray)
G_hist = zeros(1,256);
for i = 1:r
    for j = 1:c
        ind = gray(i,j) + 1;
        G_hist(ind) = G_hist(ind) + 1;
    end
end
end

