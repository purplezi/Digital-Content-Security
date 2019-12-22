function [EDR_p,Vpr1] = GetPeakReference(Nb,Vpc,Mg,EDR,tg)
% 峰值用于检测相似度的参考向量需要依靠谷值的相似度进行阈值化
%% 老师的写法
Mp = Mg;
for i = 1:size(Mg,1)
    for j = 1:size(Mg,2)
        if Mg(i,j) > tg
            Mp(i,j)=1;
        end
    end
end
% 选出了所有Mg大于阈值tg的块
% 对这些块进行指示函数的处理
% （1） 统计像素块中同一像素的个数和
EDR_p = zeros(1,256);
Vpr1 = zeros(1,256);
for i = 1:size(Mg,1)
    for j = 1:size(Mg,2)
        if Mp(i,j)==1
            Vpr1 = Vpr1 + Vpc((j-1)*size(Mg,1)+i,:);
            EDR_p = EDR_p + EDR((j-1)*size(Mg,1)+i,:);
        end
    end
end
Vpr1 = (Vpr1>=1);
EDR_p = (EDR_p>=1);
