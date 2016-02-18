% Gaussian Lowpass and Highpass filter Implementation (Frequency domain)

function GaussianFilter()
close all;

% Taking the name of the image from user
prompt = 'Enter the name of the Image:';
name = input(prompt);

% Input the distance at which filtering should be applied
prompt = 'Enter the Distance at which low pass filtering should be applied:';
distance_lp = input(prompt);

prompt = 'Enter the Distance at which HIGH pass filtering should be applied:';
distance_hp = input(prompt);

img = imread(name);
[m n]=size(img);

% Taking the FFT transform of the image.
f_transform=fft2(img);
f_shift=fftshift(f_transform);

% Calculating the Distance matrix for filtering and calculating the Gaussian 
% Low Pass Filter response
for i=1:m
    for j=1:n
        distance=sqrt((i-m/2)^2+(j-n/2)^2);
        low_filter(i,j)=exp(-(distance)^2/(2*(distance_lp^2)));
    end
end

subplot(2,2,1); imshow(low_filter); title('Gaussian LPF Response');

% Taking product of image and filter in frequency domain
filter_apply=f_shift.*low_filter;

% Taking the inverse FFT of the result
image_orignal=ifftshift(filter_apply);
image_filter_apply=abs(ifft2(image_orignal));

subplot(2,2,2); imshow(image_filter_apply,[]); title('After Gaussian LP Filtering');

% Gaussian HIGH pass filtering
high_filter = 1 - low_filter;
subplot(2,2,3); imshow(high_filter); title('Gaussian HPF Response');

% Taking product of image and filter in frequency domain
filter_apply2=f_shift.*high_filter;
image_orignal=ifftshift(filter_apply2);

% Taking the inverse FFT of the result
image_filter_apply=abs(ifft2(image_orignal));
subplot(2,2,4); imshow(image_filter_apply,[]); title('After Gaussian HP Filtering');

end
