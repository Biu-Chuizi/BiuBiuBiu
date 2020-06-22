pgms = dir('C:\Users\Joe\Desktop\0209\0\*.tiff');
num_pgms = length( pgms );
for a = 1 : num_pgms
  tiff_file = fullfile( 'C:\Users\Joe\Desktop\0209\0\' , pgms(a).name );
  pgm      = imread( tiff_file );
  [rows , cols , colors] = size(pgm);%�õ�ԭ��ͼ��ľ���Ĳ���
  MidGrayPic = zeros(rows , cols);%�õõ��Ĳ�������һ��ȫ��ľ���������������洢������ķ��������ĻҶ�ͼ��
  MidGrayPic = uint8(MidGrayPic);%��������ȫ�����ת��Ϊuint8��ʽ����Ϊ���������䴴��֮��ͼ����double�͵�
  for i = 1:rows
    for j = 1:cols
        sum = 0;
        for k = 1:colors
            sum = sum + pgm(i , j , k) / 3;%����ת���Ĺؼ���ʽ��sumÿ�ζ���Ϊ��������ֶ����ܳ���255
        end
        MidGrayPic(i , j) = sum;
    end
  end
  % [ path , name , ext ] = fileparts( MidGrayPic );
  %   
  % %     %�������������ļ�ȫ��
  %    imwrite( MidGrayPic , png_file , 'png' );
  % 
  [path, name, ext] = fileparts(pgms(a).name);  
  filename = strcat( name , '.png' );
  png_file = fullfile( 'C:\Users\Joe\Desktop\�½��ļ���\0\' ,filename ) ;
  imwrite(MidGrayPic , png_file , 'png');
end