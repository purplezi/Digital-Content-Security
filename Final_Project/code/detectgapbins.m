% 参数为1x256的归一化灰度直方图矩阵 返回值为zero-height gap bins的个数
function [Vg] = detectgapbins(gh)
%-------------------------------------------------------------------------%
% Detect the bin at k as a zero-height gap bin                            %
%-------------------------------------------------------------------------%
% 遍历所有的元素
w = 3;
threshold = 0.001;
Vg = zeros(1,256);
%Vg1 = zeros(1,256);

for i = w+1:256-w-1
    aver = mean([gh(max(1,i-w):i-1),gh(i+1:min(255,i+w))]);
    Vg(i) = (gh(i)==0)*(min(gh(i-1),gh(i+1))>threshold)*(aver>threshold);
end

% %%% 自己非常low的写法，上面是参考老师后的改进的写法
% for i = 1:256
%     flg = 0;
%     % 满足像素值个数为0
%     if gh(i) == 0
%         flg = flg + 1;
%     end
%     % 满足前后像素值个数的最小值大于一个阈值
%     if i-1>=1 && i+1<=256 && min(gh(i-1),gh(i+1)) > threshold
%         flg = flg + 1;
%     end
%     % 满足区间[i-w,i+w]的像素总值和大于阈值
%     if i-w >=1 && i+w<=256
%         cnt = 0;
%         for j=i-w:i+w
%             cnt = cnt + gh(j);
%         end
%         jud = cnt/(2*w+1);
%         if  jud > threshold
%             flg = flg + 1;
%         end
%     end
%     if flg == 3
%         Vg1(i) = 1;
%     end
% end
% % 判断两个矩阵是否相等
% isequal(Vg,Vg1);

end
