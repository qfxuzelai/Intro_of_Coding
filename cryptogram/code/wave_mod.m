function [tx_wave] = wave_mod(symbol,sps,t_res,fir,f_c)
%
% Function to perform wave modulate
%
%****************** variables *************************
% symbol : the symbols to modulate
% sps : samples per symbol
% t_res : the time resolution
% fir : the parameter of rcosine filter
% f_c : the center frequency of carrier wave
% tx_wave : the wave at the exit of transmitter
% *****************************************************
    L = length(symbol);
    I_imp = reshape([zeros(sps/2-1,L);real(symbol);zeros(sps/2,L)],1,sps*L);
    Q_imp = reshape([zeros(sps/2-1,L);imag(symbol);zeros(sps/2,L)],1,sps*L);
    I_base_wave = conv(I_imp,fir,'same');
    Q_base_wave = conv(Q_imp,fir,'same');
    I_twave = I_base_wave.*cos(2*pi*f_c*t_res*[1:length(I_base_wave)]);
    Q_twave = Q_base_wave.*sin(2*pi*f_c*t_res*[1:length(Q_base_wave)]);
    tx_wave = I_twave+Q_twave;
end