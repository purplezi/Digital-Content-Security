function [k,Vgr] = GetGapReference(Vgc,Nb)
% %% 我的做法
% tmp = 0;
% for i = 1:Nb
%     max1 = sum(Vgc(i,:));
%     if max1 > tmp
%         tmp = max1;
%         k1 = i;
%     end
% end
% Vgr1 = Vgc(k1,:);
%% 老师的做法
% sum(Vgc,2)计算的是一行的总和
pos = find(sum(Vgc,2)==max(sum(Vgc,2)));
k = pos(1);
Vgr = Vgc(k,:);
% isequal(Vgr,Vgr1);
end

