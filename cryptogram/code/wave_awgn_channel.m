function [rx_wave] = wave_awgn_channel(tx_wave,S,SNR)
%
% Function of the awgn channel of wave 
%
%****************** variables *************************
% tx_wave : the wave at the exit of transmitter
% S : the power of symbol
% SNR : the signal-noise ratio (E_s/n_0)
% rx_wave : the wave at the entrance of receiver
% *****************************************************
    N = S/10^(SNR/10);
    rx_wave = tx_wave+sqrt(N)/2*randn(1,length(tx_wave));
end