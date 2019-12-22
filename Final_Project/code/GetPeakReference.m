function [EDR_p,Vpr1] = GetPeakReference(Nb,Vpc,Mg,EDR,tg)
% ��ֵ���ڼ�����ƶȵĲο�������Ҫ������ֵ�����ƶȽ�����ֵ��
%% ��ʦ��д��
Mp = Mg;
for i = 1:size(Mg,1)
    for j = 1:size(Mg,2)
        if Mg(i,j) > tg
            Mp(i,j)=1;
        end
    end
end
% ѡ��������Mg������ֵtg�Ŀ�
% ����Щ�����ָʾ�����Ĵ���
% ��1�� ͳ�����ؿ���ͬһ���صĸ�����
EDR_p = zeros(1,256);
Vpr1 = zeros(1,256);
for i = 1:size(Mg,1)
    for j = 1:size(Mg,2)
        if Mp(i,j)==1
            Vpr1 = Vpr1 + Vpc((j-1)*size(Mg,1)+i,:);
            EDR_p = EDR_p + EDR((j-1)*size(Mg,1)+i,:);
        end
    end
end
Vpr1 = (Vpr1>=1);
EDR_p = (EDR_p>=1);
