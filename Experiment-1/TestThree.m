path='images\';
%-------------------------------------------------------------------------%
% 1.jpeg_read read a JPEG image structure                                 %
%-------------------------------------------------------------------------%

% impath='lena512.jpg';
% % a JPEG image structure
% im=jpeg_read(impath);
% % DCT plane
% DCT=im.coef_arrays{1};
% % figure;plot(DCT);

%-------------------------------------------------------------------------%
% 2.find the 20th 8*8 block                                               %
%-------------------------------------------------------------------------%

% % not append blocksize
% % ����blocksize����
% % ȡ��20��8*8�Ŀ飬ǰΪ�У���Ϊ��
% % 160=20*8;
% % 153=19*8+1;
% block=DCT(1:8,153:160);
% % figure;plot(block);

%-------------------------------------------------------------------------%
% 3.reverse quantization and idct                                         %
%-------------------------------------------------------------------------%

% get the quantization table
% qtable=im.quant_tables{1};

% not append quantization
% qblock=block.*qtable
% rblock=idct2(qblock)
% �ڿ�20��������������ȡ������λ
% rblock=uint8(rblock);
% 128-shift
% rblock=rblock+128;
% �ڿ�20����������������λ��ȡ��
% rblock=uint8(rblock+128)

%-------------------------------------------------------------------------%
% 4.compare                                                               %
%-------------------------------------------------------------------------%

% img=imread(impath);
% 20th-8*8�Ŀ�
% (1:8,153:160)
% img=img(1:8,153:160);
% subplot(1,2,1),imshow(img),title('ԭʼͼ��');
% subplot(1,2,2),imshow(rblock),title('���任��ͼ��');

%-------------------------------------------------------------------------%
% 5.append the blocksize to see the block affect of the JPEG compression  %
%-------------------------------------------------------------------------%

impath='lena512.jpg';
% ѡȡimages���������Ӳ�ͬ��ͼƬ
% impath=[path,'90.jpg'];
im=jpeg_read(impath);
DCT=im.coef_arrays{1};

% % append blocksize 
% % ��blocksize����ȡΪ64*64
bs=64;
len=bs/8;
block=DCT(1:bs,1:bs);
qtable=im.quant_tables{1};
rblock=zeros(bs);
qb=zeros(8);
for i=1:len
    for j=1:len
        qb=(block((i-1)*8+1:i*8,(j-1)*8+1:j*8)).*qtable;
        rblock((i-1)*8+1:i*8,(j-1)*8+1:j*8)=idct2(qb);
    end
end
% %һ�����idct2�������Ϊѹ����ʱ�������8*8С�����dct�任
% %��ֱ�Ӷ�blocksize��Ϊ8�Ŀ����idct����Ὣidct��Χ�����������ֵ�Ͳ�����
% %����Ҫ�Դ����зֿ�idct�������ܶ�һ������idct
% rblock=idct2(qblock);
% 128-shift
rblock=uint8(rblock+128);

img=imread(impath);
img=img(1:bs,1:bs);
subplot(1,2,1),imshow(img),title('ԭʼͼ��');
subplot(1,2,2),imshow(rblock),title('���任��ͼ��');
