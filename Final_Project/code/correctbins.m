function [Vc] = correctbins(V,Nb,threshold)
%% �ҵķ���
% apply a threshold-based binarization
% ͳ������ ���о�ֵ��Ϊ�ο� ����о�ֵ����һ����ֵ ��ô���Ϊ1������Ϊ0
% �Ҳο������൱����ʦ��peak_gap_pattern_find_2ndReply ����
C = sum(V);
C = C / Nb;
% detected co-existing gap positions 
Vr = C > threshold;
% the corrected gap position vector
Vc = zeros(size(V));
for i = 1:size(V,1)
    Vc(i,:) = V(i,:).*Vr;
end

%% ��ʦ�ķ���
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