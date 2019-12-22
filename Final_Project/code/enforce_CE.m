function [rand_map,img] = enforce_CE(im,blocksize)
%% ����һ��ͼ ѡ�����ж���gammaУ���ĵ�
% % �ûҶ�ͼ��������ʵ��
% % ǿ��ת��Ϊdouble����
% im = double(im);
% % �Ƚ�����ͼƬ����gammaУ�� = round(255(x/255)^r),
% gamma1 = 2.2;
% img = double(uint8(255*(im/255).^gamma1));
% % figure;imshow(uint8(imf));
% % �ڶ���ط�ѡ�� gamma=0.7 ���� 
% % ������Ӳ����ѡ�����Ͻǵ�һ�飬���Խ��
% gamma2 = 2.5;
% img(blocksize+1:2*blocksize,blocksize+1:2*blocksize) = double(uint8(255*(img(blocksize+1:2*blocksize,blocksize+1:2*blocksize)/255).^gamma2));
% imwrite(uint8(img),'testimg\gray1_gamma1.bmp','bmp');
% figure;imshow(uint8(img));

%% ���ѡ��� ����gammaУ��
s = rng;
[r,c] = size(im);
gamma1 = 0.2;
im = double(im);
img = double(uint8(255*(im/255).^gamma1));
Nbr = fix(r/blocksize);
Nbc = fix(c/blocksize);
rand_map = round(rand(Nbr,Nbc));
gamma2 = 2.2;
for i = 1:Nbr
    for j =1:Nbc
        if rand_map(i,j) == 1
            img((i-1)*blocksize+1:i*blocksize,(j-1)*blocksize+1:j*blocksize) = double(uint8(255*(img(blocksize+1:2*blocksize,blocksize+1:2*blocksize)/255).^gamma2));
        end
    end
end
%figure,imshow(uint8(img));
