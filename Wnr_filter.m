% Weiner Filter Implementation

function Wnr_filter()

close all;
clc;
img = checkerboard(8);

prompt = 'Enter the mean of the noise :';
noise_mean = input(prompt);

prompt = 'Enter the noise variance:';
noise_var = input(prompt);

figure;imshow(img); title('Original Image');

% Generating Point spread function.
PSF = fspecial('motion',7,45);
blurred  = imfilter(img,PSF,'circular');
figure;subplot(2,2,1);imshow(blurred); title('Blurred Image');

% Creating Blurred Noisy Image by adding Gaussian noise
noise = imnoise(zeros(size(img)),'gaussian',noise_mean,noise_var);

%figure, imshow(noise); title('Noise');
blurred_noisy = imnoise(blurred, 'gaussian', noise_mean, noise_var);
subplot(2,2,2); imshow(blurred_noisy); title('Blurred Noisy Image');

NP = abs(fft2(noise)).^2;
NP = sum(NP(:))/(prod(size(noise)));

IP = abs(fft2(img)).^2;
IP = sum(IP(:))/(prod(size(img)));

R = NP/IP;
rest_img_1 = deconvwnr(blurred_noisy, PSF, R);
subplot(2,2,3); imshow(rest_img_1);title('Restoration of Noisy Blurred Image with NSR using Matlab Function');

[n m] = size(img);

% Getting H from PSF
H = psf2otf(PSF,[n m]);
q = abs(H).^2;
q = q./(q+R);
q = q./H;
q = q.*(fftshift(fft2(blurred_noisy)));

disp('Mean Square Error Original and deblurred signal using formula is');
mean_sqaure_error = mean((abs(img(:)) - abs(ifft2(ifftshift(q(:))))).^2)
subplot(2,2,4);imshow(ifft2(ifftshift(q))); title('Restoration of Noisy Blurred Image using Formula');
end