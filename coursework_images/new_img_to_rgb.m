image = imread('dcs/17/u1733929/Downloads/selected_files_2019123_165934/coursework_images/face.jpg');

% imshow(image)
% datacursormode on

fileName = '/dcs/17/u1733929/Downloads/selected_files_2019123_165934/coursework_images/pixelsin.txt'; %"H:/Documents/es3f1/coursework_test/coursework_test.sim/sim_1/behav/xsimin/pixelsin.txt";


% text file was like this where x is rows (down)
% and y is columns (right) and brackets indicates whether it is red green or blue channel
% 
% x,y(R)   x+1,y(R) x+2,y(R)
% x+3,y(R) x+4,y(R) x+5,y(R)
% .....
% x,y(G)   x+1,y(G) x+2,y(G)
% x+3,y(G) x+4,y(G) x+5,y(G)
% .....
% x,y(B)   x+1,y(B) x+2,y(B)
% x+3,y(B) x+4,y(B) x+5,y(B)
% .....
% 
% so the colors were output just one channel at a time, which is a misleading representation.
% this probably happened, because fprintf function printed from
% image array (which has dimensions [height,  width, colorchannels])
% to the text file iterating from the height, then width then color, where we actually need to go
% height then width but print all three color channels at once in the same line. This worked in matlab when reading
% back the image because we read all the values into one-dimensional array and then reshaped it properly to show the image,
% however most verilog code probably did not work because of this, because it was expecting rgb values in one line.
% The only things that worked were the ones that did the same thing to all the pixel values (e.g. inversion)
% 
% the way I do it with for probably is not the most efficient as it takes a
% while, but it works.
% with my updated matlab code text file now looks like this:
% 
% x,y(R)   x,y(G)   x,y(B)
% x+1,y(R) x+1,y(G) x+1,y(B)
% x+2,y(R) x+2,y(G) x+2,y(B)
% .....




[rows, columns, numberOfColorChannels] = size(image);
fid = fopen(fileName, 'w');
for col = 1 : columns
  for row = 1 : rows
    fprintf(fid, '%d %d %d\n',...
      image(row, col, 1),...
      image(row, col, 2),...
      image(row, col, 3));
  end
end

fclose(fid);

% R = image(:,:,1);
% G = image(:,:,2);
% B = image(:,:,3);


% with rows and colums (for debugging?)
% for col = 1 : columns
%   for row = 1 : rows
%     fprintf(fid, '%d, %d = (%d, %d, %d)\n', ...
%       row, col, ...
%       rgbImage(row, col, 1),...
%       rgbImage(row, col, 2),...
%       rgbImage(row, col, 3));
%   end
% end