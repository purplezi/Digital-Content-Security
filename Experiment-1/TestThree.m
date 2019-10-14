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
% % 不将blocksize增大
% % 取第20个8*8的块，前为行，后为列
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
% 在块20有误差的做法，先取整在移位
% rblock=uint8(rblock);
% 128-shift
% rblock=rblock+128;
% 在块20无误差的做法，先移位再取整
% rblock=uint8(rblock+128)

%-------------------------------------------------------------------------%
% 4.compare                                                               %
%-------------------------------------------------------------------------%

% img=imread(impath);
% 20th-8*8的块
% (1:8,153:160)
% img=img(1:8,153:160);
% subplot(1,2,1),imshow(img),title('原始图像');
% subplot(1,2,2),imshow(rblock),title('反变换的图像');

%-------------------------------------------------------------------------%
% 5.append the blocksize to see the block affect of the JPEG compression  %
%-------------------------------------------------------------------------%

impath='lena512.jpg';
% 选取images中质量因子不同的图片
% impath=[path,'90.jpg'];
im=jpeg_read(impath);
DCT=im.coef_arrays{1};

% % append blocksize 
% % 将blocksize增大，取为64*64
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
% %一起进行idct2会出错，因为压缩的时候是针对8*8小块进行dct变换
% %若直接对blocksize不为8的块进行idct，则会将idct范围扩大，算出来的值就不对了
% %所以要对大块进行分块idct，而不能对一大块进行idct
% rblock=idct2(qblock);
% 128-shift
rblock=uint8(rblock+128);

img=imread(impath);
img=img(1:bs,1:bs);
subplot(1,2,1),imshow(img),title('原始图像');
subplot(1,2,2),imshow(rblock),title('反变换的图像');
