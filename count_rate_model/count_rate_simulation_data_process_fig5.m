% 
%% 理论计算
clc;clear;close all;
Ns=[0.05 0.2 0.5 1 2 inf];
fr=0.1e6*([0.01:0.01:50]);
tr=1./fr;
td=1200e-9; % 死时间1200ns
N=floor(td./tr);
for j=1:length(Ns)
    for i=1:length(N)
        Ps(i,j)=(1-exp(-Ns(j)))/(1+N(i)-N(i)*exp(-Ns(j)));
        Ps_N(i,j)=Ps(i,j)*td/tr(i);
    end
    figure(1);
    plot(N,Ps(:,j));hold on;
    figure_polish;
    figure(2);
    plot(td./tr,Ps_N(:,j));hold on;
    xlabel('Laser Repetition frequency/Hz');ylabel('Count rate/Hz');
    figure_polish;
    figure(3);
    if j==1
        plot(fr/1e6,Ps_N(:,j)*1/td/1000,'LineWidth',1.5);hold on;
    elseif j==2
        plot(fr/1e6,Ps_N(:,j)*1/td/1000,'Color',[0.4471, 0.6902, 0.3882],'LineWidth',1.5);hold on;
    elseif j==3
        plot(fr/1e6, Ps_N(:,j)*1/td/1000, 'Color', [0.5804, 0.7765, 0.8039], 'LineWidth', 1.5);hold on;
    elseif j==4
        plot(fr/1e6,Ps_N(:,j)*1/td/1000,'-r','LineWidth',1.5);hold on;
    elseif j==5
        plot(fr/1e6,Ps_N(:,j)*1/td/1000, 'Color',[0.8863, 0.5686, 0.2078],'LineWidth',1.5);hold on;
    elseif j==6
        plot(fr/1e6,Ps_N(:,j)*1/td/1000,'-k','LineWidth',1.5);hold on;
    end
    
    xlabel('Laser repetition frequency/MHz');ylabel('Count rate/kHz');
    figure_polish;
end
legend('Ns=0.05','Ns=0.2','Ns=0.5', 'Ns=1','Ns=2','Ns=inf');



clc;clear; 

%% 初始化
Ns_ground_truth=[0.05 0.2 0.5 1 2];
td=1200; % 死区时间，单位ns
currentFolder = pwd;

for j=1:length(Ns_ground_truth)
    for i=0.5e5:0.5e5:50e5
        filename=[currentFolder,'\data\count_rate_ver\fr_',num2str(i),'fn_0k_Ns_',num2str(Ns_ground_truth(j)),'.mat'];
        load(filename);
        data(i/0.5e5,j)=length(s_TDC)/0.2e-3/1000;
    end
    figure(3);
    if j==1
        ax = gca;
        set(ax, 'ColorOrderIndex', 1);
        plot((0.5e5:0.5e5:50e5)./1e6,data(:,j),'.');hold on;
    elseif j==2
        plot((0.5e5:0.5e5:50e5)./1e6,data(:,j),'.','Color',[0.4471, 0.6902, 0.3882]);hold on;
    elseif j==3
        plot((0.5e5:0.5e5:50e5)./1e6,data(:,j),'.','Color', [0.5804, 0.7765, 0.8039]);hold on;
    elseif j==4
        plot((0.5e5:0.5e5:50e5)./1e6,data(:,j),'r.');hold on;
    elseif j==5
        plot((0.5e5:0.5e5:50e5)./1e6,data(:,j),'.','Color',[0.8863, 0.5686, 0.2078]);hold on;
    end
end
figure(3);
plot([0,5e6]./1e6,1/(td*1e-9)*ones(2,1)/1000,'--k','LineWidth',1.5);% 绘制饱和计数率
hold on;figure_polish;


function figure_polish()
    grid on;
    set(gcf, 'Position', [200, 300, 280, 200]); % 例如，左下角坐标为 (300, 300)，宽度为 800，高度为 600
%     h_legend = legend(legend_content, 'Location', legend_position);
% %     设置图例文本的字体大小为 20
%     set(h_legend, 'FontSize', 10);
    ax=gca;
    % 将坐标轴的 'Box' 属性设置为 'on'，以显示上下边框
%     set(gca,'FontName','Times New Roman','fontsize',10.5);
    ax.Box = 'on';
    ax.LineWidth=1.5;% 内边框粗细
    ax.YAxis.LineWidth=1.5;% 外边框粗细
    ax.XAxis.LineWidth=1.5;% 外边框粗细
    ax.GridAlpha=0.1;
    set(gcf, 'color', 'white');% 将图形的背景颜色设置为白色

end




