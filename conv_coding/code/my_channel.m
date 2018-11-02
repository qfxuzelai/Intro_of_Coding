function [y] = my_channel(x,noise_power,phase_const)
%
% Function to perform channel
%
%****************** variables *************************
% x : symbols before the channel
% noise : the power of symbols before the channel
% y : symbols after the channel
% phase_const : the phase distortion is constant or not (yes->1,no->0)
% *****************************************************
    L = length(x);
    phase = 2*pi*rand(1,L);
    noise = sqrt(noise_power/2)*(randn(1,L)+1i*randn(1,L));
    if phase_const==1
        y = x*exp(1i*phase(1,1))+noise;
    else
        y = x.*exp(1i*phase)+noise;
    end
end