% 绘制1,2,3bit/符号映射时BMPSK的BER-SNR的曲线
% 运行时间 ~= 7s
clear all;
close all;
clc;

% 定义参数
symbol_L = 100000;              % 传输电平个数
A = 10;                         % 电平幅度
SNR = [-20:0.5:30];             % 信噪比
BER = zeros(3,length(SNR));     % 误码率(3种bit_num)
bias_ratio = 1/4;               % 偏置系数
phase_const = 1;                % 信道特性为固定相移
index = 1:5:101;                % 曲线标记点索引

% 计算信号功率
signal_power = A^2*(1+bias_ratio^2);

% 计算bit_num=1,2,3时的BER-SNR的曲线
for bit_num = 1:3 
    % 计算比特串长度并生成待发送比特串
    L = symbol_L*bit_num;
    tdata = (rand(1,L)>0.5);
    % BMPSK映射
    x = BMPSK_mod(tdata,A,bit_num,bias_ratio);
    % 计算特定信噪比下的误码率
    for cnt = 1:length(SNR)
        % 计算噪声功率
        noise_power = signal_power/10^(SNR(cnt)/10);
        % 固定相位信道传输
        y = my_channel(x,noise_power,phase_const);
        % BMPSK判决
        rdata = BMPSK_demod(y,A,bit_num,bias_ratio);
        % 计算误码率
        err = (rdata ~= tdata);
        BER(bit_num,cnt) = sum(err)/length(err);
    end
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
title('BMPSK BER-SNR Curve','FontName','Arial');
xlabel('SNR/dB','FontName','Arial');
ylabel('BER','FontName','Arial');
set(gca,'LineWidth',1);
legend('1 bit/symbol','2 bit/symbol','3 bit/symbol');
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
title('BMPSK BER-SNR log Curve','FontName','Arial');
xlabel('SNR/dB','FontName','Arial');
ylabel('BER','FontName','Arial');
set(gca,'yscale','log');
set(gca,'LineWidth',1);
legend('1 bit/symbol','2 bit/symbol','3 bit/symbol','Location','southwest');
hold off;
