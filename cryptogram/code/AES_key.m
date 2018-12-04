function key = AES_key(Nk,seed)
%AES_KEY   AES key generator

% check input
if (Nk~=4)&&(Nk~=6)&&(Nk~=8)
    error('the parameter ''Nk'' must be 4, 6 or 8.');
end
if (nargin~=1)&&(nargin~=2)
    error('num of arguments must be 1 or 2.');
elseif (nargin==1)||isempty(seed)
    seed = 0;
end
num = ceil(length(seed)/(Nk*32));
res = (zeros(1,Nk*32*num-length(seed))<0.5);
seed = reshape([seed,res],Nk*32,num)';
key = mod(sum([rand(1,Nk*32)<0.5;seed]),2);
end
