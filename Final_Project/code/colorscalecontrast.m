%-------------------------------------------------------------------------%
% Test for the zero-height gap and show the peak/gap artifacts            % 
%-------------------------------------------------------------------------%

% clear work
clc
clear
close all

%-------------------------------------------------------------------------%
% imadjust是对rgb三通道同步做对应的伽马次幂运算，所以在rgb上检测的效果明显   %
% 如果将rgb转化为灰度通道是看不到效应的，因为是在rgb上进行操作的             %
%-------------------------------------------------------------------------%

% read an RGB image into the workspace
path = 'testimg/lena512color.tif';
ori_im = imread(path);

%-------------------------------------------------------------------------%
% rgb2ntsc                                                                % 
%-------------------------------------------------------------------------%

Y = rgb2ntsc(ori_im);
Y = Y(:,:,1);
Y = uint8(255*Y);
[r,c] = size(Y);
G_hist = CalGrayHist(r,c,Y);
G_hist=G_hist/(r*c);

% After Jpeg compression Q=50
imwrite(ori_im,'testimg/test.jpg','jpg','Quality',50);
jpath = 'testimg/test.jpg';
jpg_im = imread(jpath);
jpg_G = rgb2ntsc(jpg_im);
jpg_G = uint8(255*jpg_G(:,:,1));
jpgG_hist = CalGrayHist(r,c,jpg_G);
jpgG_hist=jpgG_hist/(r*c);

% Gamma变换： y=x^gamma;
% gamma>1, 较亮的区域灰度被拉伸，较暗的区域灰度被压缩的更暗，图像整体变暗；
% gamma<1, 较亮的区域灰度被压缩，较暗的区域灰度被拉伸的较亮，图像整体变亮；
% 经过enhancement r=1.2 Gamma值为1.2

gamma = 0.5;
Gamma = imadjust(ori_im,[],[],gamma);
imwrite(Gamma,'testimg/Gamma.bmp','bmp');
% Gamma_G = rgb2gray(Gamma);
% Ga = imread('testimg/Gamma.bmp');
Gamma_G = rgb2ntsc(Gamma);
Gamma_G = uint8(255*Gamma_G(:,:,1));
GG_hist = CalGrayHist(r,c,Gamma_G);
GG_hist=GG_hist/(r*c);


% 画原图 + 经过q=50的图像 + enhancement r 
figure;
subplot(2,3,1),imshow(ori_im),title('The original image');
subplot(2,3,2),imshow(jpg_im),title('JPEG (Q =50)');
subplot(2,3,3),imshow(Gamma),title(['enhanced (Gamma value =',mat2str(gamma), ')']);
subplot(2,3,4),bar(G_hist,0.9),xlabel('Pixel Gray Level'),ylabel('Normalized Histogram');
subplot(2,3,5),bar(jpgG_hist,0.9),xlabel('Pixel Gray Level'),ylabel('Normalized Histogram');
subplot(2,3,6),bar(GG_hist,0.9),xlabel('Pixel Gray Level'),ylabel('Normalized Histogram');
% 加总标题
suptitle('Histogram of grayscale image');

%-------------------------------------------------------------------------%
% rgb2gray                                                                % 
%-------------------------------------------------------------------------%

% Convert RGB Image to Grayscale Image
Y = rgb2gray(ori_im);
G_hist = CalGrayHist(r,c,Y);
G_hist=G_hist/(r*c);

% After Jpeg compression Q=50
imwrite(ori_im,'testimg/test.jpg','jpg','Quality',50);
jpath = 'testimg/test.jpg';
jpg_im = imread(jpath);
jpg_G = rgb2gray(jpg_im);
jpgG_hist = CalGrayHist(r,c,jpg_G);
jpgG_hist=jpgG_hist/(r*c);

% Gamma变换： y=x^gamma;
% gamma>1, 较亮的区域灰度被拉伸，较暗的区域灰度被压缩的更暗，图像整体变暗；
% gamma<1, 较亮的区域灰度被压缩，较暗的区域灰度被拉伸的较亮，图像整体变亮；
% 经过enhancement r=1.2 Gamma值为1.2

gamma = 1.5;
Gamma = imadjust(ori_im,[],[],gamma);
imwrite(Gamma,'testimg/Gamma.bmp','bmp');
% Ga = imread('testimg/Gamma.bmp');
Gamma_G = rgb2gray(Gamma);
GG_hist = CalGrayHist(r,c,Gamma_G);
sum(sum(GG_hist==0))
GG_hist=GG_hist/(r*c);

% 画原图 + 经过q=50的图像 + enhancement r
figure;
subplot(2,3,1),imshow(ori_im),title('The original image');
subplot(2,3,2),imshow(jpg_im),title('JPEG (Q =50)');
subplot(2,3,3),imshow(Gamma),title(['enhanced (Gamma value =',mat2str(gamma), ')']);
subplot(2,3,4),bar(G_hist,0.9),xlabel('Pixel Gray Level'),ylabel('Normalized Histogram');
subplot(2,3,5),bar(jpgG_hist,0.9),xlabel('Pixel Gray Level'),ylabel('Normalized Histogram');
subplot(2,3,6),bar(GG_hist,0.9),xlabel('Pixel Gray Level'),ylabel('Normalized Histogram');
% 加总标题
suptitle('Histogram of colorscale image');

%-------------------------------------------------------------------------%
% rgb2ycbcr                                                               % 
%-------------------------------------------------------------------------%

% ori
YCbCr = rgb2ycbcr(ori_im);
Y = YCbCr(:,:,1);
[r,c] = size(Y);
Y_hist = CalGrayHist(r,c,Y);
Y_hist = Y_hist/(r*c);
res1 = CalZeroHeightGapBins(Y_hist);

% jpeg
Yjpg = imread(jpath);
Y_jpg = rgb2ycbcr(Yjpg);
Y_jpg = Y_jpg(:,:,1);
Yjpg_hist = CalGrayHist(r,c,Y_jpg);
Yjpg_hist = Yjpg_hist/(r*c);
res2 = CalZeroHeightGapBins(Yjpg_hist);

% r 
% V_out = AV_in^rs
% G_Y = uint8(255*(double(Y)/255).^gamma);
G_Y = round(255*((double(Y)/255).^gamma));
G_YCbCr = YCbCr;
G_YCbCr(:,:,1) = G_Y;
imwrite(G_YCbCr,'testimg/GammaY.bmp','bmp');
G_hist = CalGrayHist(r,c,G_Y);
G_hist = G_hist/(r*c);
res3 = CalZeroHeightGapBins(G_hist);

% j + r
% JY = uint8(255*(double(Y_jpg)/255).^gamma);
JY = round(255*((double(Y_jpg)/255).^gamma));
JY_jpg = YCbCr;
JY_jpg(:,:,1) = JY;
imwrite(JY,'testimg/JY.bmp','bmp');
JY_hist = CalGrayHist(r,c,JY);
JY_hist = JY_hist/(r*c);
res4 = CalZeroHeightGapBins(JY_hist);

% r + j
imwrite(ycbcr2rgb(G_YCbCr),'testimg/GJ.jpg','jpg','Quality',70);
GJ = imread('testimg/GJ.jpg');
GJ_Y = rgb2ycbcr(GJ);
GJ_Y = GJ_Y(:,:,1);
GJ_hist = CalGrayHist(r,c,GJ_Y);
GJ_hist = GJ_hist/(r*c);
res5 = CalZeroHeightGapBins(GJ_hist);

figure;
subplot(2,5,1),imshow(Y),title('The original image');
subplot(2,5,2),imshow(Y_jpg),title('JPEG (Q =50)');
subplot(2,5,3),imshow(uint8(G_Y)),title(['Gamma value =',mat2str(gamma)]);
subplot(2,5,4),imshow(uint8(JY)),title(['JPEG (Q=50) Gamma value =',mat2str(gamma)]);
subplot(2,5,5),imshow(GJ_Y),title(['Gamma value =',mat2str(gamma),' JPEG (Q=70)']);
subplot(2,5,6),bar(Y_hist,0.9),xlabel('Pixel Gray Level'),title(['zero-height gap bins:',num2str(res1),'/255']),ylabel('Normalized Histogram');
subplot(2,5,7),bar(Yjpg_hist,0.9),xlabel('Pixel Gray Level'),title(['zero-height gap bins:',num2str(res2),'/255']),ylabel('Normalized Histogram');
subplot(2,5,8),bar(G_hist,0.9),xlabel('Pixel Gray Level'),title(['zero-height gap bins:',num2str(res3),'/255']),ylabel('Normalized Histogram');
subplot(2,5,9),bar(JY_hist,0.9),xlabel('Pixel Gray Level'),title(['zero-height gap bins:',num2str(res4),'/255']),ylabel('Normalized Histogram');
subplot(2,5,10),bar(GJ_hist,0.9),xlabel('Pixel Gray Level'),title(['zero-height gap bins:',num2str(res5),'/255']),ylabel('Normalized Histogram');
suptitle('Histogram of Y(Luminance)');