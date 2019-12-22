%-------------------------------------------------------------------------%
% Contrast enhancement-based forensics in digital images                  %
%-------------------------------------------------------------------------%


% clear work
clc
clear
close all
path = 'testimg/';
% read an RGB image into the workspace
ori_im = imread([path,'gray1.bmp']);

%-------------------------------------------------------------------------%
% Get the image��s normalized gray level histogram                        %
%-------------------------------------------------------------------------%

% Convert RGB Image to Grayscale Image
if ndims(ori_im) == 3
    % Convert RGB Image to Grayscale Image
    % gray = rgb2gray(ori_im);
    gray = ori_im(:,:,2);
else
    gray = ori_im;
end
[r,c] = size(gray);

% Normalized histogram 
ma = max(max(gray))
mi = min(min(gray))
if ma < 0 || ma>=256 || mi<0 || mi>=256
    scale=255.0/(ma-mi);
    for i=1:r
        for j=1:c
            % ������һ��ǿ��ת���Ĺ��� ���ܻ�Ժ�����ʵ�����Ӱ��
            % �Ҿ��ù�һ��������û�����
            gray(i,j)=uint8(scale*(gray(i,j)-mi));
        end
    end
end

% 
gh = zeros(1,256);
for i = 1:r
    for j = 1:c
        ind = gray(i,j) + 1;
        gh(ind) = gh(ind) + 1;
    end
end
gh = gh/(r*c);
figure,bar(gh,0.9);

%-------------------------------------------------------------------------%
% Detect the bin at k as a zero-height gap bin                            %
%-------------------------------------------------------------------------%

% �������е�Ԫ��
w = 3;
threshold = 0.001;
res = 0;
for i = 1:256
    flg = 0;
    % ��������ֵ����Ϊ0
    if gh(i) == 0
        flg = flg + 1;
    end
    flg
    % ����ǰ������ֵ��������Сֵ����һ����ֵ
    if i-1>=1 && i+1<=256 && min(gh(i-1),gh(i+1)) > threshold
        flg = flg + 1;
    end
    flg
    % ��������[i-w,i+w]��������ֵ�ʹ�����ֵ
    if i-w >=1 && i+w<=256
        cnt = 0;
        for j=i-w:i+w
            cnt = cnt + gh(j);
        end
        jud = cnt/(2*w+1)
        if  jud > threshold
            flg = flg + 1;
        end
    end
    flg
    if flg == 3
        res = res + 1;
    end
end
fprintf('�ȵ�Ԫ�ĸ���Ϊ��%d\n',res);


% ����
% 1.vector��matrix������
% 2.rgb2ntsc�õ���ֵ����0-255֮�䣬���Եõ��ĵ����ǲ��ǻҶ�ֵ
% 3.rgb2gray�������ﲻ�� rgb2gray�õ���ֵ���ܲ�����[0,255]֮��
% 4.rgb2ntsc rgb2ycbcr
% 5.�Աȶ���ǿ �Ǹ�Ƶϵ����ࣿ
