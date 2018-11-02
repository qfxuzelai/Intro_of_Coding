function data = BMPSK_demod(y,A,level,bias_ratio)
%BMPSK_DEMOD   偏置相移键控(Biased Multiple Phase-Shift Keying)电平判决函数
%   利用后验概率进行判决<=>平移旋转后根据辐角进行判决
%
%   输入参数:
%   y           1*n complex   收端电平
%   A           1*1 double    电平幅度
%   level       1,2,3         每电平比特数 
%   bias_ratio  (0,1] double  偏置系数
%   返回值:
%   data  1*(n*level) double  判决比特串

% 判断输入是否合法
if (level~=1)&&(level~=2)&&(level~=3)
    error('the 3rd parameter ''level'' must be 0, 1, or 2');
end
if (bias_ratio<0)||(bias_ratio>1)
    error('the 4th parameter ''bias_ratio'' must belong to [0,1]');
end

% 初始化
inv_gray_map = [0,1,3,2,6,7,5,4];
% 估计信道旋转相位
phi = angle(mean(y));
% 去偏置并还原旋转
y = y*exp(-1i*phi)-A*bias_ratio;
% 根据辐角判决格雷码
gray_code = mod(floor(angle(y)*2^(level-1)/pi),2^level);
% 还原比特流
data = reshape(double(dec2bin(inv_gray_map(gray_code+1)).'-48),1,[]);

end
