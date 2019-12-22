function [Vc] = correctbins(V,Nb,threshold)
%% 我的方法
% apply a threshold-based binarization
% 统计列数 求列均值作为参考 如果列均值大于一个阈值 则该处设为1，否则为0
% 找参考向量相当于老师的peak_gap_pattern_find_2ndReply 函数
C = sum(V);
C = C / Nb;
% detected co-existing gap positions 
Vr = C > threshold;
% the corrected gap position vector
Vc = zeros(size(V));
for i = 1:size(V,1)
    Vc(i,:) = V(i,:).*Vr;
end

%% 老师的方法
hist_y = sum(V)/sum(sum(V));
hist_y(1) = 0;
hist_y(end) = 0;
patt = hist_y>threshold;
pPosit = zeros(size(V));
for i=1:size(V,1)
    pPosit(i,:)=V(i,:).*patt;
end
%pos = find(pPosit~=Vc)
%isequal(Vc,pPosit)