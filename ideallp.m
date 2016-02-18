% Ideal Lowpass and Highpass filter Implementation (Frequency domain)
function [out] = IdealFilter()
close all;

% Taking the name of the image from user
prompt = 'Enter the name of the Image:';
name = input(prompt);

% Input the distance at which filtering should be applied
prompt = 'Enter the Distance at which LPF should be applied:';
distance_lpf = input(prompt);

% Input the distance at which filtering should be applied
prompt = 'Enter the Distance at which HPF should be applied:';
distance_hpf = input(prompt);

% Reading the image.
img = imread(name);
[n m] = size(img);

img = double(img);
figure;imshow(img,[]);title('Original Image');

% Taking FFT and doing FFTshift of the image.
f = fft2(img);
fs = fftshift(f);
figure;imshow(log(abs(fs)),[]);

% Calculating the Distance matrix from the center
for i = 1:n
    for j=1:m
        D(i,j) = sqrt((i-n/2)^2 + (j-m/2)^2);
    end
end

% Low Pass Filtering 
l = D<=distance_hpf;
subplot(2,2,1); imshow(l); title('Ideal LPF Response');

% Taking the product LPF Mask with FFT of the image.
r = fs.^l;

%Taking the IFFT of the result
temp = ifftshift(r);
ifimg = ifft2(temp);
t1 = uint8(ifimg);
subplot(2,2,2);imshow(t1,[]); title('After Ideal LOW pass Filtering');

% High pass Filtering
h = 1-l;
subplot(2,2,3); imshow(h);   title('Ideal HPF Response');

% Taking the product HPF Mask with FFT of the image.
re = fs.^h;

%Taking the IFFT of the result
temp1 = ifftshift(re);
ifimg1 = ifft2(temp1);
t1 = uint8(ifimg1);
subplot(2,2,4);imshow((t1),[]);  title('After Ideal HIGH pass Filtering');

end