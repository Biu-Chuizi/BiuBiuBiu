clear all; clc;

xlsfile='student.xls';
[data,label]=getdata(xlsfile);

[traind,trainl,testd,testl]=divide(data,label);

rng('default');
rng(0)
nTtainNum=60;
nSamDim=2;

net.nIn=2;
net.nHidden=3;
net.nOut=1;

w=2*(rand(net.nHidden,net.nIn)-1/2);
b=2*(rand(net.nHidden,1)-1/2);
net.w1=[w,b];

mm=mean(traind);
for i=1:2
    traind_s(:,i)=traind(:,i)-mm(i);
end

ml(1)=std(traind_s(:,1));
ml(2)=std(traind_s(:, 2));
for i=1:2 
    traind_s(:,1)=traind_s(:,i)/ml(i) 
end

SampInEx=[traind_s';ones(1, nTrainNum)] 
expectedOut=trainl;
eb =0.01; 
eta= 0.6;
mo =0.8; 
maxiter= 2000; 
iteration =0; 

errRec=zeros(1, maxiter);
outRec= zeros(nTrainNum, maxiter); 
NET=[];
for i=1: maxiter 
    hid_input=net.wl*SampInEx; 
    hid_out=logsig(hid_input); 
    
    ou_input1=[hid_out; ones(1, nTrainNum)];
    ou_input2=net.w2 *ou_input1; 
    out_out=logsig(ou_input2);
    
    outRec(:,i)=out_out';
    
    err=expectedOut-out_out;
    sse= sumsqr(err); 
    errRec(i)=sse;
    fprintf('?%d??? ??: %f\n', i, sse);
    iteration=iteration +1; 
    
    if ssec<=eb 
        break 
    end
    DELTA=err.*dlogsig(ou_input2, out_out); 
    delta= net.w2(:,1: end-1)' * DELTA.*dlogsig(hid_input, hid_out);
    
    dWEX =DELTA*ou_input1'; 
    dwex =delta*SampInEx';
    
    if i==1
        net.w2=net.w2+ eta* dWEX;
        net.wl=net.wl+ eta* dwex;
    else
        net.w2=net.w2+(1- mc) *eta *dWEX+ mc *dWEXO1d;
        net.wl= net.wl +(1 - mc) *eta*dwex + mc *dwexOld; 
    end
    
    dWEXOld = dWEX; 
    dwexOld = dwex; 
end

for i=1:2 
    testd_s(:,i) =testd(:, i) -mm (i); 
end

for i=1:2
    testd_s( : , i) =testd_s (:, i)/ml(i); 
end

InEx=[testd_s'; ones(1,260-nTrainNum)];
hid_input = net.w1*InEx; 
hid_out = logsig (hid_input); 
ou_input1= [hid_out; ones(1,260-nTrainNum)];
ou_input2 =net.w2*ou_input1;
out_out=logsig(ou_input2);
out_out1=out_out; 

out_out(out_out<0.5) =0;
out_out (out_out>= 0.5)=1; 

rate=sum(out_out==testl)/length(out_out);  

train_m = traind (trainl==1,:);
train_m=train_m'; 

train_f = traind(trainl==0,:);
train_f=train_f'; 

figure(1) 
plot(train_m(1,:), train_m(2, :), 'bo');
hold on; 
plot(train_f(1,:), train_f (2, : ), 'r*'); 
xlabel ('??') 
ylabel ('??') 
title ( ' ??????');
legend ('?? ', '??') 

figure(2) 
axis on 
hold on
grid
[nRow, nCol] = size (errRec);
plot (1:nCol, errRec, ' b-', 'LineWidth' , 1.5) 
legend ('?????')
xlabel ('????',' FontName' , 'Times ', 'FontSize', 10);
ylabel ('??')
fprintf('-----------?????--------------\n')
fprintf('?? ??  ??  ??\n')
ind=find(out_out ~=test1);
for i=1:length(ind)
    fprintf('%4d %4d %f %f\n', ind(i), test1(ind(i)), testd(ind(i),1),testd(ind(i),2));
end

fprintf('??????\n %d\n', iteration);
fprintf('???:\n %f%%\n', rate*100);