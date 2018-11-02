% ����1,2,3bit/����ӳ��ʱBMPSK��BER-SNR������
% ����ʱ�� ~= 7s
clear all;
close all;
clc;

% �������
symbol_L = 100000;              % �����ƽ����
A = 10;                         % ��ƽ����
SNR = [-20:0.5:30];             % �����
BER = zeros(3,length(SNR));     % ������(3��bit_num)
bias_ratio = 1/4;               % ƫ��ϵ��
phase_const = 1;                % �ŵ�����Ϊ�̶�����
index = 1:5:101;                % ���߱�ǵ�����

% �����źŹ���
signal_power = A^2*(1+bias_ratio^2);

% ����bit_num=1,2,3ʱ��BER-SNR������
for bit_num = 1:3 
    % ������ش����Ȳ����ɴ����ͱ��ش�
    L = symbol_L*bit_num;
    tdata = (rand(1,L)>0.5);
    % BMPSKӳ��
    x = BMPSK_mod(tdata,A,bit_num,bias_ratio);
    % �����ض�������µ�������
    for cnt = 1:length(SNR)
        % ������������
        noise_power = signal_power/10^(SNR(cnt)/10);
        % �̶���λ�ŵ�����
        y = my_channel(x,noise_power,phase_const);
        % BMPSK�о�
        rdata = BMPSK_demod(y,A,bit_num,bias_ratio);
        % ����������
        err = (rdata ~= tdata);
        BER(bit_num,cnt) = sum(err)/length(err);
    end
end

% ��������
figure();
set(gcf,'position',[200,150,900,300]);

% ��������
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

% ��������
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
