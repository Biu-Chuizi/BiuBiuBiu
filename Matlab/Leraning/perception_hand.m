% perception_hand.m
clear; close all
n=0.02;
w=[0,0,0];
P=[-9, 1, -12, -4, 0, 5; 15, -8, 4 ,5, 11, 9];
d=[0,1,0,0,0,1];
P=[ones(1,6); P];
MAX=200;

i=0;
while 1
    v=w*P;
    y=hardlim(v);
%     update
    e=(d-y);
    ee(i+1)=mae(e);
    if (ee(i+1)<0.001)
        disp('Yes, we got it:');
        disp(w);
        break;
    end
    w=w+n*(d-y)*P';
    i=i+1;
    if (i>=MAX)
        disp('Max time loop');
        disp(w);
        disp(ee(i+1));
        break
    end
end

figure;
subplot(2,1,1);
plot([-9 -12 -4 0], [15 4 5 11],'o');
hold on;
plot([1,5],[-8,9],'*');
axis([-13,6,-10,16]);
legend('First', 'Second');
title('double classification');
x=-13:.3:6;
y=x*(-w(2)/w(3))-w(1)/w(3);
plot(x,y);
hold off;

subplot(2,1,2);
x=0:i;
plot(x,ee,'-o');
s=sprintf('s` value:',i+1);
title(s)

    
        