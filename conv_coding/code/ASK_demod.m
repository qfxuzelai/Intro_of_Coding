function [data] = ASK_demod(y,A,level,noise_power)
%
% Function to demodulate in ASK
%
%****************** variables *************************
% y : symbols to demodulate
% A : amplitude
% level : the numbers of levels (8ASK->3)
% noise_power : the power of noise, including the real and the img
% data : bitstream demodulated from symbols
% *****************************************************
    if (level~=1)&&(level~=2)&&(level~=3)
        error('the 3rd parameter ''level'' must be 0, 1, or 2');
    end
    power = noise_power/2;
    base_table = [0,0,0;0,0,1;0,1,1;0,1,0;1,1,0;1,1,1;1,0,1;1,0,0]';
    table = base_table(end-level+1:end,1:2^level);
    step = 2^level-1;
    inter = A/step;
    th = find_th(inter,step,power,A);
    data = ones(1,step)*(repmat(abs(y),step,1)>repmat(th',1,length(y)));
    k = table(:,data+1);
    data = reshape(k,1,level*length(y));
end

function [th] = find_th(inter,step,power,A)
    th = zeros(1,step);
    p = @(r,A,power)(log(besseli(0,A*r/power,1))-(A^2-2*A*r)/2/power);
    for count = 1:step
        r_min = 0;
        r_max = A;
        while p(r_max,inter*(count-1),power)>p(r_max,inter*count,power)
            r_max = r_max+A;
        end
        while r_max-r_min>1e-4
            r_new = (r_max+r_min)/2;
            if p(r_new,inter*(count-1),power)>p(r_new,inter*count,power)
                r_min = r_new;
            else
                r_max = r_new;
            end
        end
        th(1,count) = r_max;
    end
end
