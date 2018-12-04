% BER-SNR curve of no AES, AES conv, and conv AES
% run time ~= 5min
clear all;
close all;
clc;

% define parameters
Nk = 4;             % num of 32-bit words in key
L = 102400;          % length of tdata
ieff = 2;           % 1/2 conv efficiency
en_mode = 0;        % non-zero ending
A = 1;              % Amplitude
bit_num = 2;        % 2-bit/symbol
alpha = 0.5;            % alpha of rcosine filter
t_res = 1e-4;       % time resolution of wave
R_s = 2000;         % symbol rate
sym_num = 10;       % num of symbols in rcosine filter
f_c = 1850;         % central freq of channel
SNR = -20:0.5:30;
BER = zeros(3,length(SNR));
index = 1:5:length(SNR);

P_signal = A^2;
key = AES_key(Nk);
tdata = (rand(1,L)<0.5);
[rcos_fir,sps] = rcosine_FIR(alpha,t_res,R_s,sym_num);

% no AES
x_NA = conv_encode(tdata,ieff,en_mode);
x_NA = PSK_mod(x_NA,A,bit_num);
twave_NA = wave_mod(x_NA,sps,t_res,rcos_fir,f_c);

% first AES then conv
x_AC = AES_enc(tdata,key);
x_AC = conv_encode(x_AC,ieff,en_mode);
x_AC = PSK_mod(x_AC,A,bit_num);
twave_AC = wave_mod(x_AC,sps,t_res,rcos_fir,f_c);

% first conv then AES
x_CA = conv_encode(tdata,ieff,en_mode);
x_CA = AES_enc(x_CA,key);
x_CA = PSK_mod(x_CA,A,bit_num);
twave_CA = wave_mod(x_CA,sps,t_res,rcos_fir,f_c);

% compute BER-SNR curve
for cnt = 1:length(SNR) 
    % no AES
    rwave_NA = wave_awgn_channel(twave_NA,P_signal,SNR(cnt));
    y_NA = wave_demod(rwave_NA,sps,t_res,rcos_fir,f_c);
    rdata_NA = PSK_demod(y_NA,A,bit_num);
    rdata_NA = conv_hdecode(rdata_NA,ieff,en_mode);
    err_NA = (rdata_NA ~= tdata);
    BER(1,cnt) = sum(err_NA)/length(err_NA);  
    
    % AES conv
    rwave_AC = wave_awgn_channel(twave_AC,P_signal,SNR(cnt));
    y_AC = wave_demod(rwave_AC,sps,t_res,rcos_fir,f_c);
    rdata_AC = PSK_demod(y_AC,A,bit_num);
    rdata_AC = conv_hdecode(rdata_AC,ieff,en_mode);
    rdata_AC = AES_dec(rdata_AC,key);
    err_AC = (rdata_AC ~= tdata);
    BER(2,cnt) = sum(err_AC)/length(err_AC);
    
    % conv AES
    rwave_CA = wave_awgn_channel(twave_CA,P_signal,SNR(cnt));
    y_CA = wave_demod(rwave_CA,sps,t_res,rcos_fir,f_c);
    rdata_CA = PSK_demod(y_CA,A,bit_num);
    rdata_CA = AES_dec(rdata_CA,key);
    rdata_CA = conv_hdecode(rdata_CA,ieff,en_mode);
    err_CA = (rdata_CA ~= tdata);
    BER(3,cnt) = sum(err_CA)/length(err_CA);
end

save('AES_sim.mat','SNR','BER','index');

% plot BER-SNR curve
figure();
set(gcf,'position',[200,150,900,300]);

% linear coordinate
subplot(1,2,1);
hold on;
BER_smooth = smooth(BER(1,:));
plot(SNR,BER_smooth,'LineWidth',1,'Color',[1,0,0],'Marker','o','MarkerIndices',index);
BER_smooth = smooth(BER(2,:));
plot(SNR,BER_smooth,'LineWidth',1,'Color',[0,1,0],'Marker','^','MarkerIndices',index);
BER_smooth = smooth(BER(3,:));
plot(SNR,BER_smooth,'LineWidth',1,'Color',[0,0,1],'Marker','s','MarkerIndices',index);
title('BER-SNR curve','FontName','Arial');
xlabel('SNR/dB','FontName','Arial');
ylabel('BER','FontName','Arial');
set(gca,'LineWidth',1);
legend('no AES','AES conv','conv AES');
hold off;

% log coordinate
subplot(1,2,2);
hold on;
BER_smooth = smooth(BER(1,:));
plot(SNR,BER_smooth,'LineWidth',1,'Color',[1,0,0],'Marker','o','MarkerIndices',index);
BER_smooth = smooth(BER(2,:));
plot(SNR,BER_smooth,'LineWidth',1,'Color',[0,1,0],'Marker','^','MarkerIndices',index);
BER_smooth = smooth(BER(3,:));
plot(SNR,BER_smooth,'LineWidth',1,'Color',[0,0,1],'Marker','s','MarkerIndices',index);
title('BER-SNR log curve','FontName','Arial');
xlabel('SNR/dB','FontName','Arial');
ylabel('BER','FontName','Arial');
set(gca,'yscale','log');
set(gca,'LineWidth',1);
legend('no AES','AES conv','conv AES','Location','southwest');
hold off;
