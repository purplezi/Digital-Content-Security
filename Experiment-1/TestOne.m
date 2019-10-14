path='images/';

%-------------------------------------------------------------------------%
% 1.Read gray scale                                                       %
%-------------------------------------------------------------------------%

% %imread����ֵ����Ϊuint8
% im=imread('lena512.bmp');
% %show original image
% %figure('name','Original image'), imshow(im);

%-------------------------------------------------------------------------%
% 2.Read color scale                                                      %
%-------------------------------------------------------------------------%

% %convert the image to YIQ color space
% y=rgb2ntsc(im);

% %get the NTSC luminance value
% %represented by the first color channel in the YIQ image.
% y=y(:,:,1);
% %figure('name','Grayscale image'), imshow(y);

%-------------------------------------------------------------------------%
% 3.Quality change from 0-100                                             %
%-------------------------------------------------------------------------%

% get the images when Quality change between 0-100 
% for i=0:100
%     % ���ļ�����������ͬĿ¼���Լ����ɵ�images�ļ�����
%     savename=[num2str(i),'.jpg'];
%     savename=[path,savename];
%     % imwrite����ʵ��JPEGѹ����ָ����������
%     imwrite(im,savename,'jpg','Quality',i);
% end

%-------------------------------------------------------------------------%
% 4.Quality Contrast                                                      %
%-------------------------------------------------------------------------%

% contrast�������ӵĶԱ�ͼ
q=[1, 5, 10, 15, 30, 50, 70, 90];
num=1;
for i=q
    imwrite(im,'test.jpg','jpg','Quality',i);
    subplot(2,4,num),imshow(imread('test.jpg')),title(['��������',int2str(i),'%']);
    num=num+1;
end

%-------------------------------------------------------------------------%
% 5.Plot PSNR~Q use Function PSNR                                         %
%-------------------------------------------------------------------------%

% get each images' PSNR
% do not change uint8 to double
% im=imread('lena512.bmp');
% ans=zeros(1,101);
% ans=double(ans);
% for i=0:100
%     readname=[path,num2str(i)];
%     readname=[readname,'.jpg'];
%     read=imread(readname);
%     % imshow(read);
%     [peaksnr,snr]=psnr(read,i);
%     ans(i+1)=peaksnr;
% end

%-------------------------------------------------------------------------%
% 6.Plot PSNR~Q not calling the function                                  %
%-------------------------------------------------------------------------%

% im=imread('lena512.bmp');
% [h w]=size(im); 
% im=double(im);
% ans=zeros(1,101);
% ans=double(ans);
% % λ���
% bit=8;
% % ��ǰͼ����������ֵ
% fmax=2.^bit-1;
% MAX=fmax.^2;
% for i=0:100
%     readname=[path,num2str(i)];
%     readname=[readname,'.jpg'];
%     read=imread(readname);
%     read=double(read);
%     % �������ֱ�����
%     MES=sum(sum((im-read).^2))/(h*w);
%     ans(i+1)=10*log10(MAX/MES);
% end 

%-------------------------------------------------------------------------%
% 6.Plot                                                                  %
%-------------------------------------------------------------------------%

% �����߿�
% LineWidth_Plot=plot(ans);
% set(LineWidth_Plot,'LineWidth',2);
% ���ú����������Լ������С
% xlabel('��������Q','FontSize',16);
% ylabel('��ֵ�����PSNR(dB)','FontSize',16);
% title('PSNR~Q����');


