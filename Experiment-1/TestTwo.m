path='images/';

%-------------------------------------------------------------------------%
% 1.Read gray scale reference image                                       %
%-------------------------------------------------------------------------%

% im=imread('lena512.bmp');
% figure,imhist(im);

%-------------------------------------------------------------------------%
% 2.Read other gray scale test images                                     %
%-------------------------------------------------------------------------%

% q=[1,10,30];
% q=[50,70,90];
% num=1;
% im=imread('lena512.bmp');
% subplot(2,4,num),imshow(im),title('原始图像');
% num=num+1;
% subplot(2,4,num),imhist(im),title('原始图像的灰度直方图');
% for i=q
%     name=[path,num2str(i),'.jpg'];
%     read=imread(name);
%     num=num+1;
%     subplot(2,4,num),imshow(read),title(['质量因子',int2str(i),'%']);
%     num=num+1;
%     subplot(2,4,num),imhist(read),title(['质量因子',int2str(i),'%的灰度直方图']);
% end

%-------------------------------------------------------------------------%
% 3.my func imhist                                                        %
%-------------------------------------------------------------------------%

% im=imread([path,'1.jpg']);
im=imread('lena512.bmp');
im=double(im);
len=512;
% 若写成zeros(1:256)会报错超出了程序允许的最大变量值。
gray=zeros(1,256);
for i=1:len
   for j=1:len 
       % 取像素值并且转为整形才能用于下标访问
       ind=uint8(im(i,j));
       % 像素值可能为0
       ind=ind+1;
       % 将对应的像素值的统计量++
       gray(ind)=gray(ind)+1;
   end
end

bar(gray);
xlabel('灰度级(8bit)','FontSize',8);
ylabel('像素个数(个)','FontSize',8);
title('灰度图像的灰度直方图');
