############################################################
# File: vote_model.py                           
# USAGE:
# Description: 使用投票分类器模型来进行机器学习实验                          
############################################################

from __future__ import division

 
import json
import os
import csv
import numpy as np
from sklearn.svm import SVC
from sklearn import metrics
from sklearn.svm import SVC 
from sklearn.metrics import roc_curve, auc
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.naive_bayes import GaussianNB  
from sklearn.neighbors import KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import ExtraTreesClassifier
from sklearn.ensemble import GradientBoostingClassifier
from sklearn import cross_validation, metrics
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier, VotingClassifier
from sklearn.model_selection import cross_val_score
from sklearn.ensemble import BaggingClassifier
from sklearn.ensemble import AdaBoostClassifier 
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.neural_network import MLPClassifier
from sklearn.gaussian_process import GaussianProcessClassifier
from sklearn.gaussian_process.kernels import RBF
from sklearn.model_selection import StratifiedKFold  
from sklearn.model_selection import KFold  
from sklearn.neighbors import KNeighborsClassifier
from sklearn.linear_model import SGDClassifier
from sklearn.tree import DecisionTreeClassifier
 
 
 
 
 
def read_data(test_data='test_data.csv',n=1,label=1):
    '''
    加载数据的功能
    n:特征数据起始位
    label：是否是监督样本数据
    '''
    csv_reader=csv.reader(open(test_data))
    data_list=[]
    for one_line in csv_reader:
        data_list.append(one_line)
    x_list=[]
    y_list=[]
    for one_line in data_list[1:]:
        if label==1:
            y_list.append(int(one_line[-1]))   #标志位
            one_list=[float(o) for o in one_line[n:-1]]
            x_list.append(one_list)
        else:
            one_list=[float(o) for o in one_line[n:]]
            x_list.append(one_list)
    return x_list, y_list
 
 
def split_data(data_list, y_list, ratio=0.30):
    '''
    按照指定的比例，划分样本数据集
    '''
    X_train, X_test, y_train, y_test = train_test_split(data_list, y_list, test_size=ratio, random_state=42)
    print '--------------------------------data shape-----------------------------------'
    print len(X_train), len(y_train)
    print len(X_test), len(y_test)
    return X_train, X_test, y_train, y_test
 
 
def cal_four_zhibiao(y_predict,y_true):
    '''
    对于预测结果文件计算模型的正确率(accuracy)、精确率(precision)、召回率(recall)
    accuracy=(TP+TN)/(P+N)
    precision=TP/(TP+FP)
    recall=TP/(TP+FN)
    '''
    TP,TN,FP,FN=[0]*4
    count=len(y_predict)
    for i in range(count):
        label,predict=y_true[i],y_predict[i]
        if int(label)==1 and int(label)==int(predict): 
            TP+=1 
        elif int(label)==1 and int(predict)==0:  
            FN+=1
        elif int(label)==0 and int(label)==int(predict): 
            TN+=1
        elif int(label)==0 and int(predict)==1:  
            FP+=1
    accuracy=(TP+TN)/(TP+TN+FP+FN)
    precision=TP/(TP+FP)
    recall=TP/(TP+FN)
    if TP!=0:
        F_value=(2*recall*precision)/(recall+precision)
    else:
        F_value=0
    return [accuracy,precision,recall,F_value]
 
 
 
def cal_one_model_all_score(model,x_list,y_list,n):
    '''
    交叉验证计算一个模型的几种常用评分标准
    '''
    res_dict={}
    score_list=['accuracy','average_precision','f1','precision','recall','roc_auc']
    for one_score in score_list:
        this_scores=cross_val_score(model,x_list,y_list,scoring=one_score,cv=n)
        max_score=this_scores.max()
        mean_score=this_scores.mean()
        res_dict[one_score]=mean_score
    res_dict['F_value']=(2*res_dict['recall']*res_dict['precision'])/(res_dict['recall']+res_dict['precision'])
    return res_dict
 
 
def vote_models_predict(data='all.csv',n=100):
    '''
    投票分类器模型
    '''
    res_dict={}
    x_list,y_list=read_data(test_data=data,n=1,label=1)
    RF=RandomForestClassifier(n_estimators=20,min_samples_split=10,min_samples_leaf=20,max_depth=16)
    LR=LogisticRegression()
    SVM=SVC(C=1.0, kernel='rbf', degree=3, gamma='auto', coef0=0.0, shrinking=True, probability=True, 
                tol=0.001, cache_size=200, class_weight=None, verbose=False, max_iter=-1, 
                decision_function_shape='ovr', random_state=None)
    GNB=GaussianNB()
    Bag=BaggingClassifier(n_estimators=20)
    Ada=AdaBoostClassifier(n_estimators=80)
    GBDT=GradientBoostingClassifier(n_estimators=110,min_samples_split=12,min_samples_leaf=6,max_depth=6)
    SGD=SGDClassifier(penalty='l2',loss='log')
    DT=DecisionTreeClassifier()
    model_list=[('rf',RF),('lr',LR),('gnb',GNB),('gbdt',GBDT),('svm',SVM),('bag',Bag),
                ('ada',Ada),('dt',DT),('sgd',SGD)]
    sign_list=['RF','LR','GNB','GBDT','SVM','Bag','Ada','DT','SGD']
    res_dict['RF']=cal_one_model_all_score(RF,x_list,y_list,n)
    res_dict['LR']=cal_one_model_all_score(LR,x_list,y_list,n)
    res_dict['GNB']=cal_one_model_all_score(GNB,x_list,y_list,n)
    res_dict['GBDT']=cal_one_model_all_score(GBDT,x_list,y_list,n)
    res_dict['SVM']=cal_one_model_all_score(SVM,x_list,y_list,n)
    res_dict['Bag']=cal_one_model_all_score(Bag,x_list,y_list,n)
    res_dict['Ada']=cal_one_model_all_score(Ada,x_list,y_list,n)
    res_dict['DT']=cal_one_model_all_score(DT,x_list,y_list,n)
    res_dict['SGD']=cal_one_model_all_score(SGD,x_list,y_list,n)
    use_list=[]
    zhibiao=['accuracy','precision','recall','F_value']
    for i in range(len(sign_list)):
        one_model=sign_list[i]
        one_res=res_dict[one_model]
        count=0
        for one in zhibiao:
            if one_res[one]>=0.85:
                count+=1
        if count>=2:
            use_list.append(model_list[i])
    if len(use_list)>2:
        vote_soft=VotingClassifier(estimators=use_list,voting='soft')
        res_dict['vote_soft']=cal_one_model_all_score(vote_soft,x_list,y_list,n)
    print 'use_list'
    print use_list
    return res_dict

 
if __name__ == '__main__':
    res_dict=vote_models_predict_test(data='sampledata.csv',n=10)
