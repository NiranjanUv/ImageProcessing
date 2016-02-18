% Lucy Filter Implementation

function Lucy_filter()      

close all;
clc;

% Read the image
img = checkerboard(8);
figure; imshow(img); title('Original Image');

% Create the PSF with Gaussian filter parameter
PSF = fspecial('gaussian',7,10);

prompt = 'Enter the mean of the noise :';
noise_mean = input(prompt);

prompt = 'Enter the noise variance:';
noise_var = input(prompt);

% Creating Blurred Noisy Image by adding Gaussian noise
BlurredNoisy = imnoise(imfilter(img,PSF),'gaussian',noise_mean,noise_var);

% Creating Weight parameter to assign weight to each pixel to reflect its
% quality
WT = zeros(size(img));
WT(5:end-4,5:end-4) = 1;

% Deblurring by specifying PSF Alone
J1 = deconvlucy(BlurredNoisy,PSF);

% Deblurring by specifying PSF, Iterations and Damping parameter
J2 = deconvlucy(BlurredNoisy,PSF,20,sqrt(noise_var));

% Deblurring by specifying PSF, Iterations, Damping parameter and Weight
% Matrix
J3 = deconvlucy(BlurredNoisy,PSF,20,sqrt(noise_var),WT);

figure; subplot(2,2,1);imshow(BlurredNoisy); title('Blurred and Noisy Image');
subplot(2,2,2); imshow(J1); title('Deblurring with PSF alone');
subplot(2,2,3); imshow(J2); title('Deblurring with PSF,NI,DP');
subplot(2,2,4); imshow(J3); title('Deblurring with PSF,NI,DP,WT');

end