%Part 1.1
convolution = [0, 5, 0, 0, 0, 0, 0, 0, 0, 0;
               0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
               0, -7, 2, 8, -1, 2, -1, -3, 0, 0;
               0, 0, 1, 1, 0, 0, -1, -1,  0, 0;
               0, 0, 3, 1, -2, 4, -1, -5, 0, 0;
               0, 0, -1, -1, 0, 0, 1, 1, 0, 0;
               0, 0, 1, 2, 2, 2, -3, -4, 0, 0;
               0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
               0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
fprintf("%2d %2d %2d %2d %2d %2d %2d %2d %2d %2d\n", convolution.');

%Part 1.2
fprintf("The gradient magnitude at [2,3] is 8.\n");
fprintf("The gradient magnitude at [4,3] is 2.\n");
fprintf("The gradient magnitude at [4,6] is 2.\n");

%Part 1.3
img=imread('4.1.05.tiff');
kernel = [-1, 0, 1;
          -2, 0, 1;
          -1, 0, 1];
img_1_3 = MyConv(img, kernel);
figure('Name', 'Part 1_3 Convolution');
imshow(img_1_3);

%Part 1.4
img=imread('4.1.05.tiff');
img_gray = rgb2gray(img);
imgd = im2double(img_gray);
Gaussian_filter = fspecial('gaussian',[13 13],2);
img_myConv= MyConv(img, Gaussian_filter);
img_filter = imfilter (imgd,Gaussian_filter,'same');
img_1_4 = img_myConv - img_filter;
figure('Name', 'Part 1-4 Difference of Convolution Functions');
imshow(img_1_4);
fprintf("There is no difference because the image is black which means the difference of the pixel values is 0.\n");

%Part 1.5
img_1_5 = imread('car.jpg');
img_1_5_gray = rgb2gray(img_1_5);
img_1_5_double = im2double(img_1_5_gray);
filter_2D = fspecial('gaussian',[49 49],8);
filter_1D_1 = fspecial('gaussian',[1 49],8);
filter_1D_2 = fspecial('gaussian',[49 1],8);
tic
img_1_5_1 = conv2 (img_1_5_double, filter_2D,'same');
t1 = toc;
fprintf("Execution time for convolution with one 2D gaussian kernel is %.4f\n",t1);
tic
img_1_5_2 = conv2 (img_1_5_double, filter_1D_1,'same');
img_1_5_3 = conv2 (img_1_5_2, filter_1D_2,'same');
t2 = toc;
fprintf("Execution time for convolution with two 1D gaussian kernel is %.4f\n",t2);

%Part 2.1
img_2_1 = imread('bowl-of-fruit.jpg');
img_2_1_gray = rgb2gray(img_2_1);
img_2_1_double = im2double(img_2_1_gray);
img_2_1_1 = MyCanny(img_2_1_double, 8, 65);
figure('Name', 'Part 2_1 Edge Detection');
imshow(img_2_1_1);

img_edge = edge(img_2_1_double, 'canny');
figure('Name', 'Part 2 Detection');
imshow(img_edge, [])

%Part 2.2
%Also done seperately in the MyCanny function.
img_2_2=imread('4.1.05.tiff');
img_2_2_gray = rgb2gray(img_1_5);
img_2_2_double = im2double(img_1_5_gray);
Gfilter_x = fspecial('gaussian',[13 1],2);
Gfilter_y = fspecial('gaussian',[1 13],2);

img_2_2_1 = conv2 (img_2_2_double, Gfilter_x,'same');
img_2_2_2 = conv2 (img_2_2_1, Gfilter_y,'same');
figure('Name', 'Part 2-2 Convolution Functions');
imshow(img_2_2);


% Part 3.1
ryerson = im2double(imread('ryerson.jpg'));
ryerson640 = MySeamCarving(ryerson,640,480);
ryerson320 = MySeamCarving(ryerson,720,320);

figure;
imshow(ryerson);
title('Original Image (720x480)');
figure;
imshow(ryerson640);
title('Seam Carved Image (640x480)');
figure;
imshow(ryerson320);
title('Seam Carved Image (720x320)');

halo = im2double(imread('halo.png'));
halo650x250 = MySeamCarving(halo,650,250);

figure;
imshow(halo);
title('Original Image (821x357)');
figure;
imshow(halo650x250);
title('Seam Carved Image (650x250)');
