close all; clear; clc
maindir = 'E:\a';
subdir  = dir( maindir );

for i = 1 : length( subdir )
    if( isequal( subdir( i ).name, '.' )||...
        isequal( subdir( i ).name, '..')||...
        ~subdir( i ).isdir)               % 如果不是目录则跳过
        continue;
    end
    subdirpath = fullfile( maindir, subdir( i ).name, '*.MTS' );
    dat = dir( subdirpath )               % 子文件夹下找后缀为dat的文件

    for j = 1 : length( dat )
        
        old_name = fullfile( maindir, subdir( i ).name, dat( j ).name);
        new_name = strsplit(old_name, '.');
        new_name = new_name{1,1};
        EX = strsplit(new_name,'\');
        EX = EX{1,end};
        new_name = ['!rename', new_name,'_', EX, '.MTS');
        eval(new_name)
        % 此处添加你的对文件读写操作 %
    end
end