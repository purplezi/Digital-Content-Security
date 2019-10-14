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
% subplot(2,4,num),imshow(im),title('ԭʼͼ��');
% num=num+1;
% subplot(2,4,num),imhist(im),title('ԭʼͼ��ĻҶ�ֱ��ͼ');
% for i=q
%     name=[path,num2str(i),'.jpg'];
%     read=imread(name);
%     num=num+1;
%     subplot(2,4,num),imshow(read),title(['��������',int2str(i),'%']);
%     num=num+1;
%     subplot(2,4,num),imhist(read),title(['��������',int2str(i),'%�ĻҶ�ֱ��ͼ']);
% end

%-------------------------------------------------------------------------%
% 3.my func imhist                                                        %
%-------------------------------------------------------------------------%

% im=imread([path,'1.jpg']);
im=imread('lena512.bmp');
im=double(im);
len=512;
% ��д��zeros(1:256)�ᱨ�����˳��������������ֵ��
gray=zeros(1,256);
for i=1:len
   for j=1:len 
       % ȡ����ֵ����תΪ���β��������±����
       ind=uint8(im(i,j));
       % ����ֵ����Ϊ0
       ind=ind+1;
       % ����Ӧ������ֵ��ͳ����++
       gray(ind)=gray(ind)+1;
   end
end

bar(gray);
xlabel('�Ҷȼ�(8bit)','FontSize',8);
ylabel('���ظ���(��)','FontSize',8);
title('�Ҷ�ͼ��ĻҶ�ֱ��ͼ');
