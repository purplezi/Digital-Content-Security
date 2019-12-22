function [res] = justtest(im_CE,blocksize)
binCenters = 0:1:255;
%-------------------------------------------------------------------------%
% Step 1: Compute blockwise histogram �����ֱ��ͼ                         %
%-------------------------------------------------------------------------%

% �ȿ��ǳ�����������ȥ����
% the number of divided blocks
[r,c] = size(im_CE);
Nbr = fix(r/blocksize);
Nbc = fix(c/blocksize);
Nb = Nbr*Nbc;

%-------------------------------------------------------------------------%
% Step 2: Blockwise Peak/Gap Bins Location �����ķ��λ��                %
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% A.Locate gap bins  

% �Ҷ�ֵ0-255 ��Ϊ�Ҷ�ֵ1-256
% Vg�Ǳ�ʾÿһ���ÿ���Ҷ�ֵ�Ƿ���gap bin
Vg = zeros(Nb,256);
blockhist = zeros(Nb,256);
ind = 1;
for i = 1:Nbr
    for j = 1:Nbc
        % ȡÿһ��
        % ͳ�ƻҶ�ֱ��ͼ
        im_bk = im_CE(1+(i-1)*blocksize:i*blocksize,1+(j-1)*blocksize:j*blocksize);
        blockhist(ind,:) = hist(reshape(im_bk,blocksize*blocksize,1),binCenters);
        % ��һ��
        blockhist(ind,:) = blockhist(ind,:)/sum(blockhist(ind,:));
        % �Ȳ�����Ч�����
        Vg(ind,:)=detectgapbins(blockhist(ind,:));
        ind = ind + 1;
    end
end

%-------------------------------------------------------------------------%
% B.Correct gap bins У���Ĵ���ɸ���

% У�����ֵӦ��ȡ���� 
gc_threshold = 2*(10^(-3));
Vgc = correctbins(Vg,Nb,gc_threshold);

%-------------------------------------------------------------------------%
% C.Locate peak bins  

% ���������ֵ����Ѽ�⵽�Ĺȵ�Ԫ
% ��䷽�� [k-width,k+width]�ĺ����ֵ
width = 1;
gapfilled = GetGapfilledhistogram(Vg,blockhist,Nb,width);
% ��ֵ�˲� ����Ϊ5x5 ��һ��3x3�ľ�ֵ�˲� ��δʵ��
wndsize = 3; % 5
aversize = 3;
filtered = GetFilteredHistogram(gapfilled,Nb,wndsize,aversize);
% ��ֵ�����
% Vp�Ǳ�ʾÿһ���ÿ���Ҷ�ֵ�Ƿ���peak bin
dis = gapfilled - filtered;
dis = dis.*(dis>0);
%figure,bar(abs(dis(1,:))),title('ͼ���һ��Ĳ�ֵ�Ҷ�ֱ��ͼ');

% ��ֵ�����
peakbin_threshold = 0.01;% 0.005 0.01 seems more perfect?
Vp = dis > peakbin_threshold;

%-------------------------------------------------------------------------%
% D.Correct peak bins
pc_threshold = 2*(10^(-3)); %��ֵȡ���� 0.005 0.01 seems more perfect
Vpc = correctbins(Vp,Nb,pc_threshold);

%-------------------------------------------------------------------------%
% Step 3: Peak/Gap Similarity Measure                                     %
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% EDR(Effective Detection Range) ��ȡ��Ч�����
% EDR ��Ч����� �� ������
% �ҵ���⣬�ӵ�һ�����ؿ�ʼ��������Ǻ�ȷ���������������������һ��������涼��0�ģ������䵽��
% EDR1 = GetEDR(Nb,blockhist);
% ��ʦ�ķ����Ǹ��� �嵥Ԫ���Ľ����һ�������ڵ����ֵ�Ķ�ֵ���õ�EDR
EDR = Tr_GetEDR(filtered,Nb,5);
Vgc = Vgc.*EDR;
Vpc = Vpc.*EDR;

% ������ʦ�Ĵ��� pattern_learn_2ndReply �������ͼ��
% [map] = pattern_learn_2ndReply(Vpc,Vgc,[r,c],blocksize,EDR);

%-------------------------------------------------------------------------%
% A.Select gap reference vector Vgr
% k��ʾ����
[k,Vgr] = GetGapReference(Vgc,Nb);

%----------------------------------------------------------------------------------%
% B.Compute similarity betweem Vgc and Vgr
% �����ǵ�k�飬���в�������ΪVgr
% 1:gaps are matched 0:all gap-involved pairs mismatched 0~1:match~mismatch
Mg = ComputeSimilarity(Nb,Vgc,Vgr,EDR(k,:),EDR,[r,c],blocksize);

%-------------------------------------------------------------------------%
% C.Create peak reference vector Vpr ��Ҫ��������ĵõ���Ӧ��blocks
tg = 0.75; % 0.5-0.8
[EDR_Nr,Vpr] = GetPeakReference(Nb,Vpc,Mg,EDR,tg);

%-------------------------------------------------------------------------%
% D.Compute similarity
Mp = ComputeSimilarity(Nb,Vpc,Vpr,EDR_Nr,EDR,[r,c],blocksize);

%-------------------------------------------------------------------------%
% Step 4: Composition Detection                                           %
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% A.Similarity Maps Fusion
for i = 1:size(Mg,1)
    for j =1:size(Mg,2)
        if Mg(i,j)~=-10 && Mp(i,j)~=-10
            M(i,j) = (Mg(i,j)+Mp(i,j))/2;
        elseif Mg(i,j) == -10 || Mp(i,j) == -10
            M(i,j) = max(Mg(i,j),Mp(i,j));
        else
            M(i,j) = -10;
        end
    end
end

%-------------------------------------------------------------------------%
% B.Assign source index Դ����λ 
patt_map_end = M;
patt_map_end2 = patt_map_end;
for i=1:size(patt_map_end,1)
    for j=1:size(patt_map_end,2)
        if patt_map_end(i,j)==-10 
           mat = patt_map_end(max(i-1,1):min(i+1,size(patt_map_end,1)),max(j-1,1):min(j+1,size(patt_map_end,2)));
           % �������-1�ĸ�������һ�룬��õ��ֵ������Χ����������Ϊ-1��ֵ��ƽ��ֵ������
           % ����-1��ԭ����EDRû�н����
           if length(find(mat==-10))<(size(mat,1)*size(mat,2)*0.50)
              patt_map_end2(i,j)=mean(mat(find(mat~=-10)));
           end
        end
    end
end 

% ����Ĵ�����Ϊ���ܹ�׼ȷ��λ �Աȶ���ǿ��λ��
th3 = 0.15; 
patt_map_end3 = patt_map_end2;
patt_map_end3 = (patt_map_end2>th3) + (-10)*(patt_map_end2==-10); 
patt_map_end4 = patt_map_end3;
c = [1,0,-10];
for i=1:size(patt_map_end3,1)
    for j=1:size(patt_map_end3,2)
        mat = patt_map_end3(max(i-1,1):min(i+1,size(patt_map_end3,1)),max(j-1,1):min(j+1,size(patt_map_end3,2)));
        n(1)=length(find(mat==1));
        n(2)=length(find(mat==0));
        n(3)=length(find(mat==-10));
        t=find(n==max(n));
        if  patt_map_end4(i,j)~=c(t(1))
            patt_map_end4(i,j)=c(t(1));
        end
    end
end

patt_map_end5 = patt_map_end4;
if max(size(patt_map_end4))<2
for i=2:size(patt_map_end3,1)-1
    for j=2:size(patt_map_end3,2)-1
        mat = patt_map_end3(max(i-1,1):min(i+1,size(patt_map_end3,1)),max(j-1,1):min(j+1,size(patt_map_end3,2)));
        if ~sum(sum(abs(mat-[1 0 0;1 0 0;1 1 1]))) || ~sum(sum(abs(mat-[0 0 1;0 0 1;1 1 1])))|| ~sum(sum(abs(mat-[1 1 1;0 0 1;0 0 1]))) || ~sum(sum(abs(mat-[1 1 1;1 0 0;1 0 0])))
           patt_map_end5(i,j) = patt_map_end3(i,j);
        elseif   ~sum(sum(abs(mat-[0 1 1;0 1 1;0 0 0]))) || ~sum(sum(abs(mat-[1 1 0;1 1 0;0 0 0]))) || ~sum(sum(abs(mat-[0 0 0;1 1 0;1 1 0]))) || ~sum(sum(abs(mat-[0 0 0;0 1 1;0 1 1]))) 
           patt_map_end5(i,j) = patt_map_end3(i,j);    
        end
    end
end
for i=2:size(patt_map_end3,1)-1
    for j=[1,size(patt_map_end3,2)]
        mat = patt_map_end3(max(i-1,1):min(i+1,size(patt_map_end3,1)),max(j-1,1):min(j+1,size(patt_map_end3,2)));
        if ~sum(sum(abs(mat-[1 0;1 0;1 0]))) || ~sum(sum(abs(mat-[0 1;0 1;0 1] )))
           patt_map_end5(i,j) = patt_map_end3(i,j); 
        end
    end
end
for i=[1,size(patt_map_end3,1)]
    for j=2:size(patt_map_end3,2)-1
        mat = patt_map_end3(max(i-1,1):min(i+1,size(patt_map_end3,1)),max(j-1,1):min(j+1,size(patt_map_end3,2)));
        if ~sum(sum(abs(mat-[0 0 0;1 1 1]))) || ~sum(sum(abs(mat-[1 1 1;0 0 0])))
           patt_map_end5(i,j) = patt_map_end3(i,j);
        end
    end
end
end 
res = patt_map_end2';
end

