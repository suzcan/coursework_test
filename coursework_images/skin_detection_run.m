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
cb = 0;
cr = 0;

skin_y = 100;
skin_cb_min = 5;
skin_cb_max = 50; 
skin_cr_min = 40; 
skin_cr_max = 100;


C = B(:,:,1); % red
D = B(:,:,2); % green
E = B(:,:,3); % blue

for i = 1:numel(C)    
          y = 0.299 * C(i) + 0.287 * D(i) + 0.11 * E(i);
          cr = C(i) - y;
          cb = E(i) - y;


         if(y > skin_y && skin_cb_min < cb && skin_cb_max > cb && skin_cr_min < cr && skin_cr_max > cr)
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