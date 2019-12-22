%-------------------------------------------------------------------------%
% Test for the zero-height gap and show the peak/gap artifacts            % 
%-------------------------------------------------------------------------%

% clear work
clc
clear
close all

% read an RGB image into the workspace
path = 'testimg/img2.png';
ori_im = imread(path);

%-------------------------------------------------------------------------%
% rgb2gray                                                                % 
%-------------------------------------------------------------------------%

% Convert RGB Image to Grayscale Image
Y = ori_im(:,:,2);
figure;
subplot(1,4,1),imshow(ori_im(:,:,1)),title('red channel');
subplot(1,4,2),imshow(ori_im(:,:,2)),title('green channel');
subplot(1,4,3),imshow(ori_im(:,:,3)),title('blue channel');
subplot(1,4,4),imshow(ori_im),title('ori');
[r,c] = size(Y);
G_hist = zeros(1,256);
for i = 1:r
    for j = 1:c
        ind = Y(i,j) + 1;
        G_hist(ind) = G_hist(ind) + 1;
    end
end
G_hist=G_hist/(r*c);

% After Jpeg compression Q=50
imwrite(ori_im,'testimg/test.jpg','jpg','Quality',50);
jpath = 'testimg/test.jpg';
jpg_im = imread(jpath);
jpg_G = jpg_im(:,:,2);
jpgG_hist = zeros(1,256);
for i = 1:r
    for j = 1:c
        ind = jpg_G(i,j) + 1;
        jpgG_hist(ind) = jpgG_hist(ind) + 1;
    end
end
jpgG_hist=jpgG_hist/(r*c);

% Gamma�任�� y=x^gamma;
% gamma>1, ����������Ҷȱ����죬�ϰ�������Ҷȱ�ѹ���ĸ�����ͼ������䰵��
% gamma<1, ����������Ҷȱ�ѹ�����ϰ�������Ҷȱ�����Ľ�����ͼ�����������
% ����enhancement r=1.2 GammaֵΪ1.2

gamma = 2.2;
Gamma = imadjust(ori_im,[],[],gamma);
imwrite(Gamma,'testimg/Gamma.bmp','bmp');
Ga = imread('testimg/Gamma.bmp');
Gamma_G = Ga(:,:,2);
GG_hist = zeros(1,256);
for i = 1:r
    for j = 1:c
        ind = Gamma_G(i,j) + 1;
        GG_hist(ind) = GG_hist(ind) + 1;
    end
end
sum(sum(GG_hist==0))
GG_hist=GG_hist/(r*c);

% ��ԭͼ + ����q=50��ͼ�� + enhancement r
figure;
subplot(2,3,1),imshow(ori_im),title('The original image');
subplot(2,3,2),imshow(jpg_im),title('JPEG (Q =50)');
subplot(2,3,3),imshow(Gamma),title(['enhanced (Gamma value =',mat2str(gamma), ')']);
subplot(2,3,4),bar(G_hist,0.9),xlabel('Pixel Gray Level'),ylabel('Normalized Histogram');
subplot(2,3,5),bar(jpgG_hist,0.9),xlabel('Pixel Gray Level'),ylabel('Normalized Histogram');
subplot(2,3,6),bar(GG_hist,0.9),xlabel('Pixel Gray Level'),ylabel('Normalized Histogram');
% ���ܱ���
suptitle('Histogram of colorscale image in green channel');

%-------------------------------------------------------------------------%
% �۲첻�����Ե�peak/gap artifacts                                         % 
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% Test Two: Sum for the zero-height gaps bins                             % 
%-------------------------------------------------------------------------%

% ͳ��zero-height gap bins������
Ga = imread('testimg/Gamma.bmp');
Ga = Ga(:,:,2);
[r,c] = size(Ga);

%-------------------------------------------------------------------------%
% Normalized histogram                                                    %
%-------------------------------------------------------------------------%

ma = max(max(Ga))
mi = min(min(Ga))
if ma < 0 || ma>=256 || mi<0 || mi>=256
    scale=255.0/(ma-mi);
    for i=1:r
        for j=1:c
            % ������һ��ǿ��ת���Ĺ��� ���ܻ�Ժ�����ʵ�����Ӱ��
            % �Ҿ��ù�һ��������û�����
            Ga(i,j)=uint8(scale*(Ga(i,j)-mi));
        end
    end
end
gh = zeros(1,256);
for i = 1:r
    for j = 1:c
        ind = Ga(i,j) + 1;
        gh(ind) = gh(ind) + 1;
    end
end
gh = gh/(r*c);

%-------------------------------------------------------------------------%
% Detect the bin at k as a zero-height gap bin                            %
%-------------------------------------------------------------------------%

% �������е�Ԫ��
w = 3;
threshold = 0.001;
res = 0;
for i = 1:256
    flg = 0;
    % ��������ֵ����Ϊ0
    if gh(i) == 0
        flg = flg + 1;
    end
    % ����ǰ������ֵ��������Сֵ����һ����ֵ
    if i-1>=1 && i+1<=256 && min(gh(i-1),gh(i+1)) > threshold
        flg = flg + 1;
    end
    % ��������[i-w,i+w]��������ֵ�ʹ�����ֵ
    if i-w >=1 && i+w<=256
        cnt = 0;
        for j=i-w:i+w
            cnt = cnt + gh(j);
        end
        jud = cnt/(2*w+1)
        if  jud > threshold
            flg = flg + 1;
        end
    end
    if flg == 3
        res = res + 1;
    end
end
res
