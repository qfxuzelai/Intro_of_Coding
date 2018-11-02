function x = BMPSK_mod(data,A,level,bias_ratio)
%BMPSK_MOD   偏置相移键控(Biased Multiple Phase-Shift Keying)电平映射函数
%   先做幅度为A且M=2^level的MPSK, 然后将所有点向右平移A*bias_ratio
%
%   输入参数:
%   data        1*n double    待映射比特串
%   A           1*1 double    电平幅度
%   level       1,2,3         每电平比特数
%   bias_ratio  [0,1] double  偏置系数
%   返回值:
%   x    1*(n/level) complex  映射电平

% 判断输入是否合法
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

% 初始化
gray_map = [0,1,3,2,7,6,4,5];
% 格雷映射
gray_cnt = gray_map(bin2dec(char(reshape(data,level,[]).'+48))+1);
% 计算相移
phase = 2*pi/(2^level)*(1/2+gray_cnt);
% OPSK映射
x = A*(exp(1i*phase)+bias_ratio);

end
