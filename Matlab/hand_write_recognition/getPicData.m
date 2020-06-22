function I = getPicData()
I=zeros(64,64,1000);
k=1;

for i =1:10
    for j=1:100
        file=sprintf('digital_pic\\%d_%03d.bmp', i-1, j);
        I(:,:,k)=imread(file);
        
        k=k+1;
    end
end

