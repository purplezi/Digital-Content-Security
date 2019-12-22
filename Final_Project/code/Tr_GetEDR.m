function [EDR] = Tr_GetEDR(filtered,Nb,wndsize)
% 为什么判断EDR不用0的个数判断 而是通过阈值判断
EDR = ones(Nb,256);
threshold = 1*10^(-3);
for i = 1:Nb
    for j=1:256
        if max(filtered(i,max([1,j-wndsize]):min([256,j+wndsize]))) < threshold
            EDR(i,j) = 0;
        end
    end
end
EDR(1:3)=0;
EDR(254:256)=0;
end

