fileId = fopen("H:/Documents/es3f1/es3f1_camera/coursework_images/out.txt", 'r');

formatSpec = '%d'; % '%d %d %d';
sizeA = [1 Inf];
A = fscanf(fileId, formatSpec, sizeA);

% group_of_people 1570x2671x3
% face 409x615x3
width = 615; 
height = 409;
B = uint8(reshape(A, [width, height, 3]));

%imshow(B);

y = 0;
u = 0;
v = 0;

skin_u_min = 20; 
skin_u_max = 70;
skin_v_min = -1;
skin_v_max = 2;


C = B(:,:,1); % red
D = B(:,:,2); % green
E = B(:,:,3); % blue

for i = 1:numel(C)
    y = (C(i) + (2 * D(i)) + E(i)) / 4;  
    u = C(i) - D(i);
    v = E(i) - D(i);


    if (skin_u_min < u && u < skin_u_max && skin_v_min < v && v < skin_v_max) 
        C(i) = 0;
        D(i) = 128;
        E(i) = 0;
    end
 end


CC = uint8(reshape(C, height, width));
DD = uint8(reshape(D, height, width));
EE = uint8(reshape(E, height, width));

F = uint8(zeros(height, width, 3));
F(:,:,1) = CC;
F(:,:,2) = DD;
F(:,:,3) = EE;


imshow(F);



fclose(fileId);