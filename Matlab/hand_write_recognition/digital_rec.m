clear, clc
close all
disp('开始读取图片...'); 
I=getPicData(); 

x0=zeros(14, 1000); 
disp('开始特征提取') 
for i=1:1000 
    tmp=medfilt2(I(:,:,i), [3,3]);
    t= getFeature(tmp);
    x0(:,i)=t(:);
end

label=1:10;
label= repmat(1abel, 100, 1);
label= label(:);

%% nn net
tic 
spread=.1;
[x, se]=mapminmax(x0);

net= newpnn(x, ind2vec(label'), spread);
ti=toc;
fprintf('模型建立耗时： %f sec\n', ti);

lab0=net(x);
lab= vec2ind(lab0);
rate= sum(label == lab')/length (label);
fprintf('test accuracy\n %d%%\n', round(rate*100));

Il=I;
nois= 0.4;
fea0= zeros(14, 1000);
for i=1:1000
    tmp=I1(:,:,1);
    tmp=imnoise(double(tmp), 'salt & pepper',nois);
%     tmp=imnoise(double (tmp), 'gaussian ' , 0 , 0.15) ; 
    tmp= medfilt2(tmp, [3, 3]);
    t= getFeature(tmp);
    fea0(:,i)= t(:);
end

fea= mapminmax( 'apply', fea0, se); 
tlab0= net(fea); 
tlab=vec2ind(tlab0); 

rat=sum(tlab'==label) / length(tlab); 
fprintf('The accuracy with noise: \n %d%%\n ', round(rat*100));
