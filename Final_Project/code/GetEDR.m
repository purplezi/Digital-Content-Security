function [EDR] = GetEDR(Nb,blockhist)
%% �ҵ�д�� 
% ��0�㿪ʼ���жϺ���ĵ�k����k���ĵ�ȫΪ0����[0,k]ΪEDR
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

