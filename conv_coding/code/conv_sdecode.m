function data = conv_sdecode(y,ieff,en_mode,A,level,map_mode)
%CONV_SDECODE   ��������о����뺯��
%   ����Viterbi����
%
%   �������:
%   y          1*n double   ���������
%   ieff       2,3          1/����Ч��
%   en_mode    0,1          ����ģʽ: 0->����β, 1->��β
%   A          1*1 double   ��ƽ����
%   level      1,2,3        ÿ��ƽ������
%   map_mode   0,1          ӳ��ģʽ: 0->ASK, 1->BMPSK
%   ����ֵ:
%   data       1*m          ���������

% �ж������Ƿ�Ϸ�
if (ieff~=2)&&(ieff~=3)
    error('the 2nd parameter ''ieff'' must be 2 or 3.');
end
if (en_mode~=0)&&(en_mode~=1)
    error('the 3nd parameter ''en_mode'' must be 0 or 1.');
end
if (level~=1)&&(level~=2)&&(level~=3)
    error('the 5th parameter ''level'' must be 1, 2, or 3.');
end

% ����ӳ��ģʽ��y����Ԥ����
if map_mode == 0
    y = abs(y);
elseif map_mode == 1
    y = y*exp(-1i*angle(mean(y)))-abs(mean(y));
else
    error('the 6th parameter ''map_mode'' must be 0 or 1.');
end

% ������ز���
% step_size:  ���������ȡ��ƽ����
% data_len:   ���������������ֳ���
% conv_pos:   ��������ɴ�·��������Ӧ�ĸ���ƽ
% decode_end: ������������
[step_size,data_len,conv_pos,decode_end]...
    = get_param(ieff,A,level,map_mode); 
path_num = 2^data_len;                  % ��������ɴ��ض�״̬��·����
col_index = path_num*(0:7);             % Դ״̬������
zero_row = zeros(1,8*path_num);         % ȫ����(Ϊ��ֹcurr_dist�������)
kron_kernel = ones(1,path_num);         % ��������
state = reshape(kron((1:8),kron_kernel),8,path_num).'; % Դ״̬����

% ��ʼ����״̬���ۼ�ŷ�Ͼ��룬�Ҵ�·�����󣬺�������
eucd_dist = [0,Inf,Inf,Inf,Inf,Inf,Inf,Inf];
survive_path = zeros(8,length(y)/step_size);
data = zeros(1,length(y)/step_size*data_len);

% Viterbi����
for cnt = 1:length(y)/step_size
    % ��ȡ��ǰ������Ӧ�ĸ���ƽ
    curr_code = y((cnt-1)*step_size+1:cnt*step_size).';
    % ����ø���ƽ����ɴ�·����Ӧ����ƽ��ŷ�Ͼ���
    curr_dist = reshape(sum([zero_row;abs(repmat(curr_code,1,8*path_num)-conv_pos)]),8,path_num).';
    % �����״̬����С�ۼ�ŷ�Ͼ���͵���Դ״̬
    next_dist = curr_dist+reshape(kron(eucd_dist,kron_kernel),8,path_num).';
    [eucd_dist,argmin] = min(next_dist);
    src_state = state(col_index+argmin);
    % �����Ҵ�·��
    survive_path(:,cnt) = src_state;
end

% �����Ƿ���β�ֱ����
if en_mode == 0
    [~,curr_state] = min(eucd_dist);
else
    curr_state = 1;
end

for cnt = length(survive_path):-1:1
    data((cnt-1)*data_len+1:cnt*data_len) = decode_end(curr_state,:);
    curr_state = survive_path(curr_state,cnt);
end

% ����β��ȥ��
if en_mode == 1
    data = data(1:end-4);
end

end

function [step_size,data_len,conv_pos,decode_end]...
    = get_param(ieff,A,level,map_mode)
%GET_PARAM   ����Viterbi�����������ز���
%
%   �������:
%   ieff        2,3                1/����Ч��
%   A           1*1 double         ��ƽ����
%   level       1,2,3              ÿ��ƽ������
%   map_mode    0,1                ӳ��ģʽ: 0->ASK, 1->BMPSK
%   ����ֵ:
%   step_size   1*1 double         ���������ȡ��ƽ����
%   data_len    1*1 double         ���������������ֳ���
%   conv_pos    m*n complex        ��������ɴ�·��������Ӧ�ĸ���ƽ
%   decode_end  data_len*8 double  ������������

% ������������ֱ�
CONV_CODE  = [0,1,0,1,1,0,1,0,1,0,1,0,0,1,0,1;...
              0,1,1,0,0,1,1,0,1,0,0,1,1,0,0,1;...
              0,1,1,0,1,0,0,1,1,0,0,1,0,1,1,0];
% �����������ֱ�
DECODE_END = [0,0,0,0,1,1,1,1;...
              0,0,1,1,0,0,1,1;...
              0,1,0,1,0,1,0,1];

% ������ز���
data_len = lcm(level,ieff)/ieff;
step_size = lcm(level,ieff)/level;
decode_end = DECODE_END(4-data_len:end,:).';

% ������ɴ�·����Ӧ�ľ����
conv_code = zeros(data_len*ieff,8*2^data_len);
for cnt = 1:data_len
    conv_code((cnt-1)*ieff+1:cnt*ieff,:)...
        = repmat(kron(CONV_CODE(4-ieff:end,:),ones(1,2^(data_len-cnt))),1,2^(cnt-1));
end

% ������ɴ�·��������Ӧ�ĸ���ƽ
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
