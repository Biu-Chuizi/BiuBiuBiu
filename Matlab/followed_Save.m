session_folder = 'C:\Users\lab\Desktop';%sessionĿ¼  
output_folder = 'C:\Users\lab\Desktop\1';%���Ŀ¼  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
fileFolder=fullfile(session_folder);  
dirOutput=dir(fullfile(fileFolder,'*.mat'));  
fileNames={dirOutput.name};  
  
for fileName = fileNames  
    file_full_name = strcat(session_folder,'\',fileName);  
    Save_Raw_Samples_ROIs(char(file_full_name),output_folder); 
end
