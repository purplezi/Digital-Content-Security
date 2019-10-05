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
q=[50,70,90];
num=1;
im=imread('lena512.bmp');
subplot(2,4,num),imshow(im),title('原始图像');
num=num+1;
subplot(2,4,num),imhist(im),title('原始图像的灰度直方图');
for i=q
    name=[path,num2str(i),'.jpg'];
    read=imread(name);
    num=num+1;
    subplot(2,4,num),imshow(read),title(['质量因子',int2str(i),'%']);
    num=num+1;
    subplot(2,4,num),imhist(read),title(['质量因子',int2str(i),'%的灰度直方图']);
end