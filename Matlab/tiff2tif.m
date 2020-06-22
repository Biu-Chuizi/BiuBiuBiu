% 将pgm图片批量转换为jpg图片
function [  ] = tiff2jpg(  )
 % 读取指定目录下面所有的pgm格式图片
 pgms = dir('F:\1\*.tiff');
 num_pgms = length( pgms );
%  for i = 1 : num_pgms
   tiff_file = fullfile( 'F:\1' , pgms(1).name );
%    pgm = imread( tiff_file );
   
   % 转换为 jpg 格式
   %第一步，解析文件名
   [ path , name , ext ] = fileparts( tiff_file ) ;
   %第二步，生成新的文件名
   filename = strcat( name , '.jpg' );
   %第三步，生成文件全称
   tif_file = fullfile('F:\1')%tif_file = fullfile( 'F:\1' , filename ) ;
%    imwrite(filename,'.jpg');%
   imwrite( filename, tif_file , '.jpg' );
 end

end
