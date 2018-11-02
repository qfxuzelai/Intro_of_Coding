% ���Ʋ������Ӳ�о������о�BMPSKӳ��ʱ��BER-SNR����
% ����ʱ�� ~= 2min
clear all;
close all;
clc;

% �������
symbol_L = 10000;               % �����ƽ����
A = 10;                         % ��ƽ����
SNR = [-20:0.5:30];             % �����
BER = zeros(3,length(SNR));     % ������
ieff = 2;                       % 1/2���Ч��
en_mode = 0;                    % ����β
bit_num = 2;                    % 2bit/����
bias_ratio = 1/4;               % ƫ�ñ���
phase_const = 1;                % �ŵ�����Ϊ�̶�����
index = 1:5:101;                % ���߱�ǵ�����

% ������ش����Ȳ����ɴ����ͱ��ش�
L = symbol_L*bit_num;
tdata = (rand(1,L)>0.5);
% �����źŹ���
signal_power = A^2*(1+bias_ratio^2);

% ���ɲ������ӳ���ƽ
x_no_conv = BMPSK_mod(tdata,A,bit_num,bias_ratio);
% ���ɾ�������ӳ���ƽ
data_conv = conv_encode(tdata,ieff,en_mode);
x_conv = BMPSK_mod(data_conv,A,bit_num,bias_ratio);

% �����ض�������µ�������
for cnt = 1:length(SNR)
    % ������������
    noise_power = signal_power/10^(SNR(cnt)/10);
    
    % �̶���λ�ŵ����䲻�����ƽ
    y_no_conv = my_channel(x_no_conv,noise_power,phase_const);
    % BMPSK�о�
    rdata_no_conv = BMPSK_demod(y_no_conv,A,bit_num,bias_ratio);
    % ���㲻���ʱ��������
    err_no_conv = (rdata_no_conv ~= tdata);
    BER(1,cnt) = sum(err_no_conv)/length(err_no_conv);
    
    % �̶���λ�ŵ����������ƽ
    y_conv = my_channel(x_conv,noise_power,phase_const);
    
    % Ӳ�о�
    conv_data = BMPSK_demod(y_conv,A,bit_num,bias_ratio);
    rdata_hard = conv_hdecode(conv_data,ieff,en_mode);
    % ����Ӳ�о�������
    err_hard = (rdata_hard ~= tdata);
    BER(2,cnt) = sum(err_hard)/length(err_hard);
    
    % ���о�
    rdata_soft = conv_sdecode(y_conv,ieff,en_mode,A,bit_num,1);
    % ����Ӳ�о�������
    err_soft = (rdata_soft ~= tdata);
    BER(3,cnt) = sum(err_soft)/length(err_soft);
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
title('BER-SNR Curve','FontName','Arial');
xlabel('SNR/dB','FontName','Arial');
ylabel('BER','FontName','Arial');
set(gca,'LineWidth',1);
legend('without conv','hard decode','soft decode');
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
xlabel('SNR/dB','FontName','Arial');
ylabel('BER','FontName','Arial');
set(gca,'yscale','log');
set(gca,'LineWidth',1);
legend('without conv','hard decode','soft decode','Location','southwest');
hold off;
