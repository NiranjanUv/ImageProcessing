function inv_filter()
close all;
img = imread('cameraman.tif');
[n m] = size(img);
x = -n/2:(n/2)-1;
y = -m/2:(m/2)-1;
[X Y] = meshgrid(x,y);
sigma = 5;

H = exp(-(X.^2 + Y.^2)/(2*sigma^2));
fimg = fftshift(fft2(img));
figure;imshow(H);
figure;imshow(log(abs(fimg)),[]);
bi = fimg.*H;
figure;imshow(uint8(log(abs(bi))),[]);

bis = ifft2(ifftshift(bi));
figure;imshow(uint8(abs(bis)));

noise = randn(size(img)) * 0.1;

bnis = bis + noise;

figure;hist(noise);
figure;imshow(uint8(bnis),[]);

bni = fftshift(fft2(bnis));
bni = bni./(H+0.1);             % direct inverse 
bnis = ifft2(ifftshift(bni));
figure;imshow(log(abs(bni)),[]);

end

