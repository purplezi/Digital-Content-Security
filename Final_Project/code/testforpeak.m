%-------------------------------------------------------------------------%
% This is the test for identify Sourced-Enhanced Composite Images         %
%-------------------------------------------------------------------------%

% clear work
clc
clear
close all

% 得先处理一幅图片 让一个块的对比度用gamma r1增强，另一个块的对比度用gamma r2增强 见gammaoperation.m文件
blocksize = 64; % 10x10=100
% 用灰度图像做仿真实验
% 要是用彩色图像还没想好用什么通道，应该用什么通道都可以 ，只需要我处理r1和r2的时候在同一个通道上处理就行
path = 'testimg\gray1_gamma.bmp';

% path = 'testimg\gray1.bmp'; % gap效应不明显
im = imread(path);
[r,c] = size(im);

%-------------------------------------------------------------------------%
% Step 1: Compute blockwise histogram                                     %
%-------------------------------------------------------------------------%

% 先考虑能整除的去仿真
% the number of divided blocks
Nb = r*c/(blocksize*blocksize);
Nbr = r/blocksize;
Nbc = c/blocksize;

%-------------------------------------------------------------------------%
% Step 2: Blockwise Peak/Gap Bins Location                                %
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
        for h = 1+(i-1)*blocksize:i*blocksize
            for k = 1+(j-1)*blocksize:j*blocksize
                num = im(h,k)+1;
                blockhist(ind,num) = blockhist(ind,num) + 1;
            end 
        end
        Vg(ind,:)=detectgapbins(blockhist(ind,:));
        ind = ind + 1;
    end
end

% 判断Vg中是否全为0
% any(Vg)

%-------------------------------------------------------------------------%
% B.Correct gap bins 校正的代码可复用

% 校验的阈值应该取多少 盲猜0.01
gc_threshold = 0.01;
Vgc = correctbins(Vg,Nb,gc_threshold);

%-------------------------------------------------------------------------%
% C.Locate peak bins  

% % 填充
% % 用左右两个bins的均值
% width = 1;
% gapfilled = GetGapfilledhistogram(Vg,blockhist,Nb,width);
% % 中值滤波 窗口为5x5 接一个3x3的均值滤波 还未实现
% wndsize = 5; % 5
% aversize = 3;
% filtered = GetFilteredHistogram(gapfilled,Nb,wndsize,aversize);
% % 阈值化求解
% % Vp是表示每一块的每个灰度值是否是peak bin
% dis = filtered - gapfilled;
% di = sum(abs(dis));
% tot = sum(abs(dis(:)));
% figure,bar(di/tot),title('图像第一块的差值灰度直方图');

res = zeros(Nb,256);
edr = zeros(Nb);
for i = 1:Nb
[res(i,:),e] = peakBin_detect(blockhist(1,:));
edr(i)= e;
end





