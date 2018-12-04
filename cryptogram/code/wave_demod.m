function [rsymbol] = wave_demod(rx_wave,sps,t_res,fir,f_c)
%
% Function to perform wave demodulate
%
%****************** variables *************************
% rx_wave : the wave at the entrance of receiver
% sps : samples per symbol
% t_res : the time resolution
% fir : the parameter of rcosine filter
% f_c : the center frequency of carrier wave
% rsymbol : the symbols demodulated from the wave
% *****************************************************
    I_demod_wave = 2*rx_wave.*cos(2*pi*f_c*t_res*[1:length(rx_wave)]);
    Q_demod_wave = 2*rx_wave.*sin(2*pi*f_c*t_res*[1:length(rx_wave)]);
    I_map_wave = conv(I_demod_wave,fir,'same');
    Q_map_wave = conv(Q_demod_wave,fir,'same');
    rsymbol = I_map_wave+1i*Q_map_wave;
    L = length(rsymbol)/sps;
    rsymbol = rsymbol(sps/2:sps:(L-1)*sps+sps/2);
end