%-----------------------------------------------------------------------------------------------%
% This is the test for the affect of the blocksize in Sourced-Enhanced Composite Images         %
%-----------------------------------------------------------------------------------------------%

% clear work
clc
clear
close all
% 32 40 48 56 64 72 80 88
bz = [32 40 48 56];
% �ûҶ�ͼ��������ʵ�� ͼ���СΪ512*512
% Ҫ���ò�ɫͼ��ѡ����ɫͨ��
path = 'testimg\dog2.png';
im_ori = imread(path);
if ndims(im_ori) == 3
    im_CE = im_ori(:,:,2); % �����RGBͨ����ȡG(��ɫ)ͨ��
else
    im_CE = im_ori;
end

figure;
subplot(1,5,1),imshow(im_ori),title('original image');
for index = 1:length(bz)
    blocksize = bz(index);    
    res = justtest(im_CE,blocksize);
    subplot(1,5,index+1),imagesc(res),colormap('hot'),colorbar,title(['blocksize = ',num2str(blocksize),'δ������ֵ��']);
%     subplot(1,5,index+1),imagesc(patt_map_end5'),colormap('hot'),colorbar,title(['blocksize = ',num2str(blocksize),'������ֵ��']);
end
