%---------------------------------------------------------------------------------------------%
% Test One: Test for the zero-height gaps and show the peak/gap artifacts in grayscale images %
%---------------------------------------------------------------------------------------------%

% clear work
clc
clear
close all

% Part one: read an grayscale image into the workspace
path = 'testimg/gray3.bmp';
gray = imread(path);
[r,c] = size(gray);
G_hist = CalGrayHist(r,c,gray);
G_hist=G_hist/(r*c);
res1 = CalZeroHeightGapBins(G_hist)

% Part two:after Jpeg compression Q=50
imwrite(gray,'testimg/test.jpg','jpg','Quality',50);
jpath = 'testimg/test.jpg';
jpg_G = imread(jpath);
jpgG_hist = CalGrayHist(r,c,jpg_G);
jpgG_hist=jpgG_hist/(r*c);
res2 = CalZeroHeightGapBins(jpgG_hist)

% Part three: Gamma Correction 

% Gamma�任�� y=x^gamma;
% gamma>1, ����������Ҷȱ����죬�ϰ�������Ҷȱ�ѹ���ĸ�����ͼ������䰵���Ҷ�ֵС�ĸ�������
% gamma<1, ����������Ҷȱ�ѹ�����ϰ�������Ҷȱ�����Ľ�����ͼ������������Ҷ�ֵ��ĸ�������
% ��ɫΪ255 ��ɫΪ0 
% ����enhancement r=1.2 GammaֵΪ1.2

gamma = 2.2;
Gamma = imadjust(gray,[],[],gamma);
imwrite(Gamma,'testimg/Gamma.bmp','bmp');
% Gamma_G = imread('testimg/Gamma.bmp');
Gamma_G = Gamma;
GG_hist = CalGrayHist(r,c,Gamma_G);
GG_hist=GG_hist/(r*c);
res3 = CalZeroHeightGapBins(GG_hist);

Gamma_Jpeg = imadjust(jpg_G,[],[],gamma);
imwrite(Gamma_Jpeg,'testimg/Gamma_Jpeg.bmp','bmp');
Gamma_JpegG = Gamma_Jpeg;
JG_hist = CalGrayHist(r,c,Gamma_JpegG);
JG_hist=JG_hist/(r*c);
res4 = CalZeroHeightGapBins(JG_hist);

gamma1 = 1.2;
Gamma1 = imadjust(gray,[],[],gamma1);
imwrite(Gamma1,'testimg/Gamma1.bmp','bmp');
Gamma_G1 = Gamma1;
GG_hist1 = CalGrayHist(r,c,Gamma_G1);
GG_hist1=GG_hist1/(r*c);
res5 = CalZeroHeightGapBins(GG_hist1);

Gamma_Jpeg1 = imadjust(jpg_G,[],[],gamma1);
imwrite(Gamma_Jpeg1,'testimg/Gamma_Jpeg.bmp','bmp');
Gamma_JpegG1 = Gamma_Jpeg1;
JG_hist1 = CalGrayHist(r,c,Gamma_JpegG1);
JG_hist1=JG_hist1/(r*c);
res6 = CalZeroHeightGapBins(JG_hist1);

% (1) ori (2) q=50 (3) r1 (4) q+r1 (5) r2 (6) q+r2
figure;
subplot(3,4,1),imshow(gray),title('The original image');
subplot(3,4,3),imshow(jpg_G),title('JPEG (Q =50)');
subplot(3,4,5),imshow(Gamma_G),title(['Gamma value =',mat2str(gamma)]);
subplot(3,4,7),imshow(Gamma_Jpeg),title(['JPEG (Q=50) Gamma value =',mat2str(gamma)]);
subplot(3,4,9),imshow(Gamma_G1),title(['Gamma value =',mat2str(gamma1)]);
subplot(3,4,11),imshow(Gamma_Jpeg1),title(['JPEG (Q=50) Gamma value =',mat2str(gamma1)]);
subplot(3,4,2),bar(G_hist,0.9),xlabel('Pixel Gray Level'),title(['zero-height gap bins:',num2str(res1),'/256']),ylabel('Normalized Histogram');
subplot(3,4,4),bar(jpgG_hist,0.9),xlabel('Pixel Gray Level'),title(['zero-height gap bins:',num2str(res2),'/256']),ylabel('Normalized Histogram');
subplot(3,4,6),bar(GG_hist,0.9),xlabel('Pixel Gray Level'),title(['zero-height gap bins:',num2str(res3),'/256']),ylabel('Normalized Histogram');
subplot(3,4,8),bar(JG_hist,0.9),xlabel('Pixel Gray Level'),title(['zero-height gap bins:',num2str(res4),'/256']),ylabel('Normalized Histogram');
subplot(3,4,10),bar(GG_hist1,0.9),xlabel('Pixel Gray Level'),title(['zero-height gap bins:',num2str(res5),'/256']),ylabel('Normalized Histogram');
subplot(3,4,12),bar(JG_hist1,0.9),xlabel('Pixel Gray Level'),title(['zero-height gap bins:',num2str(res6),'/256']),ylabel('Normalized Histogram');
% ���ܱ���
suptitle('Histogram of grayscale image');

%-------------------------------------------------------------------------%
% Attack Test                                                             %
%-------------------------------------------------------------------------%

% �Ծ���CE��ͼ�����jpg���� �Ⱦ���2.2��CE �󾭹�Q=50��ѹ��
imwrite(Gamma,'testimg/Gamma.jpg','jpg','Quality',50);
GJ = imread('testimg/Gamma.jpg');
GJ_hist = CalGrayHist(r,c,GJ);
GJ_hist = GJ_hist/(r*c);
res1 = CalZeroHeightGapBins(GJ_hist)

% ��CEͼ����м��봦��
imNois1 = imnoise(Gamma,'gaussian',0,0.005);
imN_hist = CalGrayHist(r,c,imNois1);
imN_hist = imN_hist/(r*c);
res2 = CalZeroHeightGapBins(imN_hist);

% ��CEͼ�������ת����
imrot = imrotate(Gamma,90);
imrot_hist = CalGrayHist(r,c,imrot);
imrot_hist = imrot_hist/(r*c);
res3 = CalZeroHeightGapBins(imrot_hist);

% ��CEͼ����вü�����
sca = 0.25;
imresiz = imresize(Gamma,0.25,'nearest');
[r,c] = size(imresiz);
imresiz_hist = CalGrayHist(r,c,imresiz);
imresiz_hist = imresiz_hist/(r*c);
res4 = CalZeroHeightGapBins(imresiz_hist);

figure;
subplot(2,4,1),imshow(GJ),title('Gamma value = 2.2 JPEG (Q = 50)');
subplot(2,4,3),imshow(imNois1),title('Gamma value = 2.2 Gaussian mean = 0 variance = 0.005');
subplot(2,4,5),imshow(imrot),title('Gamma value = 2.2 Rotate = 90');
subplot(2,4,7),imshow(imresiz),title(['Gamma value = 2.2 Scale = ',num2str(sca)]);
subplot(2,4,2),bar(GJ_hist,0.9),xlabel('Pixel Gray Level'),title(['zero-height gap bins:',num2str(res1),'/256']),ylabel('Normalized Histogram');
subplot(2,4,4),bar(imN_hist,0.9),xlabel('Pixel Gray Level'),title(['zero-height gap bins:',num2str(res2),'/256']),ylabel('Normalized Histogram');
subplot(2,4,6),bar(imrot_hist,0.9),xlabel('Pixel Gray Level'),title(['zero-height gap bins:',num2str(res3),'/256']),ylabel('Normalized Histogram');
subplot(2,4,8),bar(imresiz_hist,0.9),xlabel('Pixel Gray Level'),title(['zero-height gap bins:',num2str(res4),'/256']),ylabel('Normalized Histogram');
% ���ܱ���
suptitle('histogram of enforced CE grayscale image after attack');


% %-------------------------------------------------------------------------%
% % Normalized histogram                                                    %
% %-------------------------------------------------------------------------%
% % ͳ��zero-height gap bins������
% Ga = imread('testimg/gray1.bmp');
% [r,c] = size(Ga);
% gh = zeros(1,256);
% for i = 1:r
%     for j = 1:c
%         ind = Ga(i,j) + 1;
%         gh(ind) = gh(ind) + 1;
%     end
% end
% gh = gh/(r*c);
% ma = max(max(Ga))
% mi = min(min(Ga))
% if ma < 0 || ma>=256 || mi<0 || mi>=256
%     scale=255.0/(ma-mi);
%     for i=1:r
%         for j=1:c
%             % ������һ��ǿ��ת���Ĺ��� ���ܻ�Ժ�����ʵ�����Ӱ��
%             % �Ҿ��ù�һ��������û�����
%             Ga(i,j)=uint8(scale*(Ga(i,j)-mi));
%         end
%     end
% end
