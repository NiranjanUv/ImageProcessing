% Spatial Filter Implementation

function Spatial_filter()
close all;

prompt = 'Enter the name of the Image:';
name = input(prompt);

% Reading the image.
img = imread(name);
[n m] = size(img);

% Generating the filter mask
h = fspecial('laplacian',0);

fil_img = imfilter(img,h,'replicate');

subplot(2,2,1); imshow(img); title('Original Image');
subplot(2,2,2); imshow(fil_img); title('Filtered Image - Laplacian');

h = fspecial('gaussian',[n m]);
fil_img = imfilter(img,h,'circular');

subplot(2,2,3); imshow(fil_img); title('Filtered Image - Gaussian');

h = fspecial('average',[5 5]);
fil_img = imfilter(img,h,'symmetric');

subplot(2,2,4);  imshow(fil_img); title('Filtered Image - Average');

end