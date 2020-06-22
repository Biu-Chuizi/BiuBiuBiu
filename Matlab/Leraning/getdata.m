function [data, label]=getdata(xlsfile)

[~, label]=xlsread(xlsfile, 1, 'B2:B247');
[height, ~]= xlsread(xlsfile, 'C2:C247');
[weight,~]=xlsread(xlsfile,'D2:D247');

data=[height, weight];
L=zeros(size(label));
for i=1:length(1)
    if label{i}=='?'
        L(i)=1;
    end
end
label=L;