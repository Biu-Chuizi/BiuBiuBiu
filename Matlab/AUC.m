clear;close all;
% x=0:10:100;%x轴上的数据，第一个值代表数据开始，第二个值代表间隔，第三个值代表终止
% y=0:10:100;
% data = load("data.txt");
% X = data(:,1);
% Y = data(:,2);
a=[100,94.2,92.3,88.5,84.6,75.0,71.2,69.2,67.3,61.5,0]; %a数据y值
b=[0,92.2,95.6,97.2,98.0,98.4,98.9,99.3,99.5,99.8,100]; %b数据y值
% plot(x,a,'-*b',x,b,'-..r'); %线性，颜色，标记
% plot(x,a,'-*b',y,b,'-*b'); %线性，颜色，标记
% plot(100-b,a,'-*r');
% axis([0,100,0,100])  %确定x轴与y轴框图大小
% set(gca,'XTick',[0:10:100]) %x轴范围
% set(gca,'YTick',[0:10:100]) %y轴范围
% % legend('Neo4j','MongoDB');   %右上角标注
% xlabel('1-specificity')  %x轴坐标描述
% ylabel('sensitivity') %y轴坐标描述

% x = 1:100;
% y = sin(2*pi*x/100);
% for i = 1:100
s_auc=trapz(100-a,b)/(100*100);
figure;
plot(100-a,b,'-b','Marker','*','MarkerEdgeColor','r')
% ,'MarkerFaceColor','b');
% [0.99,0,0.01]);
% 'MarkerFaceColor',[(100-i)/100,0,i/100]);
     
hold on;
axis([0,100,0,100])  %确定x轴与y轴框图大小
set(gca,'XTick',[0:10:100]) %x轴范围
set(gca,'YTick',[0:10:100]) %y轴范围
legend('AUC=0.962');   %右上角标注
xlabel('1-specificity')  %x轴坐标描述
ylabel('sensitivity') %y轴坐标描述
% print('Figure 1', '-djpeg','-r300'); 打印高清图片
% end