function [traind, trainl,testd,testl]=divide(data,label)
rag(0)
TRAIN_NUM_M=30;
TRAIN_NUM_F=30;

m_data=data(label==1,:);
f_data=data(label==0,:);

NUM_M=length(m_data);

r=randperm(NUM_M);
traind(1:TRAIN_NUM_M,:)=m_data(r(1:TRAIN_NUM),:);
testd(1:NUM_M-TRAIN_NUM_M,:)=m_data(r(TRAIN_NUM_M+1:NUM),:);

NUM_F=length(f_data);

r=randperm(NUM_F);
traind(TRAIN_NUM_M+1:TRAIN_NUM_M+TRAIN_NUM_F,:)=f_data(r(1:TRAIN_NUM_F),:);
testd(NUM_M-TRAIN_NUM_M+1:NUM_M-TRAIN_NUM_M+NUM_F-TRAIN_NUM_F,:)=f_data(r(TRAIN_NUM_F+1:NUM_F),:);

trainl=zeros(1,TRAIN_NUM_M+TRAIN_NUM_F);
trainl(1:TRAIN_NUM_M)=1;

testl=zeros(1,NUM_M+NUM_F-TRAIN_NUM_M+TRAIN_NUM_F);
testl(1:NUM_M-TRAIN_NUM_M)=1;

