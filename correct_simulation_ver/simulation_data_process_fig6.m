% Fig. 7 Simulation results
clc;clear; close all;
Syncrate=3.125e6;
Tacq=0.2; % ��λ��ms
Resolution_ps=16;

%% ��ʼ��
Ns_ground_truth=0.05:0.025:20;
pulse_width=0.39;
td=1200; % ����ʱ�䣬��λns
count_rate=zeros(length(Ns_ground_truth),1);

laser_repetition=double(Syncrate);

for i=1:length(Ns_ground_truth)
    filename=['E:\13.SPL_code\optica��������\spl_driver_V10_house_20250125\data\paper\optica\optica_simulation\data_3.125MHz\fn_200k_Ns_',num2str(Ns_ground_truth(i)),'.mat'];
    load(filename);
    [num_t,num]=his_fig_plot(s_TDC,Resolution_ps/1000,laser_repetition);
    count_rate(i)=length(s_TDC)/Tacq;
    [num_t2,num2,n_rep]=reshape_wf(num,num_t,td,laser_repetition);
    
%     [max_value,max_index]=maxk(num2,n_rep);
    [num_reshape,index_pulse]=his_max_find(num,num_t,Resolution_ps);
    resolution_ns=Resolution_ps/1000;
%     index_pulse=round(max_index(1)-3*pulse_width/resolution_ns):round(max_index(1)+4*pulse_width/resolution_ns); % ֻ��Ҫ����һ���Ϳ�����
    [flight_time_recover, flux_recover,flight_time_orig,flux_orig,~]=correction_optica(index_pulse, num2, Tacq/1000,double(laser_repetition/n_rep),resolution_ns,td);
%     [flight_time_recover, flux_recover,waveform_recover]=correction(index_pulse, num2, Tacq/1000,double(laser_repetition/n_rep),resolution_ns,td);
%     figure(1);subplot(4,1,1);
%     plot(num_t2(index_pulse),num2(index_pulse));
%     subplot(4,1,2);
%     plot(num_t2(index_pulse),num2(index_pulse)/max(num(index_pulse)));
    
    data_all(i,:)=[flight_time_orig,flux_orig,flight_time_recover, flux_recover];

    waitbar(i/length(Ns_ground_truth));
%     titleStr = ['�ź�ͨ��=',num2str(Ns_ground_truth(i)/4)];
    
    y=guass(num_t,Ns_ground_truth(i)/4);
    up_bun=max(y*Tacq/1000*laser_repetition)*10;

%     figure(10);
%     plot3(Ns_ground_truth(i)/4*ones(length(index_pulse),1),num_t(index_pulse),movmean(waveform_recover*4,10),'r-','LineWidth',0.1);hold on;
%     plot3(Ns_ground_truth(i)/4*ones(length(num_t),1),num_t,movmean(num,10),'b-','LineWidth',0.6); hold on;%ylim([0,up_bun]);
%     plot3(Ns_ground_truth(i)/4*ones(length(num_t),1),num_t,movmean(y*Tacq/1000*laser_repetition,10),'k-','LineWidth',1);hold on;
% %     plot3(Ns_ground_truth(i)/4*[1 1],flight_time_orig*[1 1],[0,up_bun],'g--','LineWidth', 3);hold on;
% %     plot3(Ns_ground_truth(i)/4*[1, 1],flight_time_recover*[1 1],[0,up_bun],'b--','LineWidth', 3);hold on;
% %     title(sprintf('�ź�ͨ����%.4f���źŹ���', Ns_ground_truth(i)/4));
%     xlabel('Ns');ylabel('flight time/ns');zlabel('Count');ylim([207,213]);zlim([0,40]);xlim([0,5]);
%     legend('Corrected','Uncorrected','Ground truth', 'Location', 'northwest');
% %     hold off;
%     figure_polish();
end
Ns_ground_truth=Ns_ground_truth/4; % ��������ʹ�õ���3���巢��

figure(5);% ǿ��ͼ
plot(Ns_ground_truth,data_all(:,2),'bo');hold on;
plot(Ns_ground_truth,data_all(:,4),'r*');hold on;
plot(Ns_ground_truth,Ns_ground_truth,'k');hold on;
xlim([0,5]);
% ylim([0,7]);
xlabel('Ns');
ylabel('Ns');

figure_polish(); 
legend('Uncorrected','Corrected','Ground truth', 'Location', 'northwest');

distance_truth=210.*ones(length(Ns_ground_truth),1);
figure(6);% ���ͼ
plot(Ns_ground_truth,data_all(:,1)*0.15,'bo');hold on;% δУ��
plot(Ns_ground_truth,data_all(:,3)*0.15,'r*');hold on;% У��
plot(Ns_ground_truth,distance_truth*0.15,'k');hold on;
xlabel('Ns');
ylabel('Depth/m');
% ylabel('Ns');
xlim([0,5]);
figure_polish(); 
legend('Uncorrected','Corrected','Ground truth', 'Location', 'northwest');

figure(11);% ǿ��ͼ
relative_error_uncorrected=(data_all(:,2)-Ns_ground_truth')./Ns_ground_truth';
relative_error_corrected=(data_all(:,4)-Ns_ground_truth')./Ns_ground_truth';
plot(count_rate,relative_error_uncorrected,'bo');hold on;
plot(count_rate,relative_error_corrected,'r*');hold on;
xlim([100,800]);ylim([-1,0.5]);
xlabel('Count rate/kHz');ylabel('Relative error of flux');

figure_polish(); 
legend('Uncorrected','Corrected','Location', 'southwest');


figure(7);% ǿ��ͼ
plot(count_rate,data_all(:,2)-Ns_ground_truth','bo');hold on;
plot(count_rate,data_all(:,4)-Ns_ground_truth','r*');hold on;
xlim([100,800]);ylim([-5,1]);
xlabel('Count rate/kHz');ylabel('Flux error/photons');

figure_polish(); 
legend('Uncorrected','Corrected','Location', 'southwest');

distance_truth=210.*ones(length(Ns_ground_truth),1);
figure(8);% ���ͼ
plot(count_rate,data_all(:,1)*0.15-distance_truth*0.15,'bo');hold on;% δУ��
plot(count_rate,data_all(:,3)*0.15-distance_truth*0.15,'r*');hold on;% У��
xlabel('Count rate/kHz');ylabel('Depth error/m');
xlim([100,800]);ylim([-0.07,0.03]);

figure_polish(); 
legend('Uncorrected','Corrected','Location', 'southwest');

% ylim([31.46,31.52]);
%% ���ȼ���
% ͨ�����ȼ���
index_pulse=Ns_ground_truth<3 | Ns_ground_truth==3;
Ns_select=Ns_ground_truth(index_pulse)';
Ns_not_reco=data_all(:,2);
Ns_not_reco=Ns_not_reco(index_pulse);
Ns_reco=data_all(:,4);
Ns_reco=Ns_reco(index_pulse);
std_Ns_not_reco=(sum((Ns_select-Ns_not_reco).^2)/length(Ns_not_reco)).^0.5;
std_Ns_reco=(sum((Ns_select-Ns_reco).^2)/length(Ns_reco)).^0.5;
fprintf('δУ�����ź�ͨ�����ȣ�%2.3f photons\n',std_Ns_not_reco);
fprintf('У������ź�ͨ�����ȣ�%2.3f photons\n',std_Ns_reco);
std_relative_error_uncorrected=(sum(relative_error_uncorrected(index_pulse).^2)/length(index_pulse)).^0.5;
std_relative_error_corrected=(sum(relative_error_corrected(index_pulse)).^2/length(index_pulse)).^0.5;
fprintf('δУ�����ź�ͨ�������%2.3f\n',std_relative_error_uncorrected);
fprintf('У������ź�ͨ�������%2.3f\n',std_relative_error_corrected);


% ���뾫�ȼ���
distance_select=distance_truth(index_pulse)*0.15;
dis_not_reco=data_all(:,1)*0.15;
dis_reco=data_all(:,3)*0.15;
dis_not_reco=dis_not_reco(index_pulse);
dis_reco=dis_reco(index_pulse);
std_dis_not_reco=(sum((distance_select-dis_not_reco).^2)/length(dis_not_reco)).^0.5;
std_dis_reco=(sum((distance_select-dis_reco).^2)/length(dis_reco)).^0.5;
fprintf('δУ�����ź���Ⱦ��ȣ�%2.4f m\n',std_dis_not_reco);
fprintf('У������ź���Ⱦ��ȣ�%2.4f m\n',std_dis_reco);
%%
figure(9);
plot(Ns_ground_truth(index_pulse),count_rate(index_pulse),'.-');

function [num_t2,num2,a]=reshape_wf(num,num_t,td,laser_repetition)
    a=ceil((td*1e-9)/(1/laser_repetition)); % ������չ����
    num1=num/a;
    num2=repmat(num1,a,1);
    resolution=num_t(2)-num_t(1);
    num_t2=resolution*(1:length(num2));  
end

function [num_t,num]=his_fig_plot(scatter_y,resolution,laser_frequency)
    % ���ڽ�ɢ��ͼת��Ϊֱ��ͼ��ͨ����ɢ�����ݷ��䵽��Ӧ��ʱ��bin��
%  ���ڽ�ɢ��ͼ����ֱ��ͼ
    size_length=ceil(1/laser_frequency*1e9/resolution);
    scatter_y=scatter_y(scatter_y>0);
    num=zeros(size_length,1);
    
    for i=1:length(scatter_y)
        num(scatter_y(i))=num(scatter_y(i))+1;
    end
    num_t=resolution*(1:size_length)';
end

function figure_polish()
    grid on;
    set(gcf, 'Position', [200, 300, 280, 200]); % ���磬���½�����Ϊ (300, 300)�����Ϊ 800���߶�Ϊ 600
%     h_legend = legend(legend_content, 'Location', legend_position);
% %     ����ͼ���ı��������СΪ 20
%     set(h_legend, 'FontSize', 10);
    ax=gca;
    % ��������� 'Box' ��������Ϊ 'on'������ʾ���±߿�
%     set(gca,'FontName','Times New Roman','fontsize',10.5);
    ax.Box = 'on';
    ax.LineWidth=1.5;% �ڱ߿��ϸ
    ax.YAxis.LineWidth=1.5;% ��߿��ϸ
    ax.XAxis.LineWidth=1.5;% ��߿��ϸ
    ax.GridAlpha=0.1;
    set(gcf, 'color', 'white');% ��ͼ�εı�����ɫ����Ϊ��ɫ
    % ax.XMinorGrid='on';
    % ax.YMinorGrid='on';
end

function y=guass(t,Ns)
% ������̽�� 20240122-1
    theta=0.3934; %20271007ʹ�õ�������Ϊ0.4
    ts=210;
    y=Ns/((2*pi)^0.5*theta)*exp(-((t-ts).^2)./(2*theta^2));
    y=y/62.5;
end

function [num_reshape,index_pulse]=his_max_find(num,num_t,Resolution_ps)
%  ���ڽ�ɢ��ͼ����ֱ��ͼ ��׼��
% �������ĺ��ź�ͨ��

    pw=0.5; % ����������Ϊpw����������ȣ�����λ����
    num_t=(1:length(num))';
    %% ���������ֵ
    width=ceil(3*pw/(Resolution_ps/1000));
    paddedArray=zeros(ceil(length(num)/width)*width-length(num),1);
    num_padded=[num; paddedArray];
    num_reshape=sum(reshape(num_padded,[width,length(num_padded)/width]));
    [~,max_index_reshape]=max(num_reshape);
    index_pulse_shape=max(max_index_reshape*width-ceil(3*pw/(Resolution_ps*1e-3)),1):min(max_index_reshape*width+ceil(3*pw/(Resolution_ps*1e-3)),length(num_t));
%     figure(2);plot((1:length(num_reshape))*Resolution,num_reshape);hold on;
    [~,max_index]=max(num(index_pulse_shape));
    max_index=max_index+index_pulse_shape(1)-1;
    index_pulse=max(max_index-ceil(3*pw/(Resolution_ps*1e-3)),1):min(max_index+ceil(3*pw/(Resolution_ps*1e-3)),length(num));

end

