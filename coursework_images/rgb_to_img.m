fileId = fopen("H:/Documents/es3f1/es3f1_camera/coursework_images/out.txt", 'r');

formatSpec = '%d %d %d';
sizeA = [1 Inf];
A = fscanf(fileId, formatSpec, sizeA);

% group_of_people 1570x2671x3
% face 409x615x3
width = 615; 
height = 409;
%B = uint8(reshape(A, [409, 615, 3]));

%imshow(B);

C = A(1:3:end);
D = A(2:3:end);
E = A(3:3:end);

CC = uint8(reshape(C, height, width));
DD = uint8(reshape(D, height, width));
EE = uint8(reshape(E, height, width));

F = uint8(zeros(409, 615, 3));
F(:,:,1) = CC;
F(:,:,2) = DD;
F(:,:,3) = EE;

imshow(F);


fclose(fileId);