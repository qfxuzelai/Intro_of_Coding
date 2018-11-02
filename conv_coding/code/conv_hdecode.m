function data = conv_hdecode(code,ieff,en_mode)
%CONV_HDECODE   卷积码硬判决译码函数
%   采用Viterbi译码
%
%   输入参数:
%   code      1*n double   卷积码码流
%   ieff      2,3          1/编码效率
%   en_mode   0,1          编码模式: 0->不收尾, 1->收尾
%   返回值:
%   data      1*(n/ieff)   卷积码码流

% 定义译码中的常量
CONV_CODE   = [0,1,0,1,1,0,1,0,1,0,1,0,0,1,0,1;...  % 卷积码许用码字表
               0,1,1,0,0,1,1,0,1,0,0,1,1,0,0,1;...
               0,1,1,0,1,0,0,1,1,0,0,1,0,1,1,0];
kron_kernel = [1,1];                                % 张量积核
col_index   = [0,2,4,6,8,10,12,14];                 % 源状态列索引
state       = [1,1,2,2,3,3,4,4;5,5,6,6,7,7,8,8];    % 源状态矩阵
decode_end  = [0;1;0;1;0;1;0;1];                    % 单步译码码字

% 判断输入是否合法
if (ieff~=2)&&(ieff~=3)
    error('the 2nd parameter ''ieff'' must be 2 or 3.');
end
if (en_mode~=0)&&(en_mode~=1)
    error('the 3nd parameter ''en_mode'' must be 0 or 1.');
end

% 初始化各状态的累加汉明距离和幸存路径矩阵
hamm_dist = [0,Inf,Inf,Inf,Inf,Inf,Inf,Inf];
survive_path = zeros(8,length(code)/ieff);
data = zeros(1,length(code)/ieff);

% Viterbi译码
for cnt = 1:length(code)/ieff
    % 读取当前卷积码码字
    curr_code = code((cnt-1)*ieff+1:cnt*ieff).';
    % 计算当前码字与各许用码字的汉明距离
    curr_dist = reshape(sum(mod(repmat(curr_code,1,16)+CONV_CODE(4-ieff:3,:),2)),8,2).';
    % 计算各状态的最小累加汉明距离和单步源状态
    next_dist = curr_dist+reshape(kron(hamm_dist,kron_kernel),8,2).';
    [hamm_dist,argmin] = min(next_dist);
    src_state = state(col_index+argmin);
    % 更新幸存路径矩阵   
    survive_path(:,cnt) = src_state;
end

% 根据是否收尾分别回溯
if en_mode == 0
    [~,curr_state] = min(hamm_dist);
else
    curr_state = 1;
end

for cnt = length(survive_path):-1:1
    data(cnt) = decode_end(curr_state);
    curr_state = survive_path(curr_state,cnt);
end

% 若收尾则去零
if en_mode == 1
    data = data(1:end-4);
end

end
