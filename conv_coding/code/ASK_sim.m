clear all, close all, clc;

%************** Preparation part ********************
symbol_L = 1e5;                    %the number of symbols to simulate
A = 10;                            %the amplitude of level
SNR = -20:0.5:40;                 %the signal-noise ratio to simulate
biterr = zeros(6,length(SNR));     %the result of BER
%****************************************************
for level = 1:3
    signal_power = A^2*sum([0:2^level-1].^2)/(2^level-1)^2/2^level;
    L = symbol_L*level;
    for count = 1:length(SNR)
        noise_power = signal_power/10^(SNR(1,count)/10);
        seridata = rand(1,L)>0.5;
        x = ASK_mod(seridata,A,level);
        y = my_channel(x,noise_power,0);
        demodata = ASK_demod(y,A,level,noise_power);
        demodata1 = ASK_demod_euc(y,A,level);
        biterr(level,count) = sum(abs(double(demodata)-double(seridata)))/L;
        biterr(level+3,count) = sum(abs(double(demodata1)-double(seridata)))/L;
    end
end

index = 1:5:101;

figure();
set(gcf,'position',[100,0,900,300]);

subplot(1,2,1);
hold on;
plot(SNR,smooth(biterr(1,:)),'LineStyle','-','LineWidth',1,'Color',[1,0,0],'Marker','o','MarkerIndices',index);
plot(SNR,smooth(biterr(2,:)),'LineStyle','-','LineWidth',1,'Color',[0,1,0],'Marker','^','MarkerIndices',index);
plot(SNR,smooth(biterr(3,:)),'LineStyle','-','LineWidth',1,'Color',[0,0,1],'Marker','s','MarkerIndices',index);
plot(SNR,smooth(biterr(4,:)),'LineStyle','--','LineWidth',1,'Color',[1,0,0],'Marker','o','MarkerIndices',index);
plot(SNR,smooth(biterr(5,:)),'LineStyle','--','LineWidth',1,'Color',[0,1,0],'Marker','^','MarkerIndices',index);
plot(SNR,smooth(biterr(6,:)),'LineStyle','--','LineWidth',1,'Color',[0,0,1],'Marker','s','MarkerIndices',index);
title('BER-SNR Curve','FontName','Arial');
xlabel('SNR','FontName','Arial');
ylabel('BER','FontName','Arial');
set(gca,'LineWidth',1);
legend('1bit/symbol,ML','2bit/symbol,ML','3bit/symbol,ML','1bit/symbol,EUC','2bit/symbol,EUC','3bit/symbol,EUC');
hold off;

subplot(1,2,2);
hold on;
plot(SNR,smooth(biterr(1,:)),'LineStyle','-','LineWidth',1,'Color',[1,0,0],'Marker','o','MarkerIndices',index);
plot(SNR,smooth(biterr(2,:)),'LineStyle','-','LineWidth',1,'Color',[0,1,0],'Marker','^','MarkerIndices',index);
plot(SNR,smooth(biterr(3,:)),'LineStyle','-','LineWidth',1,'Color',[0,0,1],'Marker','s','MarkerIndices',index);
plot(SNR,smooth(biterr(4,:)),'LineStyle','--','LineWidth',1,'Color',[1,0,0],'Marker','o','MarkerIndices',index);
plot(SNR,smooth(biterr(5,:)),'LineStyle','--','LineWidth',1,'Color',[0,1,0],'Marker','^','MarkerIndices',index);
plot(SNR,smooth(biterr(6,:)),'LineStyle','--','LineWidth',1,'Color',[0,0,1],'Marker','s','MarkerIndices',index);
title('BER-SNR log Curve','FontName','Arial');
xlabel('SNR','FontName','Arial');
ylabel('BER','FontName','Arial');
set(gca,'yscale','log');
set(gca,'LineWidth',1);
legend('1bit/symbol,ML','2bit/symbol,ML','3bit/symbol,ML','1bit/symbol,EUC','2bit/symbol,EUC','3bit/symbol,EUC','Location','southwest');
hold off;

function [data] = ASK_demod_euc(y,A,level)
    if (level~=1)&&(level~=2)&&(level~=3)
        error('the 3rd parameter ''level'' must be 0, 1, or 2');
    end
    base_table = [0,0,0;0,0,1;0,1,1;0,1,0;1,1,0;1,1,1;1,0,1;1,0,0]';
    table = base_table(end-level+1:end,1:2^level);
    data = round(abs(y)/A*(2^level-1));
    data(data>2^level-1) = 2^level-1;
    k = table(:,data+1);
    data = reshape(k,1,level*length(y));
end