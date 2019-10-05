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
subplot(2,4,num),imshow(im),title('ԭʼͼ��');
num=num+1;
subplot(2,4,num),imhist(im),title('ԭʼͼ��ĻҶ�ֱ��ͼ');
for i=q
    name=[path,num2str(i),'.jpg'];
    read=imread(name);
    num=num+1;
    subplot(2,4,num),imshow(read),title(['��������',int2str(i),'%']);
    num=num+1;
    subplot(2,4,num),imhist(read),title(['��������',int2str(i),'%�ĻҶ�ֱ��ͼ']);
end