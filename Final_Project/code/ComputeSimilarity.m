function [Mg1] = ComputeSimilarity(Nb,Vc,Vr,EDR_k,EDR,imsiz,blocksize)
% %% 我的写法
% % Mg向量创建为一维的向量 后续不太好变为一个二维数组的图像展示
% % 所以应该变为二维矩阵
% Mg = zeros(1,Nb);
% for i = 1:Nb
%     sum1 = 0;
%     sum2 = 0;
%     sum3 = 0;
%     mi = min(EDR(i,:),EDR_k);
%     for j = 1:mi
%         sum1 = sum1 + Vc(i,j)*Vr(j);
%         sum2 = sum2 + (1 - Vc(i,j))*Vr(j);
%         sum3 = sum3 + Vc(i,j)*(1-Vr(j));
%     end
%     if sum1 == 0 
%         Mg(i) = -1;
%     else
%         Mg(i) = sum1 /(sum1+sum2+sum3);
%     end
% end
%% 老师的写法
Mg1 = (-10)*ones(fix(imsiz/blocksize));
Mg1 = Mg1';
% Vr是一维向量
% 对于每一行
for i = 1:size(Vc,1)
    sum1 = sum((Vc(i,:).*Vr).*(EDR(i,:).*EDR_k));
    sum2 = sum(((~Vc(i,:)).*Vr).*(EDR(i,:).*EDR_k));
    sum3 = sum((Vc(i,:).*(~Vr)).*(EDR(i,:).*EDR_k));
    tot = sum1 + sum2 + sum3;
    [Mg1(i)] = sum1/tot;
%     if sum1 == 0
%         [Mg1(i)] = -10;
%     elseif tot ~= 0
%         [Mg1(i)] = sum1/tot;
%     end
end
% find(Mg~=Mg1)
end

