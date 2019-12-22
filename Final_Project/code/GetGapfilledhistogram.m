function [gapfill] = GetGapfilledhistogram(Vg,blockhist,Nb,width)
%% 我最初的写法
gf = blockhist;
for i=1:Nb
    for j =1:256
        if Vg(i,j) == 1
            if j-width>=1 && j+width<256
                % 四舍五入
                mean = sum(blockhist(i,j-width:j+width));
                mean = mean - blockhist(i,j);
                gf(i,j) = round(mean/(2*width));
            end
        end
    end
end

%% 老师的写法
gapfill = blockhist;
gapfill(:,[1:3,254:256])=0;% have not considered the first and end 3 bins
for i = 1:Nb
   for  j = 4:253 % have not considered the first and end 3 bins
       if blockhist(i,j) == 0
           gapfill(i,j) = (blockhist(i,j-1)+blockhist(i,j+1))/2;
       end
   end
end
% find(gf~=gapfill);
end