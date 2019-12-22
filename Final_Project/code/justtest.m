function [res] = justtest(im_CE,blocksize)
binCenters = 0:1:255;
%-------------------------------------------------------------------------%
% Step 1: Compute blockwise histogram 计算块直方图                         %
%-------------------------------------------------------------------------%

% 先考虑长宽能整除的去仿真
% the number of divided blocks
[r,c] = size(im_CE);
Nbr = fix(r/blocksize);
Nbc = fix(c/blocksize);
Nb = Nbr*Nbc;

%-------------------------------------------------------------------------%
% Step 2: Blockwise Peak/Gap Bins Location 计算块的峰谷位置                %
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% A.Locate gap bins  

% 灰度值0-255 换为灰度值1-256
% Vg是表示每一块的每个灰度值是否是gap bin
Vg = zeros(Nb,256);
blockhist = zeros(Nb,256);
ind = 1;
for i = 1:Nbr
    for j = 1:Nbc
        % 取每一块
        % 统计灰度直方图
        im_bk = im_CE(1+(i-1)*blocksize:i*blocksize,1+(j-1)*blocksize:j*blocksize);
        blockhist(ind,:) = hist(reshape(im_bk,blocksize*blocksize,1),binCenters);
        % 归一化
        blockhist(ind,:) = blockhist(ind,:)/sum(blockhist(ind,:));
        % 先不管有效检测区
        Vg(ind,:)=detectgapbins(blockhist(ind,:));
        ind = ind + 1;
    end
end

%-------------------------------------------------------------------------%
% B.Correct gap bins 校正的代码可复用

% 校验的阈值应该取多少 
gc_threshold = 2*(10^(-3));
Vgc = correctbins(Vg,Nb,gc_threshold);

%-------------------------------------------------------------------------%
% C.Locate peak bins  

% 利用领域均值填充已检测到的谷单元
% 填充方法 [k-width,k+width]的和求均值
width = 1;
gapfilled = GetGapfilledhistogram(Vg,blockhist,Nb,width);
% 中值滤波 窗口为5x5 接一个3x3的均值滤波 还未实现
wndsize = 3; % 5
aversize = 3;
filtered = GetFilteredHistogram(gapfilled,Nb,wndsize,aversize);
% 阈值化求解
% Vp是表示每一块的每个灰度值是否是peak bin
dis = gapfilled - filtered;
dis = dis.*(dis>0);
%figure,bar(abs(dis(1,:))),title('图像第一块的差值灰度直方图');

% 阈值化检测
peakbin_threshold = 0.01;% 0.005 0.01 seems more perfect?
Vp = dis > peakbin_threshold;

%-------------------------------------------------------------------------%
% D.Correct peak bins
pc_threshold = 2*(10^(-3)); %阈值取多少 0.005 0.01 seems more perfect
Vpc = correctbins(Vp,Nb,pc_threshold);

%-------------------------------------------------------------------------%
% Step 3: Peak/Gap Similarity Measure                                     %
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% EDR(Effective Detection Range) 获取有效检测区
% EDR 有效检测区 Ω 如何求解
% 我的理解，从第一个像素开始（这个不是很确定），往后走如果遇到第一个满足后面都是0的，则区间到它
% EDR1 = GetEDR(Nb,blockhist);
% 老师的方法是根据 峰单元检测的结果和一个区间内的最大值的二值化得到EDR
EDR = Tr_GetEDR(filtered,Nb,5);
Vgc = Vgc.*EDR;
Vpc = Vpc.*EDR;

% 调用老师的代码 pattern_learn_2ndReply 可以输出图像
% [map] = pattern_learn_2ndReply(Vpc,Vgc,[r,c],blocksize,EDR);

%-------------------------------------------------------------------------%
% A.Select gap reference vector Vgr
% k表示区域
[k,Vgr] = GetGapReference(Vgc,Nb);

%----------------------------------------------------------------------------------%
% B.Compute similarity betweem Vgc and Vgr
% 参照是第k块，其中参照向量为Vgr
% 1:gaps are matched 0:all gap-involved pairs mismatched 0~1:match~mismatch
Mg = ComputeSimilarity(Nb,Vgc,Vgr,EDR(k,:),EDR,[r,c],blocksize);

%-------------------------------------------------------------------------%
% C.Create peak reference vector Vpr 需要依据上面的得到相应的blocks
tg = 0.75; % 0.5-0.8
[EDR_Nr,Vpr] = GetPeakReference(Nb,Vpc,Mg,EDR,tg);

%-------------------------------------------------------------------------%
% D.Compute similarity
Mp = ComputeSimilarity(Nb,Vpc,Vpr,EDR_Nr,EDR,[r,c],blocksize);

%-------------------------------------------------------------------------%
% Step 4: Composition Detection                                           %
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% A.Similarity Maps Fusion
for i = 1:size(Mg,1)
    for j =1:size(Mg,2)
        if Mg(i,j)~=-10 && Mp(i,j)~=-10
            M(i,j) = (Mg(i,j)+Mp(i,j))/2;
        elseif Mg(i,j) == -10 || Mp(i,j) == -10
            M(i,j) = max(Mg(i,j),Mp(i,j));
        else
            M(i,j) = -10;
        end
    end
end

%-------------------------------------------------------------------------%
% B.Assign source index 源区域定位 
patt_map_end = M;
patt_map_end2 = patt_map_end;
for i=1:size(patt_map_end,1)
    for j=1:size(patt_map_end,2)
        if patt_map_end(i,j)==-10 
           mat = patt_map_end(max(i-1,1):min(i+1,size(patt_map_end,1)),max(j-1,1):min(j+1,size(patt_map_end,2)));
           % 如果出现-1的个数多于一半，则该点的值是由周围出现其他不为-1的值的平均值决定的
           % 出现-1的原因是EDR没有交叉点
           if length(find(mat==-10))<(size(mat,1)*size(mat,2)*0.50)
              patt_map_end2(i,j)=mean(mat(find(mat~=-10)));
           end
        end
    end
end 

% 后面的处理都是为了能够准确定位 对比度增强的位置
th3 = 0.15; 
patt_map_end3 = patt_map_end2;
patt_map_end3 = (patt_map_end2>th3) + (-10)*(patt_map_end2==-10); 
patt_map_end4 = patt_map_end3;
c = [1,0,-10];
for i=1:size(patt_map_end3,1)
    for j=1:size(patt_map_end3,2)
        mat = patt_map_end3(max(i-1,1):min(i+1,size(patt_map_end3,1)),max(j-1,1):min(j+1,size(patt_map_end3,2)));
        n(1)=length(find(mat==1));
        n(2)=length(find(mat==0));
        n(3)=length(find(mat==-10));
        t=find(n==max(n));
        if  patt_map_end4(i,j)~=c(t(1))
            patt_map_end4(i,j)=c(t(1));
        end
    end
end

patt_map_end5 = patt_map_end4;
if max(size(patt_map_end4))<2
for i=2:size(patt_map_end3,1)-1
    for j=2:size(patt_map_end3,2)-1
        mat = patt_map_end3(max(i-1,1):min(i+1,size(patt_map_end3,1)),max(j-1,1):min(j+1,size(patt_map_end3,2)));
        if ~sum(sum(abs(mat-[1 0 0;1 0 0;1 1 1]))) || ~sum(sum(abs(mat-[0 0 1;0 0 1;1 1 1])))|| ~sum(sum(abs(mat-[1 1 1;0 0 1;0 0 1]))) || ~sum(sum(abs(mat-[1 1 1;1 0 0;1 0 0])))
           patt_map_end5(i,j) = patt_map_end3(i,j);
        elseif   ~sum(sum(abs(mat-[0 1 1;0 1 1;0 0 0]))) || ~sum(sum(abs(mat-[1 1 0;1 1 0;0 0 0]))) || ~sum(sum(abs(mat-[0 0 0;1 1 0;1 1 0]))) || ~sum(sum(abs(mat-[0 0 0;0 1 1;0 1 1]))) 
           patt_map_end5(i,j) = patt_map_end3(i,j);    
        end
    end
end
for i=2:size(patt_map_end3,1)-1
    for j=[1,size(patt_map_end3,2)]
        mat = patt_map_end3(max(i-1,1):min(i+1,size(patt_map_end3,1)),max(j-1,1):min(j+1,size(patt_map_end3,2)));
        if ~sum(sum(abs(mat-[1 0;1 0;1 0]))) || ~sum(sum(abs(mat-[0 1;0 1;0 1] )))
           patt_map_end5(i,j) = patt_map_end3(i,j); 
        end
    end
end
for i=[1,size(patt_map_end3,1)]
    for j=2:size(patt_map_end3,2)-1
        mat = patt_map_end3(max(i-1,1):min(i+1,size(patt_map_end3,1)),max(j-1,1):min(j+1,size(patt_map_end3,2)));
        if ~sum(sum(abs(mat-[0 0 0;1 1 1]))) || ~sum(sum(abs(mat-[1 1 1;0 0 0])))
           patt_map_end5(i,j) = patt_map_end3(i,j);
        end
    end
end
end 
res = patt_map_end2';
end

