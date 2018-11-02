% ����bias_ratio=1/16,1/4,1ʱBMPSK��BER-SNR����
% ����ʱ�� ~= 2s
clear all;
close all;
clc;

% �������
symbol_L = 5000;                % �����ƽ����
A = 10;                         % ��ƽ����
SNR = [-20:0.5:30];             % �����
BER = zeros(3,length(SNR));     % ������(3��bias_ratio)
bit_num = 2;                    % 2bit/����
bias_ratio = [1/16,1/4,1];      % ƫ�ñ���
phase_const = 1;                % �ŵ�����Ϊ�̶�����
index = 1:5:101;                % ���߱�ǵ�����

% ������ش����Ȳ����ɴ����ͱ��ش�
L = symbol_L*bit_num;
tdata = (rand(1,L)>0.5);

% ����bias_ratio=1/16,1/4,1ʱ��BER-SNR����
for ratio_cnt = 1:3
    % �����źŹ���
    signal_power = A^2*(1+bias_ratio(ratio_cnt)^2);
    % BMPSKӳ��
    x = BMPSK_mod(tdata,A,bit_num,bias_ratio(ratio_cnt));
    % �����ض�������µ�������
    for SNR_cnt = 1:length(SNR)
        % ������������
        noise_power_OPSK = signal_power/10^(SNR(SNR_cnt)/10);
        % �̶���λ�ŵ�����
        y = my_channel(x,noise_power_OPSK,phase_const);
        % BMPSK�о�
        rdata = BMPSK_demod(y,A,bit_num,bias_ratio(ratio_cnt));
        % ����������
        err = (rdata ~= tdata);
        BER(ratio_cnt,SNR_cnt) = sum(err)/length(err);
    end
end

% ��������
figure();
set(gcf,'position',[200,150,900,300]);

% ��������
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

% ��������
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
