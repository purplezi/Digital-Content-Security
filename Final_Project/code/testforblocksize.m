%-----------------------------------------------------------------------------------------------%
% This is the test for the affect of the blocksize in Sourced-Enhanced Composite Images         %
%-----------------------------------------------------------------------------------------------%

% clear work
clc
clear
close all
% 32 40 48 56 64 72 80 88
bz = [32 40 48 56];
% 用灰度图像做仿真实验 图像大小为512*512
% 要是用彩色图像选择绿色通道
path = 'testimg\dog2.png';
im_ori = imread(path);
if ndims(im_ori) == 3
    im_CE = im_ori(:,:,2); % 如果是RGB通道，取G(绿色)通道
else
    im_CE = im_ori;
end

figure;
subplot(1,5,1),imshow(im_ori),title('original image');
for index = 1:length(bz)
    blocksize = bz(index);    
    res = justtest(im_CE,blocksize);
    subplot(1,5,index+1),imagesc(res),colormap('hot'),colorbar,title(['blocksize = ',num2str(blocksize),'未经过阈值化']);
%     subplot(1,5,index+1),imagesc(patt_map_end5'),colormap('hot'),colorbar,title(['blocksize = ',num2str(blocksize),'经过二值化']);
end
