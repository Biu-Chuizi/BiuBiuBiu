x=-5:5;
y=3*x-7;
randn('state',2);
y=y+randn(1,length(y))*1.5;
plot(x,y,'o');
P=x;T=y;
net=newlin(P,T);
new_x=-5:.2:5;
new_y=sim(net,new_x);
hold on; plot(new_x,new_y);
legend('Oringinal','Least Mean Square');

