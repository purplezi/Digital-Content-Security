% function [filtered] = GetFilteredHistogram(gapfilled,Nb,wndsize,aversize)
% filtered = zeros(Nb,256);
% for i = 1:Nb
%     % ��ֵ�˲�
%     filtered(i,:) = medfilt2(gapfilled(i,:),[1,wndsize*wndsize]);
%     % ��ֵ�˲�
%     h = fspecial('average',[1,aversize*aversize]);
%     filtered(i,:) = filter2(h,filtered(i,:));
% end
% fi = sum(filtered);
% tot = sum(filtered(:));
% figure;bar(fi/tot,0.9),title('ͼ�񾭹���ֵ�˲��;�ֵ�˲����ֱ��ͼ');
% end

function [filtered] = GetFilteredHistogram(gapfilled,Nb,wndsize,aversize)
%% statistical order filtering??
f = zeros(Nb,256);
for i = 1:Nb
    for j = 4:253
        mean = [gapfilled(i,max(j-wndsize,1):min(255,j+wndsize))];
        mean = sort(mean);
        f(i,j) = mean(wndsize);
    end
end
%% follow by average filtering
w = 1;
filtered = f;
for i = 1:Nb
    for j = 5:256-5
        filtered(i,j) = sum(f(i,j-w:j+w)) / (2*w+1);
    end
end
end