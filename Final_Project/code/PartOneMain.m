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
% Get the image’s normalized gray level histogram                        %
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
            % 这里有一步强制转换的过程 可能会对后续的实验造成影响
            % 我觉得归一化不可能没有误差
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

% 遍历所有的元素
w = 3;
threshold = 0.001;
res = 0;
for i = 1:256
    flg = 0;
    % 满足像素值个数为0
    if gh(i) == 0
        flg = flg + 1;
    end
    flg
    % 满足前后像素值个数的最小值大于一个阈值
    if i-1>=1 && i+1<=256 && min(gh(i-1),gh(i+1)) > threshold
        flg = flg + 1;
    end
    flg
    % 满足区间[i-w,i+w]的像素总值和大于阈值
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
fprintf('谷单元的个数为：%d\n',res);


% 问题
% 1.vector和matrix的区别
% 2.rgb2ntsc得到的值不是0-255之间，所以得到的到底是不是灰度值
% 3.rgb2gray到底哪里不好 rgb2gray得到的值可能不是在[0,255]之间
% 4.rgb2ntsc rgb2ycbcr
% 5.对比度增强 是高频系数变多？
