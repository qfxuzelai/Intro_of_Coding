function code = conv_encode(data,ieff,en_mode)
%CONV_ENCODE   卷积码编码函数
%
%   输入参数:
%   data      1*n double   待编码码流
%   ieff      2,3          1/编码效率
%   en_mode   0,1          编码模式: 0->不收尾, 1->收尾
%   返回值:
%   code      1*(n*ieff)   卷积码码流

% 定义卷积码编码系数
coeff = [1,0,1,1;...    % (13)oct
         1,1,0,1;...    % (15)oct
         1,1,1,1];      % (17)oct

% 根据编码效率分别处理
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

% 若不收尾，则去掉最后4位码字
if en_mode == 0
    code = code(:,1:end-4);
elseif en_mode ~= 1
    error('the 3rd parameter ''en_mode'' must be 0 or 1.');
end

% 重构为一维卷积码码流
code = reshape(code,1,[]);

end
