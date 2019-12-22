% clear work
clc
clear
close all
blocksize = 64;
% �ûҶ�ͼ��������ʵ�� ͼ���СΪ512*512
% Ҫ���ò�ɫͼ��ѡ����ɫͨ��
path1 = 'testimg\dog2.png';
im_ori1 = imread(path1);
if ndims(im_ori1) == 3
    im_CE1 = im_ori1(:,:,2); % �����RGBͨ����ȡG(��ɫ)ͨ��
else
    im_CE1 = im_ori1;
end
res1 = justtest(im_CE1,blocksize);

% ����
% im_ori = imnoise(im_ori1,'gaussian',0,0.005);

% ��ת
% im_ori = imrotate(im_ori1,180);

% ����
sca = 0.25;
im_ori = imresize(im_ori1,0.25,'nearest');

if ndims(im_ori) == 3
    im_CE = im_ori(:,:,2); % �����RGBͨ����ȡG(��ɫ)ͨ��
else
    im_CE = im_ori;
end
res2 = justtest(im_CE,blocksize);

subplot(1,4,1),imshow(im_ori1),title('original image');
subplot(1,4,2),imagesc(res1),colormap('hot'),colorbar;
subplot(1,4,3),imshow(im_ori),title(['Scale = ',num2str(sca)]);
subplot(1,4,4),imagesc(res2),colormap('hot'),colorbar;