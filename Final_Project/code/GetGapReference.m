function [k,Vgr] = GetGapReference(Vgc,Nb)
% %% �ҵ�����
% tmp = 0;
% for i = 1:Nb
%     max1 = sum(Vgc(i,:));
%     if max1 > tmp
%         tmp = max1;
%         k1 = i;
%     end
% end
% Vgr1 = Vgc(k1,:);
%% ��ʦ������
% sum(Vgc,2)�������һ�е��ܺ�
pos = find(sum(Vgc,2)==max(sum(Vgc,2)));
k = pos(1);
Vgr = Vgc(k,:);
% isequal(Vgr,Vgr1);
end

