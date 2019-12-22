% ����Ϊ1x256�Ĺ�һ���Ҷ�ֱ��ͼ���� ����ֵΪzero-height gap bins�ĸ���
function [res] = CalZeroHeightGapBins(gh)
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
    % ����ǰ������ֵ��������Сֵ����һ����ֵ
    if i-1>=1 && i+1<=256 && min(gh(i-1),gh(i+1)) > threshold
        flg = flg + 1;
    end
    % ��������[i-w,i+w]��������ֵ�ʹ�����ֵ
    if i-w >=1 && i+w<=256
        cnt = 0;
        for j=i-w:i+w
            cnt = cnt + gh(j);
        end
        jud = cnt/(2*w+1);
        if  jud > threshold
            flg = flg + 1;
        end
    end
    if flg == 3
        res = res + 1;
    end
end
end

