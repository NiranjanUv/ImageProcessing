function Regular_filter()   %Regular filter Implementation

close all;
clc;

img = checkerboard(8);      % Reading the image
[m n]=size(img);
mn = m*n;

prompt = 'Enter the mean of the noise :';
noise_mean = input(prompt);

prompt = 'Enter the noise variance:';
noise_var = input(prompt);

figure; subplot(1,2,1);imshow(img); title('Original Image');

PSF = fspecial('gaussian',7,10);        % Creating a Point Spread Function
blurred  = imfilter(img,PSF);           % Creating a Blurred image.
subplot(1,2,2);imshow(blurred); title('Blurred Image');

% generating noise with specified variance and mean
noise = imnoise(zeros(size(img)),'gaussian',noise_mean,noise_var);
figure; subplot(1,2,1); imshow(noise); title('Noise');

% generating Blurred noisy image with specified variance and mean
blurred_noisy = imnoise(blurred, 'gaussian', noise_mean, noise_var);
subplot(1,2,2);imshow(blurred_noisy); title('Blurred Noisy Image');

% Noise Power
NP = noise_var*prod(size(img));

% Deblurring using Built in Function
[rest_img x]= deconvreg(blurred_noisy,PSF,NP);
figure;subplot(1,2,1);imshow(rest_img);title('Deblurred Image using Built In Function');

% To Implement image in Frequency Domain

% Taking the FFT of PF
H = psf2otf(PSF,size(img));
h2 = abs(H).^2;

% Creating Laplacian Mask 
p = [0 1 0;1 -4 1;0 1 0];
P = fft2(p,64,64);
P2 = abs(P).^2;
x = h2 + (0.05*P2);
y = conj(H)./x;
res = y.*fft2(blurred_noisy);

subplot(1,2,2);imshow(ifft2(ifftshift(res))); title('Deblurred Image - using Formula');
end