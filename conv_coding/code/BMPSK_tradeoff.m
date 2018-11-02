% 绘制bias_ratio=1/16,1/4,1时BMPSK的BER-SNR曲线
% 运行时间 ~= 2s
clear all;
close all;
clc;

% 定义参数
symbol_L = 5000;                % 传输电平个数
A = 10;                         % 电平幅度
SNR = [-20:0.5:30];             % 信噪比
BER = zeros(3,length(SNR));     % 误码率(3种bias_ratio)
bit_num = 2;                    % 2bit/符号
bias_ratio = [1/16,1/4,1];      % 偏置比例
phase_const = 1;                % 信道特性为固定相移
index = 1:5:101;                % 曲线标记点索引

% 计算比特串长度并生成待发送比特串
L = symbol_L*bit_num;
tdata = (rand(1,L)>0.5);

% 计算bias_ratio=1/16,1/4,1时的BER-SNR曲线
for ratio_cnt = 1:3
    % 计算信号功率
    signal_power = A^2*(1+bias_ratio(ratio_cnt)^2);
    % BMPSK映射
    x = BMPSK_mod(tdata,A,bit_num,bias_ratio(ratio_cnt));
    % 计算特定信噪比下的误码率
    for SNR_cnt = 1:length(SNR)
        % 计算噪声功率
        noise_power_OPSK = signal_power/10^(SNR(SNR_cnt)/10);
        % 固定相位信道传输
        y = my_channel(x,noise_power_OPSK,phase_const);
        % BMPSK判决
        rdata = BMPSK_demod(y,A,bit_num,bias_ratio(ratio_cnt));
        % 计算误码率
        err = (rdata ~= tdata);
        BER(ratio_cnt,SNR_cnt) = sum(err)/length(err);
    end
end

% 绘制曲线
figure();
set(gcf,'position',[200,150,900,300]);

% 线性坐标
subplot(1,2,1);
hold on;
plot(SNR,BER(1,:),'LineWidth',1,'Color',[1,0,0]);
plot(SNR,BER(2,:),'LineWidth',1,'Color',[0,1,0]);
plot(SNR,BER(3,:),'LineWidth',1,'Color',[0,0,1]);
plot(SNR,BER(2,:),'g');
plot(SNR,BER(3,:),'b');
title('BER-SNR Curve','FontName','Arial');
xlabel('SNR','FontName','Arial');
ylabel('BER','FontName','Arial');
set(gca,'LineWidth',1);
legend('bias\_ratio = 1/16','bias\_ratio = 1/4','bias\_ratio = 1');
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
xlabel('SNR','FontName','Arial');
ylabel('BER','FontName','Arial');
set(gca,'yscale','log');
set(gca,'LineWidth',1);
legend('bias\_ratio = 1/16','bias\_ratio = 1/4','bias\_ratio = 1','Location','southwest');
hold off;
