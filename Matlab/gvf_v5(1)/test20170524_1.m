%datafold = 'C:\Polyp\data\ROI\Whitelight\aizuvideo01\';
%image_0  = imread([datafold,'216.jpg']);
%216,"816,746,349,172"
%imshow(image_0(746:746+171,816:816+348,:))
datafold = 'E:\BiuBiuBiu\data\';
the_dir  = dir(datafold);
fold_num = length(the_dir);


for i = 3 :3%fold_num
    csvdata  = csvread([datafold the_dir(i).name '\polyp_coordinate_1.csv']);
    data_num = size(csvdata, 1);
    m = containers.Map;
    %load(strcat(the_dir(i).name, '_map'));
    for j =  1 : data_num %data_num 
       index = num2str(csvdata(j, 1)); 
       filename = [datafold the_dir(i).name '\polyps\' num2str(csvdata(j, 1)) '.tiff'];
       I = imread(filename);
       I = im2double(I);
       I1= I(:,:,1).*I(:,:,1) + I(:,:,2).*I(:,:,2) + I(:,:,3).*I(:,:,3);
       I1= (I1/3).^0.5;
     
       % Compute its edge map
       disp(' Compute edge map ...');
       f = 1 - I1; 
       
       % Compute the GVF of the edge map f
       disp(' Compute GVF ...');
       [u,v] = GVF(f, 0.2, 80); 
       disp(' Nomalizing the GVF external force ...');
       mag = sqrt(u.*u+v.*v);
       px = u./(mag+1e-10); py = v./(mag+1e-10); 
       
       % display the results
       figure(1); 
       subplot(221); imdisp(I1); title('test image');
       subplot(222); imdisp(f); title('edge map');

       % display the gradient of the edge map
       [fx,fy] = gradient(f); 
       subplot(223); quiver(fx,fy); 
       axis off; axis equal; axis 'ij';     % fix the axis 
       title('edge map gradient');

       % display the GVF 
       subplot(224); quiver(px,py);
       axis off; axis equal; axis 'ij';     % fix the axis 
       title('normalized GVF field');

       % snake deformation
       disp(' Press any key to start GVF snake deformation');
       pause(1);
       subplot(221);
       image(((1-f)+1)*40); 
       axis('square', 'off');
       colormap(gray(64)); 
       %t = 0:0.05:6.28;
       %x = 32 + 30*cos(t);
       %y = 32 + 30*sin(t);
       %x = [csvdata(j, 2), csvdata(j, 2)+csvdata(j, 4), csvdata(j, 2)+csvdata(j, 4), csvdata(j, 2)];
       %y = [csvdata(j, 3), csvdata(j, 3), csvdata(j, 3)+csvdata(j, 5), csvdata(j, 3)+csvdata(j, 5)];
       %P = [y(:) x(:)];
       figure
       imshow(f);
       [x,y] = getpts;
       [x,y] = snakeinterp(x,y,3,1); % this is for student version
       
       % for professional version, use 
       %   [x,y] = snakeinterp(x,y,2,0.5);

       snakedisp(x,y,'r') 
       pause(1);

       for k=1:25
          [x,y] = snakedeform(x,y,0.05,0,1,0.06,px,py,5);%歌方。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。
          %[x,y] = snakeinterp(x,y,3,1); % this is for student version
          % for professional version, use 
          [x,y] = snakeinterp(x,y,2,0.5);
          snakedisp(x,y,'r') 
          title(['Deformation in progress,  iter = ' num2str(k*5)])
          pause(0.5);
       end
       m(index) = [x,y];

       disp(' Press any key to display the final result');
       %pause;
       
       
       
       %size(X)=[x,y];
      % fid=fopen('polyp_coordinate_polyp.csv','w');
    %   for i=1:x
      %     for j=1:y
     %          fprintf(fid,'%5f\csv',X(i,j));
     %          if rem(i,x)==0 & rem(j,y)==0 
      %             fprintf(fid,'\r\n');
     %          end
      %     end
    %   end     
   %    fclose(fid);
       
       

       cla;
       colormap(gray(64)); image(((1-f)+1)*40); axis('square', 'off');
       snakedisp(x,y,'r') 
       title(['Final result,  iter = ' num2str(i*5)]);
       save(strcat(the_dir(i).name, '_map'), 'm');
       %disp(' ');
       disp(' Press any key to run the next example');
       close all;
       %pause;
    end
    %save(strcat(the_dir(i).name, '_map'), 'm');
end

