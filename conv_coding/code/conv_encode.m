function code = conv_encode(data,ieff,en_mode)
%CONV_ENCODE   �������뺯��
%
%   �������:
%   data      1*n double   ����������
%   ieff      2,3          1/����Ч��
%   en_mode   0,1          ����ģʽ: 0->����β, 1->��β
%   ����ֵ:
%   code      1*(n*ieff)   ���������

% �����������ϵ��
coeff = [1,0,1,1;...    % (13)oct
         1,1,0,1;...    % (15)oct
         1,1,1,1];      % (17)oct

% ���ݱ���Ч�ʷֱ���
if ieff == 2
    code = zeros(2,length(data)+4);
    code(1,:) = mod(conv([data,0],coeff(2,:)),2);
    code(2,:) = mod(conv([data,0],coeff(3,:)),2);
elseif ieff == 3
    code = zeros(3,length(data)+4);
    code(1,:) = mod(conv([data,0],coeff(1,:)),2);
    code(2,:) = mod(conv([data,0],coeff(2,:)),2);
    code(3,:) = mod(conv([data,0],coeff(3,:)),2);
else
    error('the 2nd parameter ''ieff'' must be 2 or 3.');
end

% ������β����ȥ�����4λ����
if en_mode == 0
    code = code(:,1:end-4);
elseif en_mode ~= 1
    error('the 3rd parameter ''en_mode'' must be 0 or 1.');
end

% �ع�Ϊһά���������
code = reshape(code,1,[]);

end
