function [x] = ASK_mod(data,A,level)
%
% Function to modulate in ASK
%
%****************** variables *************************
% data : bitstream to modulate
% A : amplitude
% level : the numbers of levels (8ASK->3)
% x : symbols modulated from bitstream
% *****************************************************
if (level==1)||(level==2)||(level==3)
    rem = mod(length(data),level);
    if rem ~= 0
        data = [data,zeros(1,level-rem)];
    end
else
    error('the 3rd parameter ''level'' must be 0, 1, or 2');
end
    k = [0,1,3,2,7,6,4,5];
    x = k(2.^[level-1:-1:0]*reshape(data,level,length(data)/level)+1)*A/(2^level-1);
end