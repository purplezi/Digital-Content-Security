%-------------------------------------------------------------------------%
% This is the test for identify Sourced-Enhanced Composite Images         %
%-------------------------------------------------------------------------%

% clear work
clc
clear
close all

% ���ȴ���һ��ͼƬ ��һ����ĶԱȶ���gamma r1��ǿ����һ����ĶԱȶ���gamma r2��ǿ ��gammaoperation.m�ļ�
blocksize = 64; % 10x10=100
% �ûҶ�ͼ��������ʵ��
% Ҫ���ò�ɫͼ��û�����ʲôͨ����Ӧ����ʲôͨ�������� ��ֻ��Ҫ�Ҵ���r1��r2��ʱ����ͬһ��ͨ���ϴ������
path = 'testimg\gray1_gamma.bmp';

% path = 'testimg\gray1.bmp'; % gapЧӦ������
im = imread(path);
[r,c] = size(im);

%-------------------------------------------------------------------------%
% Step 1: Compute blockwise histogram                                     %
%-------------------------------------------------------------------------%

% �ȿ�����������ȥ����
% the number of divided blocks
Nb = r*c/(blocksize*blocksize);
Nbr = r/blocksize;
Nbc = c/blocksize;

%-------------------------------------------------------------------------%
% Step 2: Blockwise Peak/Gap Bins Location                                %
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% A.Locate gap bins  

% �Ҷ�ֵ0-255 ��Ϊ�Ҷ�ֵ1-256
% Vg�Ǳ�ʾÿһ���ÿ���Ҷ�ֵ�Ƿ���gap bin
Vg = zeros(Nb,256);
blockhist = zeros(Nb,256);
ind = 1;
for i = 1:Nbr
    for j = 1:Nbc
        for h = 1+(i-1)*blocksize:i*blocksize
            for k = 1+(j-1)*blocksize:j*blocksize
                num = im(h,k)+1;
                blockhist(ind,num) = blockhist(ind,num) + 1;
            end 
        end
        Vg(ind,:)=detectgapbins(blockhist(ind,:));
        ind = ind + 1;
    end
end

% �ж�Vg���Ƿ�ȫΪ0
% any(Vg)

%-------------------------------------------------------------------------%
% B.Correct gap bins У���Ĵ���ɸ���

% У�����ֵӦ��ȡ���� ä��0.01
gc_threshold = 0.01;
Vgc = correctbins(Vg,Nb,gc_threshold);

%-------------------------------------------------------------------------%
% C.Locate peak bins  

% % ���
% % ����������bins�ľ�ֵ
% width = 1;
% gapfilled = GetGapfilledhistogram(Vg,blockhist,Nb,width);
% % ��ֵ�˲� ����Ϊ5x5 ��һ��3x3�ľ�ֵ�˲� ��δʵ��
% wndsize = 5; % 5
% aversize = 3;
% filtered = GetFilteredHistogram(gapfilled,Nb,wndsize,aversize);
% % ��ֵ�����
% % Vp�Ǳ�ʾÿһ���ÿ���Ҷ�ֵ�Ƿ���peak bin
% dis = filtered - gapfilled;
% di = sum(abs(dis));
% tot = sum(abs(dis(:)));
% figure,bar(di/tot),title('ͼ���һ��Ĳ�ֵ�Ҷ�ֱ��ͼ');

res = zeros(Nb,256);
edr = zeros(Nb);
for i = 1:Nb
[res(i,:),e] = peakBin_detect(blockhist(1,:));
edr(i)= e;
end





