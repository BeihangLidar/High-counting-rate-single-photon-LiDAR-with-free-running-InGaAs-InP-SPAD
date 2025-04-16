clc;clear all; close all;
load('20240102-1-low-flux_result.mat');
clearvars -except output;
load('20250101-2-3125-result.mat');
close all;clearvars -except Depth_array_point fast_array_point slow_array_point output_point data_all Depth_recovery fast_array_point_recovery slow_array_point_recovery output;
Index_fliter=fast_array_point<0.19 & fast_array_point>-0.06;
output=output(Index_fliter,:);
Depth_array_point=Depth_array_point(Index_fliter);
fast_array_point=fast_array_point(Index_fliter); 
slow_array_point=slow_array_point(Index_fliter);
output_point=output_point(Index_fliter,:);
data_all=data_all(Index_fliter,:);
Depth_recovery=Depth_recovery(Index_fliter);
fast_array_point_recovery=fast_array_point_recovery(Index_fliter);
slow_array_point_recovery=slow_array_point_recovery(Index_fliter);

figure(8);% 看深度 未补偿
scatter3(Depth_array_point,fast_array_point,slow_array_point,2, Depth_array_point, 'filled');hold on;xlabel('Depth/m');ylabel('Fast axis/m');zlabel('Fast axis/m');
xlim([8.30,8.41]);zlim([-0.72,-0.48]);ylim([-0.09,0.22]);caxis([8.36,8.4]);
figure_polish;

figure(9);% 看强度 未补偿
scatter3(Depth_array_point,fast_array_point,slow_array_point,2, output_point(:,4), 'filled');hold on;xlabel('Depth/m');ylabel('Fast axis/m');zlabel('Slow axis/m');
xlim([8.30,8.41]);zlim([-0.72,-0.48]);ylim([-0.09,0.22]);
colormap gray;colorbar;
figure_polish;
set(gca, 'XDir', 'reverse'); % 反转Z轴
set(gca, 'ZDir', 'reverse'); % 反转Z轴
set(gca, 'YDir', 'reverse'); % 反转Z轴

figure(10);% 看强度 补偿后
scatter3(Depth_recovery,fast_array_point_recovery,slow_array_point_recovery,2, data_all(:,2), 'filled');hold on;xlabel('Depth/m');ylabel('Fast axis/m');zlabel('Slow axis/m');
xlim([8.30,8.41]);zlim([-0.72,-0.48]);ylim([-0.09,0.22]);caxis([0,3]);
colormap gray;colorbar;
figure_polish;
set(gca, 'XDir', 'reverse'); % 反转Z轴
set(gca, 'ZDir', 'reverse'); % 反转Z轴
set(gca, 'YDir', 'reverse'); % 反转Z轴


figure(11);
scatter3(output(:,3),output(:,1),output(:,2),2, output(:,4), 'filled');hold on;xlabel('Depth/m');ylabel('Fast axis/m');zlabel('Slow axis/m');
set(gca, 'XDir', 'reverse'); % 反转Z轴
set(gca, 'ZDir', 'reverse'); % 反转Z轴
set(gca, 'YDir', 'reverse'); % 反转Z轴
colormap gray;
colorbar;  % 添加颜色条
xlim([8.35,8.41]);zlim([-0.72,-0.48]);ylim([-0.09,0.22]);caxis([0,0.015]);
figure_polish; % title('Ground truth');

error_Depth_recovery=abs(Depth_recovery-output(:,3));
error_Depth_array_point=abs(Depth_array_point-output(:,3));

figure(12);% 未校正深度误差
scatter3(error_Depth_array_point,fast_array_point,slow_array_point,1, error_Depth_array_point, 'filled');hold on;
xlabel('Depth/m');ylabel('Fast axis/m');zlabel('Slow axis/m');caxis([0,0.05]);
zlim([-0.72,-0.48]);ylim([-0.09,0.22]);xlim([0,0.05]);
set(gca, 'XDir', 'reverse'); % 反转Z轴
set(gca, 'ZDir', 'reverse'); % 反转Z轴
set(gca, 'YDir', 'reverse'); % 反转Z轴
figure_polish;colorbar;
view(90,0);

figure(13);% 校正后深度误差
scatter3(error_Depth_recovery,fast_array_point_recovery,slow_array_point_recovery,1, error_Depth_recovery, 'filled');hold on;
xlabel('Depth/m');ylabel('Fast axis/m');zlabel('Slow axis/m');caxis([0,0.05]);
zlim([-0.72,-0.48]);ylim([-0.09,0.22]);xlim([0,0.05]);
set(gca, 'XDir', 'reverse'); % 反转Z轴
set(gca, 'ZDir', 'reverse'); % 反转Z轴
set(gca, 'YDir', 'reverse'); % 反转Z轴
figure_polish;colorbar;
view(90,0);

error_Depth_array_point_effect=error_Depth_array_point(error_Depth_array_point>-0.07 & error_Depth_array_point<0.03);
index_isnan2=isnan(error_Depth_array_point_effect);
error_Depth_array_point_not_NaN=error_Depth_array_point_effect(~index_isnan2);
STD_Depth_array_point=std(error_Depth_array_point_not_NaN);
fprintf('未补偿数据信号深度误差方差为：%3f m\n',STD_Depth_array_point);

error_Depth_recovery_effect=error_Depth_recovery(error_Depth_recovery>-0.07 & error_Depth_recovery<0.03);
index_isnan1=isnan(error_Depth_recovery_effect);
error_Depth_recovery_not_NaN=error_Depth_recovery_effect(~index_isnan1);
STD_Depth_recovery=std(error_Depth_recovery_not_NaN);
fprintf('补偿后数据信号深度误差方差为：%3f m\n',STD_Depth_recovery);

% 强度误差 data_all(:,2)是补偿数据，output_point(:,4)是未补偿数据，output(:,4)是真值
% 假如是点对点计算误差
flux_is_n_inf_index=~isinf(data_all(:,2));
mean_Ns_reco=mean(flux_is_n_inf_index);
mean_Ns=mean(output_point(flux_is_n_inf_index,4));
mean_Ns_low_flux=mean(output(flux_is_n_inf_index,4));
nor_Ns_reco=data_all(flux_is_n_inf_index,2)/mean_Ns_reco;
nor_Ns=output_point(flux_is_n_inf_index,4)/mean_Ns;
nor_GT=output(flux_is_n_inf_index,4)/mean_Ns_low_flux;
% nor_Ns_reco=sort(nor_Ns_reco);
% nor_Ns=sort(nor_Ns);
% nor_GT=sort(nor_GT);
figure(14);
plot(nor_Ns_reco,'-r');hold on;
plot(nor_Ns,'-b');hold on;
plot(nor_GT,'-k');hold on;
std_reco_flux=mean(abs(nor_Ns_reco-nor_GT));
std_flux=mean(abs(nor_Ns-nor_GT));

data1=[Depth_array_point(flux_is_n_inf_index) fast_array_point(flux_is_n_inf_index) slow_array_point(flux_is_n_inf_index) output_point(flux_is_n_inf_index,4)];% 未补偿
data2=[Depth_array_point fast_array_point slow_array_point output_point(:,4)];
[index1,index2,index3,index4,index5,index6]=data_region_segment(data1);
Depth_isn_inf=Depth_array_point(flux_is_n_inf_index);
fast_isn_inf=fast_array_point(flux_is_n_inf_index);
slow_is_n_inf=slow_array_point(flux_is_n_inf_index);
data1_is_n_inf=data1(flux_is_n_inf_index);
figure(15);
scatter3(Depth_isn_inf(index1),fast_isn_inf(index1),slow_is_n_inf(index1),1, nor_Ns(index1), 'filled');hold on;
scatter3(Depth_isn_inf(index2),fast_isn_inf(index2),slow_is_n_inf(index2),1, nor_Ns(index2), 'filled');hold on;
scatter3(Depth_isn_inf(index3),fast_isn_inf(index3),slow_is_n_inf(index3),1, nor_Ns(index3), 'filled');hold on;
scatter3(Depth_isn_inf(index4),fast_isn_inf(index4),slow_is_n_inf(index4),1, nor_Ns(index4), 'filled');hold on;
scatter3(Depth_isn_inf(index5),fast_isn_inf(index5),slow_is_n_inf(index5),1, nor_Ns(index5), 'filled');hold on;
scatter3(Depth_isn_inf(index6),fast_isn_inf(index6),slow_is_n_inf(index6),1, nor_Ns(index6), 'filled');hold on;
set(gca, 'XDir', 'reverse'); % 反转Z轴
set(gca, 'ZDir', 'reverse'); % 反转Z轴
set(gca, 'YDir', 'reverse'); % 反转Z轴
view(90,0);

mean_segment1_reco=mean(nor_Ns_reco(index1));
mean_segment2_reco=mean(nor_Ns_reco(index2));
mean_segment3_reco=mean(nor_Ns_reco(index3));
mean_segment4_reco=mean(nor_Ns_reco(index4));
mean_segment5_reco=mean(nor_Ns_reco(index5));
mean_segment6_reco=mean(nor_Ns_reco(index6));
max_segment_reco=max([mean_segment1_reco mean_segment2_reco mean_segment3_reco mean_segment4_reco mean_segment5_reco mean_segment6_reco]);

mean_segment1=mean(nor_Ns(index1));
mean_segment2=mean(nor_Ns(index2));
mean_segment3=mean(nor_Ns(index3));
mean_segment4=mean(nor_Ns(index4));
mean_segment5=mean(nor_Ns(index5));
mean_segment6=mean(nor_Ns(index6));
max_segment=max([mean_segment1 mean_segment2 mean_segment3 mean_segment4 mean_segment5 mean_segment6]);

mean_segment1_truth=mean(nor_GT(index1));
mean_segment2_truth=mean(nor_GT(index2));
mean_segment3_truth=mean(nor_GT(index3));
mean_segment4_truth=mean(nor_GT(index4));
mean_segment5_truth=mean(nor_GT(index5));
mean_segment6_truth=mean(nor_GT(index6));
max_segment_truth=max([mean_segment2_truth mean_segment1_truth  mean_segment3_truth mean_segment4_truth mean_segment5_truth mean_segment6_truth]);
a1=[mean_segment2_reco  mean_segment1_reco   mean_segment4_reco  mean_segment3_reco  mean_segment6_reco  mean_segment5_reco  ]./max_segment_reco;
a2=[mean_segment2       mean_segment1        mean_segment4       mean_segment3       mean_segment6       mean_segment5  ]./max_segment;
a3=[mean_segment2_truth mean_segment1_truth  mean_segment4_truth mean_segment3_truth mean_segment6_truth mean_segment5_truth  ]./max_segment_truth;
figure(16);
plot(abs(a1-a3),'-r*');hold on;
plot(abs(a2-a3),'-bo');hold on;
ylim([0,0.7]);
xlabel('Block order');ylabel('Normalized flux error');
legend('Corrected','Uncorrected');
figure_polish1();
std_a1_a3=std(a1-a3);
std_a2_a3=std(a2-a3);
fprintf('未补偿数据信号通量方差为：%3f\n',std_a2_a3);
fprintf('补偿后数据信号通量方差为：%3f\n',std_a1_a3);


[index_1,index_2,index_3,index_4,index_5,index_6]=data_region_segment(data2);
% 绘制深度图
error_depth_block_recovery=[mean(error_Depth_recovery(index_2&flux_is_n_inf_index)),mean(error_Depth_recovery(index_1&flux_is_n_inf_index)),mean(error_Depth_recovery(index_4&flux_is_n_inf_index)),mean(error_Depth_recovery(index_3&flux_is_n_inf_index)),mean(error_Depth_recovery(index_6&flux_is_n_inf_index)),mean(error_Depth_recovery(index_5&flux_is_n_inf_index))];
error_depth_block=[mean(error_Depth_array_point(index_2&flux_is_n_inf_index)),mean(error_Depth_array_point(index_1&flux_is_n_inf_index)),mean(error_Depth_array_point(index_4&flux_is_n_inf_index)),mean(error_Depth_array_point(index_3&flux_is_n_inf_index)),mean(error_Depth_array_point(index_6&flux_is_n_inf_index)),mean(error_Depth_array_point(index_5&flux_is_n_inf_index))];
figure(17);
plot(error_depth_block_recovery,'r-*');hold on;
plot(error_depth_block,'b-o');hold on;
ylim([0,0.03]);
xlabel('Block order');ylabel('Depth error');
figure_polish1();
legend('Corrected','Uncorrected');

% data2=[Depth_recovery,fast_array_point_recovery,slow_array_point_recovery,data_all(:,2)]; % 补偿后
% [segment1,segment2,segment3,segment4,segment5,segment6]=data_region_segment(data1);




function figure_polish()
    grid on;
    set(gcf, 'Position', [200, 300, 350, 150]); % 例如，左下角坐标为 (300, 300)，宽度为 800，高度为 600
    view(90,0);
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
    set(gca, 'Color', 'black');
    % ax.XMinorGrid='on';
    % ax.YMinorGrid='on';
end

function [index1,index2,index3,index4,index5,index6]=data_region_segment(data)
    % seg_index1=[x_low_lim,x_high_lim;y_low_lim,y_high_lim;z_low_lim,z_high_lim];
    % data=[x;y;z];
    seg_index1=[8.35 8.41; 0.11 0.18;-0.68 -0.61];
    seg_index2=[8.35 8.41;0.11 0.18;-0.58 -0.5];
    seg_index3=[8.35 8.41;0.03 0.1;-0.68 -0.61];
    seg_index4=[8.35 8.41;0.03 0.1;-0.58 -0.5];
    seg_index5=[8.35 8.41;-0.05 0.02;-0.68 -0.61];
    seg_index6=[8.35 8.41;-0.05 0.02;-0.58 -0.5];
    index1=data(:,1)>seg_index1(1,1) & data(:,1)<seg_index1(1,2) & data(:,2)>seg_index1(2,1) & data(:,2)<seg_index1(2,2) & data(:,3)>seg_index1(3,1) & data(:,3)<seg_index1(3,2);
    index2=data(:,1)>seg_index2(1,1) & data(:,1)<seg_index2(1,2) & data(:,2)>seg_index2(2,1) & data(:,2)<seg_index2(2,2) & data(:,3)>seg_index2(3,1) & data(:,3)<seg_index2(3,2);
    index3=data(:,1)>seg_index3(1,1) & data(:,1)<seg_index3(1,2) & data(:,2)>seg_index3(2,1) & data(:,2)<seg_index3(2,2) & data(:,3)>seg_index3(3,1) & data(:,3)<seg_index3(3,2);
    index4=data(:,1)>seg_index4(1,1) & data(:,1)<seg_index4(1,2) & data(:,2)>seg_index4(2,1) & data(:,2)<seg_index4(2,2) & data(:,3)>seg_index4(3,1) & data(:,3)<seg_index4(3,2);
    index5=data(:,1)>seg_index5(1,1) & data(:,1)<seg_index5(1,2) & data(:,2)>seg_index5(2,1) & data(:,2)<seg_index5(2,2) & data(:,3)>seg_index5(3,1) & data(:,3)<seg_index5(3,2);
    index6=data(:,1)>seg_index6(1,1) & data(:,1)<seg_index6(1,2) & data(:,2)>seg_index6(2,1) & data(:,2)<seg_index6(2,2) & data(:,3)>seg_index6(3,1) & data(:,3)<seg_index6(3,2);
end

function figure_polish1()
    grid on;
    set(gcf, 'Position', [200, 300, 250, 160]); % 例如，左下角坐标为 (300, 300)，宽度为 800，高度为 600
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
    % ax.XMinorGrid='on';
    % ax.YMinorGrid='on';
end
function [selected_points]=random_sel(A,n)
    indices = randperm(length(A), n);
    selected_points = A(indices);
end
