% 正确率的检测
% clear work
clc
clear
close all
blocksize = 64; % 32 48 64 80 96 % 200 100 50 25
% 用灰度图像做仿真实验 图像大小为512*512
% 要是用彩色图像还没想好用什么通道，应该用什么通道都可以 ，只需要我处理r1和r2的时候在同一个通道上处理就行
% 对10幅图像，每幅产生20幅测试图片 
threshold = 0.01;
correct = zeros(1,10);
maxnum = 100;
path = 'testimg\img';
for p = 1:10
    impath = [path,num2str(p),'.png'];
    im_ori = imread(impath);
    if ndims(im_ori) == 3
        im = im_ori(:,:,2); % 如果是RGB通道，取G(绿色)通道
    else
        im = im_ori;
    end
    [r,c] = size(im);
    Nb = fix(r/blocksize)*fix(c/blocksize);
    cnt = 0;
    for i = 1:maxnum
        % 随机产生的矩阵
        [ideal_map,img] = enforce_CE(im,blocksize);
        % 经过测试产生的矩阵
        res = justtest(img,blocksize);
        res(find(isnan(res)==1)) = 0;
        res1 = (res>threshold);
        %figure,imagesc(res),colormap('hot'),colorbar;
        ans1 = (res1==ideal_map);
        cnt = cnt + sum((sum(ans1)))/Nb;
    end
    correct(p) = (cnt/maxnum)*100;
end
plot(correct,'-o'),xlabel('10 images'),ylabel('Correctness(%)'),title('对10幅图片随机产生100张图片后检测的正检率');