% 绘制不卷积，硬判决，软判决BMPSK映射时的BER-SNR曲线
% 运行时间 ~= 2min
clear all;
close all;
clc;

% 定义参数
symbol_L = 10000;               % 传输电平个数
A = 10;                         % 电平幅度
SNR = [-20:0.5:30];             % 信噪比
BER = zeros(3,length(SNR));     % 误码率
ieff = 2;                       % 1/2卷积效率
en_mode = 0;                    % 不收尾
bit_num = 2;                    % 2bit/符号
bias_ratio = 1/4;               % 偏置比例
phase_const = 1;                % 信道特性为固定相移
index = 1:5:101;                % 曲线标记点索引

% 计算比特串长度并生成待发送比特串
L = symbol_L*bit_num;
tdata = (rand(1,L)>0.5);
% 计算信号功率
signal_power = A^2*(1+bias_ratio^2);

% 生成不卷积的映射电平
x_no_conv = BMPSK_mod(tdata,A,bit_num,bias_ratio);
% 生成卷积编码的映射电平
data_conv = conv_encode(tdata,ieff,en_mode);
x_conv = BMPSK_mod(data_conv,A,bit_num,bias_ratio);

% 计算特定信噪比下的误码率
for cnt = 1:length(SNR)
    % 计算噪声功率
    noise_power = signal_power/10^(SNR(cnt)/10);
    
    % 固定相位信道传输不卷积电平
    y_no_conv = my_channel(x_no_conv,noise_power,phase_const);
    % BMPSK判决
    rdata_no_conv = BMPSK_demod(y_no_conv,A,bit_num,bias_ratio);
    % 计算不卷积时的误码率
    err_no_conv = (rdata_no_conv ~= tdata);
    BER(1,cnt) = sum(err_no_conv)/length(err_no_conv);
    
    % 固定相位信道传输卷积后电平
    y_conv = my_channel(x_conv,noise_power,phase_const);
    
    % 硬判决
    conv_data = BMPSK_demod(y_conv,A,bit_num,bias_ratio);
    rdata_hard = conv_hdecode(conv_data,ieff,en_mode);
    % 计算硬判决误码率
    err_hard = (rdata_hard ~= tdata);
    BER(2,cnt) = sum(err_hard)/length(err_hard);
    
    % 软判决
    rdata_soft = conv_sdecode(y_conv,ieff,en_mode,A,bit_num,1);
    % 计算硬判决误码率
    err_soft = (rdata_soft ~= tdata);
    BER(3,cnt) = sum(err_soft)/length(err_soft);
end

% 绘制曲线
figure();
set(gcf,'position',[200,150,900,300]);

% 线性坐标
subplot(1,2,1);
hold on;
BER_smooth = smooth(BER(1,:));
plot(SNR,BER_smooth,'LineWidth',1,'Color',[1,0,0],'Marker','o','MarkerIndices',index);
BER_smooth = smooth(BER(2,:));
plot(SNR,BER_smooth,'LineWidth',1,'Color',[0,1,0],'Marker','^','MarkerIndices',index);
BER_smooth = smooth(BER(3,:));
plot(SNR,BER_smooth,'LineWidth',1,'Color',[0,0,1],'Marker','s','MarkerIndices',index);
title('BER-SNR Curve','FontName','Arial');
xlabel('SNR/dB','FontName','Arial');
ylabel('BER','FontName','Arial');
set(gca,'LineWidth',1);
legend('without conv','hard decode','soft decode');
hold off;

% 对数坐标
subplot(1,2,2);
hold on;
BER_smooth = smooth(BER(1,:));
plot(SNR,BER_smooth,'LineWidth',1,'Color',[1,0,0],'Marker','o','MarkerIndices',index);
BER_smooth = smooth(BER(2,:));
plot(SNR,BER_smooth,'LineWidth',1,'Color',[0,1,0],'Marker','^','MarkerIndices',index);
BER_smooth = smooth(BER(3,:));
plot(SNR,BER_smooth,'LineWidth',1,'Color',[0,0,1],'Marker','s','MarkerIndices',index);
title('BER-SNR log Curve','FontName','Arial');
xlabel('SNR/dB','FontName','Arial');
ylabel('BER','FontName','Arial');
set(gca,'yscale','log');
set(gca,'LineWidth',1);
legend('without conv','hard decode','soft decode','Location','southwest');
hold off;
