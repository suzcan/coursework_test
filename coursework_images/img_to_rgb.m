image = imread("H:/Documents/es3f1/es3f1_camera/coursework_images/face.jpg");

fileName = "H:/Documents/es3f1/es3f1_camera/coursework_images/in.txt"; %"H:/Documents/es3f1/coursework_test/coursework_test.sim/sim_1/behav/xsimin/pixelsin.txt";

fileIn = fopen(fileName, "w");
fprintf(fileIn, '%d %d %d\n', image);
