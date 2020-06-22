pgms = dir('C:\Users\Joe\Desktop\0209\0\*.tiff');
num_pgms = length( pgms );
for a = 1 : num_pgms
  tiff_file = fullfile( 'C:\Users\Joe\Desktop\0209\0\' , pgms(a).name );
  pgm      = imread( tiff_file );
  [rows , cols , colors] = size(pgm);%得到原来图像的矩阵的参数
  MidGrayPic = zeros(rows , cols);%用得到的参数创建一个全零的矩阵，这个矩阵用来存储用下面的方法产生的灰度图像
  MidGrayPic = uint8(MidGrayPic);%将创建的全零矩阵转化为uint8格式，因为用上面的语句创建之后图像是double型的
  for i = 1:rows
    for j = 1:cols
        sum = 0;
        for k = 1:colors
            sum = sum + pgm(i , j , k) / 3;%进行转化的关键公式，sum每次都因为后面的数字而不能超过255
        end
        MidGrayPic(i , j) = sum;
    end
  end
  % [ path , name , ext ] = fileparts( MidGrayPic );
  %   
  % %     %第三步，生成文件全称
  %    imwrite( MidGrayPic , png_file , 'png' );
  % 
  [path, name, ext] = fileparts(pgms(a).name);  
  filename = strcat( name , '.png' );
  png_file = fullfile( 'C:\Users\Joe\Desktop\新建文件夹\0\' ,filename ) ;
  imwrite(MidGrayPic , png_file , 'png');
end