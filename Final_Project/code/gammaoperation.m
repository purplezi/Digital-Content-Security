%-------------------------------------------------------------------------%
% This is the test for generate Sourced-Enhanced Composite Images         %
%-------------------------------------------------------------------------%
clc
clear
close all
blocksize = 128; % 100x100=10000
% 用灰度图像做仿真实验
path = 'testimg\gray2.bmp';
% 强制转化为double类型
im = double(imread(path));
% 先将整幅图片进行gamma校正 = round(255(x/255)^r),
gamma1 = 2.0;
imf = double(uint8(255*(im/255).^gamma1));
figure;imshow(uint8(imf));
imwrite(uint8(imf),'testimg\gray2_single.bmp','bmp');
% 第二块地方选择 gamma r1=0.7 调亮 
% 首先先硬编码选择左上角第一块
gamma2 = 0.2;
imf(blocksize+1:2*blocksize,blocksize+1:2*blocksize) = double(uint8(255*(imf(blocksize+1:2*blocksize,blocksize+1:2*blocksize)/255).^gamma2));
% figure;imshow(uint8(imf));
imwrite(uint8(imf),'testimg\gray2_both.bmp','bmp');