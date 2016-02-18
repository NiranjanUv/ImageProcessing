function Blind_filter()     % Blind Deconvultion Implementation

clc;
close all;
% Reading the image.
img = checkerboard(8);

% Create the PSF with Gaussian filter parameter
PSF = fspecial('gaussian',7,10);

prompt = 'Enter the mean of the noise :';
noise_mean = input(prompt);

prompt = 'Enter the noise variance:';
noise_var = input(prompt);

figure; imshow(img); title('Original Image');
% Creating Blurred Noisy Image by adding Gaussian noise
BlurredNoisy = imnoise(imfilter(img,PSF),'gaussian',noise_mean,noise_var);

% Creating Weight parameter to assign weight to each pixel to reflect its
% quality
WT = zeros(size(img));
WT(5:end-4,5:end-4) = 1;

% Creating Initial PSF for restoration
INITPSF = ones(size(PSF));

% Deblurring using deconvblind function
[J P] = deconvblind(BlurredNoisy,INITPSF,20,10*sqrt(noise_var),WT);

figure;subplot(1,2,1);imshow(BlurredNoisy); title('Blurred Noisy image');
subplot(1,2,2);imshow(J); title('Deblurred Image');
end