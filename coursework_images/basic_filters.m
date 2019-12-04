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

for i = 1:numel(C)
%     % all green
%     C(i) = 0;
%     D(i) = D(i);
%     E(i) = 0;      

%     % all blue
%     C(i) = 0;
%     D(i) = 0;
%     E(i) = E(i);

%     % all red
%     C(i) = C(i);
%     D(i) = 0;
%     E(i) = 0;

%     % invert
%     C(i) = 255 - C(i);
%     D(i) = 255 - D(i);
%     E(i) = 255 - E(i);

%       % greyscale 
%       C(i) = ( (0.3 * C(i)) + (0.59 * D(i)) + (0.11 * E(i)) );
%       D(i) = ( (0.3 * C(i)) + (0.59 * D(i)) + (0.11 * E(i)) );
%       E(i) = ( (0.3 * C(i)) + (0.59 * D(i)) + (0.11 * E(i)) );
 end


CC = uint8(reshape(C, height, width));
DD = uint8(reshape(D, height, width));
EE = uint8(reshape(E, height, width));

F = uint8(zeros(height, width, 3));
F(:,:,1) = CC;
F(:,:,2) = DD;
F(:,:,3) = EE;


imshow(F);


