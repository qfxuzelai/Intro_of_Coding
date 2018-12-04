clear all, close all, clc;

% parameter
bit_L = 8192;                   % the number of bits to send
t_res = 1e-4;                   % the time resolution of wave
sym_num = 10;                   % the number of symbols in the rcosine filter
f_c = 1850;                     % the central frequency of channel
R_s = 2000;                     % the symbol rate
R = 0.5;                        % the parameter of rcosine filter
A = 1;                          % the amplitude
SNR = -10:1:30;                 % the signal-noise ratio
BER = zeros(12,length(SNR));    % the bit-error ratio
SER = zeros(4,length(SNR));     % the symbol-error ratio
nloop = 8;                      % the simulation loop

% find the parameter of the rcosine filter
[rcos_fir,sps] = rcosine_FIR(R,t_res,R_s,sym_num);

% generate the bit to transmitnin
tdata = (rand(1,bit_L)>0.5);

%**************** transmitter ************************
% encryption
tdata_encrypt = tdata;

% Reed-Solomon encoding
tdata_group = tdata_encrypt;

% convolutional encoding
tdata_conv = tdata_group;

% reflect to the symbols
symbol_bpsk = PSK_mod(tdata_conv,A,1);
S_bpsk = A^2;

% modualte the symbols into the wave to transmit
tx_wave_bpsk = wave_mod(symbol_bpsk,sps,t_res,rcos_fir,f_c);

for count = 1:length(SNR)
    for iii = 1:nloop
%****************** channel **************************
rx_wave_bpsk = wave_awgn_channel(tx_wave_bpsk,S_bpsk*7/3,SNR(count));

%****************** receiver *************************
% demodulate the wave to get the symbols
rsymbol_bpsk = wave_demod(rx_wave_bpsk,sps,t_res,rcos_fir,f_c);

% reflect to the bit
rdata_conv_bpsk = PSK_demod(rsymbol_bpsk,A,1);

rsymbol_bpsk = PSK_mod(rdata_conv_bpsk,A,1);
SER(1,count) = SER(1,count)+sum(rsymbol_bpsk~=symbol_bpsk)/length(rsymbol_bpsk);

% convolutional decoding
rdata_grou_bpsk = rdata_conv_bpsk;

% Reed-Solomon decoding
rdata_encrypt_bpsk = rdata_group_RS_bpsk;

% dencryption
rdata_bpsk = rdata_encrypt_bpsk;

BER(1,count) = BER(1,count)+sum(rdata_bpsk(1:length(tdata))~=tdata)/length(tdata);
    end
end

BER = BER/nloop;
SER = SER/nloop;