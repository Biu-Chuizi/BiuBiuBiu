function [Feature, bmp, flag]=getFeature(A)
A=ones(64)-A;
[x,y]=find(A==1);

A = A (min(x):max(x), min(y):max(y)); 

flag = (max(y)-min(y)+1) / (max(x)-min(x)+1);
if flag < 0.5 
    flag=0; 
elseif flag >=0.5 &&flag <0.75 
    flag=1; 
elseif flag >=0.75 && flag <1 
    flag=2;
else flag=3; 
end

rate=64 / max(size(A)); % rate 
A = imresize (A, rate); 
[x, y] = size(A); %7 64 

if x ~=64 
    A = [zeros(ceil((64-x)/2)-1, y); A; zeros(floor((64-x)/2)+1, y)]; 
end;
if y ~= 64 
    A=[zeros(64, ceil((64-y)/2)-1),A, zeros(64, floor((64-y)/2)+1)];
end
%% 特征提取， 三竖三横俩对角线；四方块俩中心贯穿块
Vc=32;
F(1)= sum(A(:,Vc)); 

Vc = round(64/4);
F(2) =sum(A(:,Vc));

Vc= round(64*3/4);
F(3)=sum(A(:, Vc));

Hc= 32;
F(4)= sum(A(Hc,:));

Hc=round(64/3);
F(5)=sum(A(Hc,:));

Hc = round(2*64/3); 
F(6)=sum(A(Hc,:));

F(7)=sum(diag(A));

F(8)=sum(diag(rot90(A)));

t = A(33:64, 33:64);
F(9)=sum(t(:))/10;  

t=A(1:32, 1:32);
F(10)=sum(t(:))/10; 

t=A(1:32, 33:64);
F(11)=sum(t(:))/10;

t= A(33:64, 1:32);  
F(12)=sum(t(:))/10;

t=A(1:64, 17:48); 
F(13)=sum(t(:))/20; 

t=A(17:48,1:64); 
F(14)=sum(t(:))/20; 

Feature= F'; 
bmp =A;
