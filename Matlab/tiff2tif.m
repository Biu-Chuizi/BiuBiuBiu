% ��pgmͼƬ����ת��ΪjpgͼƬ
function [  ] = tiff2jpg(  )
 % ��ȡָ��Ŀ¼�������е�pgm��ʽͼƬ
 pgms = dir('F:\1\*.tiff');
 num_pgms = length( pgms );
%  for i = 1 : num_pgms
   tiff_file = fullfile( 'F:\1' , pgms(1).name );
%    pgm = imread( tiff_file );
   
   % ת��Ϊ jpg ��ʽ
   %��һ���������ļ���
   [ path , name , ext ] = fileparts( tiff_file ) ;
   %�ڶ����������µ��ļ���
   filename = strcat( name , '.jpg' );
   %�������������ļ�ȫ��
   tif_file = fullfile('F:\1')%tif_file = fullfile( 'F:\1' , filename ) ;
%    imwrite(filename,'.jpg');%
   imwrite( filename, tif_file , '.jpg' );
 end

end
