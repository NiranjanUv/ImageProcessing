% Direct Inverse Filter Implementation

function  Direct_inverse(  )


img=checkerboard(8);%reading image
subplot(221);imshow(img);title('Original Image');

[n,m]=size(img);

x=-(n/2):(n/2)-1;
y=-(m/2):(m/2)-1;
[X Y]=meshgrid(x,y);

prompt = 'Enter the variance:';
sigma = input(prompt);

% Define Transfer Function
H=exp(-(X.^2+Y.^2)/(2*sigma^2));

% Taking FFT of the image
fimg=fftshift(fft2(img));

% Taking the product of image and the Transfer function
bi=fimg.*H;

bis=ifft2(ifftshift(bi));
subplot(222);imshow(log(abs(bis)),[]);title('Blurred Image');

% Random Noise Generation
noise=randn(size(img))*0.1;
bis=(bis)/(max(bis(:)));

% Blurred Noisy Image generation
bnis=bis+noise;
subplot(223);imshow(abs(bnis),[]);title('Blurred Noisy Image');
bni=fftshift(fft2(bnis));

% Inverse Filtering
restore=bni./H+0.1;
subplot(224);imshow(abs(ifft2(ifftshift(restore))),[]);title('Restored Image');
 
end