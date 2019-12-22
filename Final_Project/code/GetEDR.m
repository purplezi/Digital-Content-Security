function [EDR] = GetEDR(Nb,blockhist)
%% 我的写法 
% 从0点开始，判断后面的点k，若k点后的点全为0，则[0,k]为EDR
EDR = zeros(1,Nb);
for i = 1:Nb
   for j = 256:-1:1
       cnt = 0;
       for k = j:256
           if blockhist(i,k) == 0
               cnt = cnt + 1;
           end
       end
       if cnt == 256-j+1
           EDR(i) = j;
       else
           break;
       end
   end
end
end

