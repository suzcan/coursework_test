fileId = fopen('/dcs/17/u1733929/Downloads/selected_files_2019123_165934/coursework_images/pixelsout.txt', 'r');

width = 615; 
height = 409;

formatSpec = '%d %d %d';
sizeA = [1 Inf];
%scan inputs into one-dimensional array line by line
A = fscanf(fileId, formatSpec, sizeA);
% group_of_people 1570x2671x3
% face 409x615x3

%first dimension needs to be 3, because we need to split it every 3 values
img = reshape(A, 3, height, width);
%we then need to permute our 3d array into the format matlab expects
img = permute(img, [2,3,1]);

fclose(fileId);

R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
% imshow(G)

for i =1:numel(R)
    y=16+0.2568*R(i)+G(i)*0.645+B(i)*0.0979;
    
    

%     cr = 0.713*(R(i)-y)+128;
    cr = 0.5910*(R(i)-y)+128;
    
    %     cb = 0.5772*(B(i)-y)+128;
    cb = 0.5772*(B(i)-y)+128;
    
    
    
    if (~(y>80 && cb> 80 && cb<120 && cr >133 && cr<173))
        R(i) = 0;
        G(i)=  0;
        B(i) = 0;
    end
    
end
        


F = uint8(zeros(height, width, 3));
F(:,:,1) = R;
F(:,:,2) = G;
F(:,:,3) = B;


imshow(F);
imwrite(F,'/dcs/17/u1733929/Downloads/selected_files_2019123_165934/coursework_images/pic.jpg');
