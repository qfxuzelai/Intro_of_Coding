function data = conv_hdecode(code,ieff,en_mode)
%CONV_HDECODE   �����Ӳ�о����뺯��
%   ����Viterbi����
%
%   �������:
%   code      1*n double   ���������
%   ieff      2,3          1/����Ч��
%   en_mode   0,1          ����ģʽ: 0->����β, 1->��β
%   ����ֵ:
%   data      1*(n/ieff)   ���������

% ���������еĳ���
CONV_CODE   = [0,1,0,1,1,0,1,0,1,0,1,0,0,1,0,1;...  % ������������ֱ�
               0,1,1,0,0,1,1,0,1,0,0,1,1,0,0,1;...
               0,1,1,0,1,0,0,1,1,0,0,1,0,1,1,0];
kron_kernel = [1,1];                                % ��������
col_index   = [0,2,4,6,8,10,12,14];                 % Դ״̬������
state       = [1,1,2,2,3,3,4,4;5,5,6,6,7,7,8,8];    % Դ״̬����
decode_end  = [0;1;0;1;0;1;0;1];                    % ������������

% �ж������Ƿ�Ϸ�
if (ieff~=2)&&(ieff~=3)
    error('the 2nd parameter ''ieff'' must be 2 or 3.');
end
if (en_mode~=0)&&(en_mode~=1)
    error('the 3nd parameter ''en_mode'' must be 0 or 1.');
end

% ��ʼ����״̬���ۼӺ���������Ҵ�·������
hamm_dist = [0,Inf,Inf,Inf,Inf,Inf,Inf,Inf];
survive_path = zeros(8,length(code)/ieff);
data = zeros(1,length(code)/ieff);

% Viterbi����
for cnt = 1:length(code)/ieff
    % ��ȡ��ǰ���������
    curr_code = code((cnt-1)*ieff+1:cnt*ieff).';
    % ���㵱ǰ��������������ֵĺ�������
    curr_dist = reshape(sum(mod(repmat(curr_code,1,16)+CONV_CODE(4-ieff:3,:),2)),8,2).';
    % �����״̬����С�ۼӺ�������͵���Դ״̬
    next_dist = curr_dist+reshape(kron(hamm_dist,kron_kernel),8,2).';
    [hamm_dist,argmin] = min(next_dist);
    src_state = state(col_index+argmin);
    % �����Ҵ�·������   
    survive_path(:,cnt) = src_state;
end

% �����Ƿ���β�ֱ����
if en_mode == 0
    [~,curr_state] = min(hamm_dist);
else
    curr_state = 1;
end

for cnt = length(survive_path):-1:1
    data(cnt) = decode_end(curr_state);
    curr_state = survive_path(curr_state,cnt);
end

% ����β��ȥ��
if en_mode == 1
    data = data(1:end-4);
end

end
