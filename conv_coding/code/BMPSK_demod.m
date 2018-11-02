function data = BMPSK_demod(y,A,level,bias_ratio)
%BMPSK_DEMOD   ƫ�����Ƽ���(Biased Multiple Phase-Shift Keying)��ƽ�о�����
%   ���ú�����ʽ����о�<=>ƽ����ת����ݷ��ǽ����о�
%
%   �������:
%   y           1*n complex   �ն˵�ƽ
%   A           1*1 double    ��ƽ����
%   level       1,2,3         ÿ��ƽ������ 
%   bias_ratio  (0,1] double  ƫ��ϵ��
%   ����ֵ:
%   data  1*(n*level) double  �о����ش�

% �ж������Ƿ�Ϸ�
if (level~=1)&&(level~=2)&&(level~=3)
    error('the 3rd parameter ''level'' must be 0, 1, or 2');
end
if (bias_ratio<0)||(bias_ratio>1)
    error('the 4th parameter ''bias_ratio'' must belong to [0,1]');
end

% ��ʼ��
inv_gray_map = [0,1,3,2,6,7,5,4];
% �����ŵ���ת��λ
phi = angle(mean(y));
% ȥƫ�ò���ԭ��ת
y = y*exp(-1i*phi)-A*bias_ratio;
% ���ݷ����о�������
gray_code = mod(floor(angle(y)*2^(level-1)/pi),2^level);
% ��ԭ������
data = reshape(double(dec2bin(inv_gray_map(gray_code+1)).'-48),1,[]);

end
