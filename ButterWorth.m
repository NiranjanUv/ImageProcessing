% Butterworth Lowpass and Highpass filter Implementation (Frequency domain)

function [out] = ButterWorth()
close all;

% Taking the name of the image from user
prompt = 'Enter the name of the Image:';
name = input(prompt);

% Input the distance at which filtering should be applied
prompt = 'Enter the Distance at which low pass filtering should be applied:';
distance = input(prompt);

prompt = 'Enter the Distance at which HIGH pass filtering should be applied:';
distance_hp = input(prompt);

img = imread(name);
[n m] = size(img);
img = double(img);
figure;imshow(img,[]); title('Original Image');

% Taking FFT of the image and centering it.
f = fft2(img);
fs = fftshift(f);
figure;imshow(log(abs(fs)),[]);

% Calculating the Distance matrix for filtering
for i = 1:n
    for j=1:m
        D(i,j) = sqrt((i-n/2)^2 + (j-m/2)^2);
    end
end

% Butterworth LPF 
l = 1./(1+(D/distance).^2);
subplot(2,2,1);imshow(l);  title('Butterworth LPF Response');

% Taking product of image and filter in frequency domain
r = fs.^l;

% Taking inverse FFT
temp = ifftshift(r);
ifimg = ifft2(temp);
subplot(2,2,2); imshow(ifimg,[]); title('After ButterWorth LOW Pass filtering');

% Butterworth High Pass filter
h = 1./(1+(distance_hp./D).^(2*1));
subplot(2,2,3);imshow(h); title('Butterworth HPF Response');

% Taking product of image and filter in frequency domain
re = fs.^h;
temp1 = ifftshift(re);
ifimg1 = ifft2(temp1);
subplot(2,2,4); imshow(ifimg1,[]); title('After ButterWorth HIGH Pass filtering');

end