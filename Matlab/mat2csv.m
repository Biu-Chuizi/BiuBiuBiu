datafold = 'C:\Users\lab\Downloads\training\';
files = dir([datafold,'*.','mat']);
len = length(files);
for i = 1:len
    filePath = [datafold,files(i).name]; 
    file_name1 = files(i).name;
    a = split(file_name1,'.');
    file_name2 = a{1}; 
    file_name3 = strcat([ 'C:\Users\lab\Downloads\11\',file_name2],'.csv');
    file = load(filePath);
    csvwrite(file_name3,file.val);
end
    



