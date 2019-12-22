% clear work
clc
clear
close all

% ���һ������ͼ ���ڲ�ͬ�Ĳ�ɫͼƬ
% �ھ���һ����Χ�ڵ�gammaֵ�Ĳ������ܹ�ͳ�Ƴ���zero-height gap bins�ĸ���ռ�����ı���
img_path = 'testimg/img';
% ����һ��ͼƬ ��ͬ��gammaֵ �õ���zero-height gap bins�ĸ���
ga = zeros(1,13);
num  = 1;
% 0.1 0.3 0.5 0.7 0.9 1.1 1.3 1.5 1.7 1.9 2.1 2.3 2.5
for gamma =0.1:0.2:2.5
    for im = 1:10
        ori_img = imread([img_path,num2str(im),'.png']);
        Ga = rgb2ycbcr(ori_img);
        Ga = Ga(:,:,1);
        % Ga = uint8(255*(double(Ga)/255).^gamma);
        Ga = round(255*((double(Ga)/255).^gamma));
        [r,c] = size(Ga);
        ma = max(max(Ga));
        mi = min(min(Ga));
        if ma < 0 || ma>=256 || mi<0 || mi>=256
            scale=255.0/(ma-mi);
            for i=1:r
                for j=1:c
                    % ������һ��ǿ��ת���Ĺ��� ���ܻ�Ժ�����ʵ�����Ӱ��
                    % �Ҿ��ù�һ��������û�����
                    Ga(i,j)=uint8(scale*(Ga(i,j)-mi));
                end
            end
        end
        G_hist = CalGrayHist(r,c,Ga);
        G_hist = G_hist/(r*c);
        res = CalZeroHeightGapBins(G_hist);
        ga(num) = ga(num) + res/256; 
    end
    ga(num) = ga(num) / 10
    num = num + 1;
end
plot(ga,'-o');
xlabel('Gamma parameter','FontSize',16);
ylabel('zero-height gap bins/256(%)','FontSize',16);

