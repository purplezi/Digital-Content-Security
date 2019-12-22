%-------------------------------------------------------------------------%
% This is the test for generate Sourced-Enhanced Composite Images         %
%-------------------------------------------------------------------------%
clc
clear
close all
blocksize = 128; % 100x100=10000
% �ûҶ�ͼ��������ʵ��
path = 'testimg\gray2.bmp';
% ǿ��ת��Ϊdouble����
im = double(imread(path));
% �Ƚ�����ͼƬ����gammaУ�� = round(255(x/255)^r),
gamma1 = 2.0;
imf = double(uint8(255*(im/255).^gamma1));
figure;imshow(uint8(imf));
imwrite(uint8(imf),'testimg\gray2_single.bmp','bmp');
% �ڶ���ط�ѡ�� gamma r1=0.7 ���� 
% ������Ӳ����ѡ�����Ͻǵ�һ��
gamma2 = 0.2;
imf(blocksize+1:2*blocksize,blocksize+1:2*blocksize) = double(uint8(255*(imf(blocksize+1:2*blocksize,blocksize+1:2*blocksize)/255).^gamma2));
% figure;imshow(uint8(imf));
imwrite(uint8(imf),'testimg\gray2_both.bmp','bmp');