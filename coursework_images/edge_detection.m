fileId = fopen('/dcs/16/u1558174/es3f1/es3f1_camera/coursework_images/in.txt'); %fopen("H:/Documents/es3f1/es3f1_camera/coursework_images/in.txt", 'r');

formatSpec = '%d'; % '%d %d %d';
sizeA = [1 Inf];
A = fscanf(fileId, formatSpec, sizeA);

% group_of_people 1570x2671x3
% face 409x615x3
width = 2671; 
height = 1570;
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

prev_c = C(1,1);
prev_d = D(1,1);
prev_e = E(1,1);


for i = 1:numel(C)
    
    % edge detection
    if(prev_c > C(i) + 7 && prev_d > D(i) + 7 && prev_e > E(i) + 7)
        prev_c = C(i);
        prev_d = D(i);
        prev_e = E(i);
        
        C(i) = 0;
        D(i) = 0;
        E(i) = 0;
        else
        prev_c = C(i);
        prev_d = D(i);
        prev_e = E(i);
        
        C(i) = 255;
        D(i) = 255;
        E(i) = 255;
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

