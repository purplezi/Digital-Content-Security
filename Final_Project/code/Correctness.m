% ��ȷ�ʵļ��
% clear work
clc
clear
close all
blocksize = 64; % 32 48 64 80 96 % 200 100 50 25
% �ûҶ�ͼ��������ʵ�� ͼ���СΪ512*512
% Ҫ���ò�ɫͼ��û�����ʲôͨ����Ӧ����ʲôͨ�������� ��ֻ��Ҫ�Ҵ���r1��r2��ʱ����ͬһ��ͨ���ϴ������
% ��10��ͼ��ÿ������20������ͼƬ 
threshold = 0.01;
correct = zeros(1,10);
maxnum = 100;
path = 'testimg\img';
for p = 1:10
    impath = [path,num2str(p),'.png'];
    im_ori = imread(impath);
    if ndims(im_ori) == 3
        im = im_ori(:,:,2); % �����RGBͨ����ȡG(��ɫ)ͨ��
    else
        im = im_ori;
    end
    [r,c] = size(im);
    Nb = fix(r/blocksize)*fix(c/blocksize);
    cnt = 0;
    for i = 1:maxnum
        % ��������ľ���
        [ideal_map,img] = enforce_CE(im,blocksize);
        % �������Բ����ľ���
        res = justtest(img,blocksize);
        res(find(isnan(res)==1)) = 0;
        res1 = (res>threshold);
        %figure,imagesc(res),colormap('hot'),colorbar;
        ans1 = (res1==ideal_map);
        cnt = cnt + sum((sum(ans1)))/Nb;
    end
    correct(p) = (cnt/maxnum)*100;
end
plot(correct,'-o'),xlabel('10 images'),ylabel('Correctness(%)'),title('��10��ͼƬ�������100��ͼƬ�����������');