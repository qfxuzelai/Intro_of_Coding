function data = conv_sdecode(y,ieff,en_mode,A,level,map_mode)
%CONV_SDECODE   卷积码软判决译码函数
%   采用Viterbi译码
%
%   输入参数:
%   y          1*n double   卷积码码流
%   ieff       2,3          1/编码效率
%   en_mode    0,1          编码模式: 0->不收尾, 1->收尾
%   A          1*1 double   电平幅度
%   level      1,2,3        每电平比特数
%   map_mode   0,1          映射模式: 0->ASK, 1->BMPSK
%   返回值:
%   data       1*m          卷积码码流

% 判断输入是否合法
if (ieff~=2)&&(ieff~=3)
    error('the 2nd parameter ''ieff'' must be 2 or 3.');
end
if (en_mode~=0)&&(en_mode~=1)
    error('the 3nd parameter ''en_mode'' must be 0 or 1.');
end
if (level~=1)&&(level~=2)&&(level~=3)
    error('the 5th parameter ''level'' must be 1, 2, or 3.');
end

% 根据映射模式对y进行预处理
if map_mode == 0
    y = abs(y);
elseif map_mode == 1
    y = y*exp(-1i*angle(mean(y)))-abs(mean(y));
else
    error('the 6th parameter ''map_mode'' must be 0 or 1.');
end

% 计算相关参数
% step_size:  单步译码读取电平步长
% data_len:   单步译码所得码字长度
% conv_pos:   单步译码可达路径卷积码对应的复电平
% decode_end: 单步译码码字
[step_size,data_len,conv_pos,decode_end]...
    = get_param(ieff,A,level,map_mode); 
path_num = 2^data_len;                  % 单步译码可达特定状态的路径数
col_index = path_num*(0:7);             % 源状态列索引
zero_row = zeros(1,8*path_num);         % 全零行(为防止curr_dist对行求和)
kron_kernel = ones(1,path_num);         % 张量积核
state = reshape(kron((1:8),kron_kernel),8,path_num).'; % 源状态矩阵

% 初始化各状态的累加欧氏距离，幸存路径矩阵，和译码结果
eucd_dist = [0,Inf,Inf,Inf,Inf,Inf,Inf,Inf];
survive_path = zeros(8,length(y)/step_size);
data = zeros(1,length(y)/step_size*data_len);

% Viterbi译码
for cnt = 1:length(y)/step_size
    % 读取当前卷积码对应的复电平
    curr_code = y((cnt-1)*step_size+1:cnt*step_size).';
    % 计算该复电平与各可达路径对应复电平的欧氏距离
    curr_dist = reshape(sum([zero_row;abs(repmat(curr_code,1,8*path_num)-conv_pos)]),8,path_num).';
    % 计算各状态的最小累加欧氏距离和单步源状态
    next_dist = curr_dist+reshape(kron(eucd_dist,kron_kernel),8,path_num).';
    [eucd_dist,argmin] = min(next_dist);
    src_state = state(col_index+argmin);
    % 更新幸存路径
    survive_path(:,cnt) = src_state;
end

% 根据是否收尾分别回溯
if en_mode == 0
    [~,curr_state] = min(eucd_dist);
else
    curr_state = 1;
end

for cnt = length(survive_path):-1:1
    data((cnt-1)*data_len+1:cnt*data_len) = decode_end(curr_state,:);
    curr_state = survive_path(curr_state,cnt);
end

% 若收尾则去零
if en_mode == 1
    data = data(1:end-4);
end

end

function [step_size,data_len,conv_pos,decode_end]...
    = get_param(ieff,A,level,map_mode)
%GET_PARAM   计算Viterbi译码所需的相关参数
%
%   输入参数:
%   ieff        2,3                1/编码效率
%   A           1*1 double         电平幅度
%   level       1,2,3              每电平比特数
%   map_mode    0,1                映射模式: 0->ASK, 1->BMPSK
%   返回值:
%   step_size   1*1 double         单步译码读取电平步长
%   data_len    1*1 double         单步译码所得码字长度
%   conv_pos    m*n complex        单步译码可达路径卷积码对应的复电平
%   decode_end  data_len*8 double  单步译码码字

% 卷积码许用码字表
CONV_CODE  = [0,1,0,1,1,0,1,0,1,0,1,0,0,1,0,1;...
              0,1,1,0,0,1,1,0,1,0,0,1,1,0,0,1;...
              0,1,1,0,1,0,0,1,1,0,0,1,0,1,1,0];
% 单步译码码字表
DECODE_END = [0,0,0,0,1,1,1,1;...
              0,0,1,1,0,0,1,1;...
              0,1,0,1,0,1,0,1];

% 计算相关参数
data_len = lcm(level,ieff)/ieff;
step_size = lcm(level,ieff)/level;
decode_end = DECODE_END(4-data_len:end,:).';

% 计算各可达路径对应的卷积码
conv_code = zeros(data_len*ieff,8*2^data_len);
for cnt = 1:data_len
    conv_code((cnt-1)*ieff+1:cnt*ieff,:)...
        = repmat(kron(CONV_CODE(4-ieff:end,:),ones(1,2^(data_len-cnt))),1,2^(cnt-1));
end

% 计算各可达路径卷积码对应的复电平
conv_pos = zeros(step_size,8*2^data_len);
for cnt = 1:step_size
    if map_mode == 0
        conv_pos(cnt,:)...
            = ASK_mod(reshape(conv_code((cnt-1)*level+1:cnt*level,:),1,[]),A,level);
    else
        conv_pos(cnt,:)...
            = BMPSK_mod(reshape(conv_code((cnt-1)*level+1:cnt*level,:),1,[]),A,level,0);
    end
end

end
