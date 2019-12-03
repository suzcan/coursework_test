fileId = fopen('/dcs/17/u1733929/Downloads/selected_files_2019123_165934/coursework_images/pixelsout.txt', 'r');

width = 1920; 
height = 1080;

formatSpec = '%d %d %d';
sizeA = [1 Inf];
%scan inputs into one-dimensional array line by line
A = fscanf(fileId, formatSpec, sizeA);
% group_of_people 1570x2671x3
% face 409x615x3

%first dimension needs to be 3, because we need to split it every 3 values
%remove unit8 if doing some manipulation after and not just showing the
%image
img = uint8(reshape(A, 3, height, width));
%we then need to permute our 3d array into the format matlab expects
img = permute(img, [2,3,1]);
fclose(fileId);

imshow(img);


% do some manipulation
% R = img(:,:,1);
% G = img(:,:,2);
% B = img(:,:,3);
% 
% for i =1:numel(R)
%     
%     %%do something with R(i) G(i) B(i)    
%     
% end
% 
% F = uint8(zeros(height, width, 3));
% F(:,:,1) = R;
% F(:,:,2) = G;
% F(:,:,3) = B;
% 
% imshow(F);
% %write to file
% imwrite(F,'/dcs/17/u1733929/Downloads/selected_files_2019123_165934/coursework_images/pic.jpg');
