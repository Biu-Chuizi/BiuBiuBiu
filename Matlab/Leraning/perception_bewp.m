% perception_newp.m
clear,close all

net=newp([-20,20;-20,20],1);

P=[-9, 1, -12, -4, 0, 5; 15, -8, 4 ,5, 11, 9];
T=[0,1,0,0,0,1];
net=train(net,P,T);
Y=sim(net, P);
