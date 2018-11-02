function x = BMPSK_mod(data,A,level,bias_ratio)
%BMPSK_MOD   ƫ�����Ƽ���(Biased Multiple Phase-Shift Keying)��ƽӳ�亯��
%   ��������ΪA��M=2^level��MPSK, Ȼ�����е�����ƽ��A*bias_ratio
%
%   �������:
%   data        1*n double    ��ӳ����ش�
%   A           1*1 double    ��ƽ����
%   level       1,2,3         ÿ��ƽ������
%   bias_ratio  [0,1] double  ƫ��ϵ��
%   ����ֵ:
%   x    1*(n/level) complex  ӳ���ƽ

% �ж������Ƿ�Ϸ�
if (level==1)||(level==2)||(level==3)
    rem = mod(length(data),level);
    if rem ~= 0
        data = [data,zeros(1,level-rem)];
    end
else
    error('the 3rd parameter ''level'' must be 0, 1, or 2');
end
if (bias_ratio<0)||(bias_ratio>1)
    error('the 4th parameter ''bias_ratio'' must belong to [0,1]');
end

% ��ʼ��
gray_map = [0,1,3,2,7,6,4,5];
% ����ӳ��
gray_cnt = gray_map(bin2dec(char(reshape(data,level,[]).'+48))+1);
% ��������
phase = 2*pi/(2^level)*(1/2+gray_cnt);
% OPSKӳ��
x = A*(exp(1i*phase)+bias_ratio);

end
