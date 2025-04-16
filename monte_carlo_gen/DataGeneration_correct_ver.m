close all;clc;clear;

Ns_mat=0.025:0.025:20                    ;% �źŹ�����    0.1
for i=1:length(Ns_mat)
    p_from_Ns=1-exp(-Ns_mat(i));
    fn=200*10^3 ;% ������        �ɵ�
    laser_frequence=3.125*10^6/4       ;% ������Ƶ 3.125e6/4
    Ns=Ns_mat(i);
    f=0.016                   ;% �����ֱ���    25ps
    Ts=200  ;% ��������ʱ�� ��λns
    Tt=0.0002           ;% �ۼ�ʱ��      �ɵ�

    %t=0:0.025:(4000)*0.025;
    [Ns_all,theta_s_all,Ts_all]=multi_guass_5(Ns);

    [t_TDC,s_TDC]=multiguass_DG(Tt,laser_frequence, fn, Ns_all, f, theta_s_all, Ts,Ts_all);
    figure(3);
    scatter(t_TDC,s_TDC*f);
    s_TDC(s_TDC*f>3*1280/4)=s_TDC(s_TDC*f>3*1280/4)-round(3*1280/4/f);
    s_TDC(s_TDC*f>2*1280/4)=s_TDC(s_TDC*f>2*1280/4)-round(2*1280/4/f);
    s_TDC(s_TDC*f>1280/4)=s_TDC(s_TDC*f>1280/4)-round(1280/4/f);
%     s_TDC(s_TDC*f>2500)=s_TDC(s_TDC*f>2500)-2500/f;
%     index=s_TDC<800/0.025;
%     s_TDC=s_TDC(index);
%     t_TDC=t_TDC(index);
    figure(1);
    scatter(t_TDC,f*s_TDC,'.');xlabel('ʱ��/s');ylabel('����ʱ��/ns');
    [num_t,num]=his_fig_plot(s_TDC,f);
    figure(2);
    plot(num_t,num);
    
    name=['fn_',num2str(fn/1000),'k_Ns_', num2str(Ns),'.mat'];
    save(name,'s_TDC','t_TDC');
    clearvars t_TDC s_TDC;
end

function [time,TIME]=multiguass_DG(Tt,laser_frequence, fn, Ns_all, f, theta_s_all, Ts,Ts_all)
    % ϵͳ����
    N=Tt*laser_frequence             ;% �ظ�����
    td=1200                            ;% ����ʱ��      77ns
    %PHW=3                            ;% �����߿�,��λΪns
    c=3*10^8                         ;% ����
    % ����ʱ�����
    % ������ѧ��ʽ����
    start=-td*10^-9                  ;
    time=[];
    TIME=[];

    for i=1:N
        % �����źź��������ӣ����������Ӳ��ɷֲ�
        nev(1)=random('Poisson',Ns_all(1));                           %���ɷֲ�
        nev(2)=random('Poisson',Ns_all(2));                           %���ɷֲ�
        nev(3)=random('Poisson',Ns_all(3));                           %���ɷֲ�
        nev(4)=random('Poisson',Ns_all(4));                           %���ɷֲ�
        noise=random('Poisson',fn/laser_frequence);

        if (sum(nev)==0)&&(noise==0) 
            continue;         
        end
         % �������ӵ���ʱ�̷��Ӿ��ȷֲ����źŹ��ӵ���ʱ�̷��Ӹ�˹�ֲ�
        if noise~=0
            NOISE=unifrnd(0,1/laser_frequence*1e9,1,noise);     %���ȷֲ�,����Ϊ��0.1/laser_frequence-0��^2/12
        else
            NOISE=[];
        end
        tn=[];
        for index=1:length(nev)
            if nev(index)~=0
                tn1=normrnd(Ts+Ts_all(index),theta_s_all(index),1,nev(index));  
                tn=[tn,tn1];
            end
        end

        T=sort([tn,NOISE]);
        NEV=sum(nev)+noise;
        % �źŹ��Ӻ��������Ӻϲ��󣬵���ʱ�̷�0ʱ���б��Ƿ�Ϊ��Ч�㣨�������������ڣ�Ϊ��Ч�㣩
        % ��Ч�����T�У����������ΪC

        Index_zheng=find(T>0,1);
        for m=Index_zheng:NEV
            if (T(m)*10^-9+(i-1)*1.0/laser_frequence-start)>=td*10^-9  % �����ź�ǰ�벿�֣�����ʱ���б𣬽���һ���ںͱ���������Ӱ����м��㡣
                start=T(m)*10^-9+(i-1)*1.0/laser_frequence;
            else
                T(m)=0;
            end
        end
        C=sort(T);
        D=C(C>0);

        DT=D*10^-9+(i-1)*1/laser_frequence;
        time=[time,DT];
        TIME=[TIME,D];
    end
    TIME=round(TIME/f); % ��λbin
end


function [num_t,num]=his_fig_plot(y,f)
    scatter_y=y(y>0);
    y_max=max(scatter_y+1);
    
    num=zeros(y_max,1);
    for i=1:length(scatter_y)
        num(scatter_y(i))=num(scatter_y(i))+1;
    end
    num_t=f*(1:y_max)';
%     figure(1);
%     subplot(2,1,2);
%     bar(num_t,num);title('��״ͼģʽ');xlabel('�������ʱ��/ns');ylabel('count');set(0,'defaultfigurecolor','w');grid on;
end

function [Ns_all,theta_s_all,Ts_all]=multi_guass_5(Ns_measurement)
% ������̽�� 20240122-1
    a1 =1;    a2 =   1;          a3 = 1;          a4= 1;
    b1 =10;   b2 =  10+320;  b3 = 10+640; b4=10+960;
    c1 =0.5563;  c2 =  0.5563;         c3 =0.5563 ;       c4=0.5563;

    Ns1=a1*c1*pi^0.5;Ts1=b1;theta_s1=c1/1.414213562373095;
    Ns2=a2*c2*pi^0.5;Ts2=b2;theta_s2=c2/1.414213562373095;
    Ns3=a3*c3*pi^0.5;Ts3=b3;theta_s3=c3/1.414213562373095;
    Ns4=a4*c4*pi^0.5;Ts4=b4;theta_s4=c4/1.414213562373095;
    Ns=Ns1+Ns2+Ns3+Ns4;% Ns��ʵ���ǶԸ�˹���������ܶȺ������ֵõ���ֵ
    Ns_scale_factor=Ns_measurement/Ns;
    Ns1=Ns_scale_factor*Ns1;
    Ns2=Ns_scale_factor*Ns2;
    Ns3=Ns_scale_factor*Ns3;
    Ns4=Ns_scale_factor*Ns4;
    Ns_all=[Ns1 Ns2 Ns3 Ns4];
    theta_s_all=[theta_s1 theta_s2 theta_s3 theta_s4];
    Ts_all=[Ts1 Ts2 Ts3 Ts4];
end


