function [EDR] = Tr_GetEDR(filtered,Nb,wndsize)
% Ϊʲô�ж�EDR����0�ĸ����ж� ����ͨ����ֵ�ж�
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

