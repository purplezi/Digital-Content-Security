%-------------------------------------------------------------------------%
% 1.jpeg_read read a JPEG image structure                                 %
%-------------------------------------------------------------------------%

impath='lena512.jpg';
% a JPEG image structure
im=jpeg_read(impath);
% DCT plane
DCT=im.coef_arrays{1};
% figure;plot(DCT);

%-------------------------------------------------------------------------%
% 2.find the 20th 8*8 block                                               %
%-------------------------------------------------------------------------%

% 160=20*8;
% 153=19*8+1;
block=DCT(1:64,1:64);
% figure;plot(block);

%-------------------------------------------------------------------------%
% 3.reverse quantization and idct                                         %
%-------------------------------------------------------------------------%

% get the quantization table
qtable=im.quant_tables{1};
% reverse quantization
% 扩大矩阵
qt=zeros(64,64);
for i=1:8
    for j=1:8
        qt((i-1)*8+1:i*8,(j-1)*8+1:j*8)=qtable;
    end
end
rblock=block*qt;
% idct
rblock=idct(rblock);
rblock=int(rblock);
rblock=rblock+128;

%-------------------------------------------------------------------------%
% 4.compare                                                               %
%-------------------------------------------------------------------------%
im=imread(impath);
im=im(1:64,1:64);
subplot(1,2,1),imshow(im),title('原始图像');
subplot(1,2,2),imshow(rblock),title('反变换的图像');

