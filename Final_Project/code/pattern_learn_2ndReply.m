function [patt_map_end5] = pattern_learn_2ndReply(pPosit,gPosit,imSiz,bkSiz,der)
% peak gap pattern
% ones创建全为1的数组
patt_map = (-10)*ones(fix(imSiz/bkSiz));
patt_map = patt_map';
patt_map2 = patt_map;
% gap pattern vector
% sum(gPosit,2) 返回维度2的总和 每一行的总和
% 此处就是找到一个峰值效应最多的块的下标
t=find(sum(gPosit,2)==max(sum(gPosit,2)));
patt_g = gPosit(t(1),:);
% 计算相似度
for i=1:size(gPosit,1)
    if sum(gPosit(i,:))~=0  
       [patt_map(i)]=dist_measure_2ndReply(gPosit(i,:),patt_g,der(i,:),der(t(1),:)); %  der(t(1),:)  [zeros(1,3),ones(1,250),zeros(1,3)]
    end
end
% peak pattern vector
th1 = 0.75;
patt_map_bi= patt_map;
for i = 1:size(patt_map,1)
    for j = 1:size(patt_map,2)
        if patt_map(i,j)>th1
           patt_map_bi(i,j)=1;
        end
    end
end
major_bi = 1;
der_p = zeros(1,256);
patt_p = zeros(1,256);
% 寻找求和后的值大于0的点
for i = 1:size(patt_map_bi,1)
    for j = 1:size(patt_map_bi,2)
        if patt_map_bi(i,j) == major_bi
           patt_p = patt_p + pPosit((j-1)*size(patt_map_bi,1)+i,:);
           der_p = der_p + der((j-1)*size(patt_map_bi,1)+i,:);
        end
    end
end
patt_p = (patt_p>=1);

% 计算相似度
for i=1:size(pPosit,1)
    if sum(pPosit(i,:))~=0  
       patt_map2(i)=dist_measure_2ndReply(pPosit(i,:),patt_p,der(i,:),der_p);    
    end
end

% map fusion
for i=1:size(patt_map,1)
    for j=1:size(patt_map,2)
        if (patt_map(i,j)==-10)&&(patt_map2(i,j)==-10)
            patt_map_end(i,j)=-10;
        elseif (patt_map(i,j)==-10)||(patt_map2(i,j)==-10)
            patt_map_end(i,j)=max([patt_map(i,j),patt_map2(i,j)]);
        else
            patt_map_end(i,j)=(patt_map(i,j)+patt_map2(i,j))/2;
        end          
    end
end
% post-processing: deal with blocks with“-1” ？？？用处
patt_map_end2 = patt_map_end;
for i=1:size(patt_map_end,1)
    for j=1:size(patt_map_end,2)
        if patt_map_end(i,j)==-10 
           mat = patt_map_end(max(i-1,1):min(i+1,size(patt_map_end,1)),max(j-1,1):min(j+1,size(patt_map_end,2)));
           % 如果出现-1的个数多于一半，则该点的值是由周围出现其他不为-1的值的平均值决定的
           % 出现-1的原因是EDR没有交叉点
           if length(find(mat==-10))<(size(mat,1)*size(mat,2)*0.50)
              patt_map_end2(i,j)=mean(mat(find(mat~=-10)));
           end
        end
    end
end 
figure,imagesc(patt_map_end2'),colormap('hot'),colorbar
% 后面的处理都是为了能够准确定位 对比度增强的位置
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
%% results showing
patt_map_end5 = patt_map_end5';
figure,imagesc(patt_map_end5),colormap('hot'),colorbar
