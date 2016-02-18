% DCT and DFT Implementation on SIgnals by Discrding Coefficients

function DCT_new()

close all;
clc;

% Initializing the signal
pi = 3.1416;
thetha = pi/16:2*pi/16:15*pi/16;


% ##########################################################
% DCT Calculation

% Calculating Unitary DCT using formula
for f = 1:8
    for i = 1:8
        if (f==1) w(i) = 0.5*(1/sqrt(2))*cos((f-1)*thetha(i));
        else w(i) = 0.5*cos((f-1)*thetha(i));
        end
    end
end

figure; plot(thetha); title('Original Signal');

disp('DCT vector is');
w

disp('Taking the product of DCT matrix and its inverse')
w * w'

% Calculating unitary DCT using built in function
w1 = dct(thetha);

% Sort the data
[XX,ind] = sort(abs(w1),'descend');

% Find the length of data.
len = size(w1); 
z = prod(len)/2;

% Discard Half of the DCT Coefficients.
w1(ind(z+1:end))=0;

% Calculating Inverse DCT after discarding coefficients
y = idct(w1) ;

figure;plot(y); title('Restored Signal - IDCT');

disp('Mean Square error (DCT restoration) is');
mse1 = mean((w1(:)-thetha(:)).^2)

% ##########################################################
% DFT Calculation

N = prod(size(thetha));

% Calculating FFT using the formula
% Calculating FM Mask
for n=1:N
    for k=1:N
        ret(n,k)=exp(sqrt(-1)*2*pi*(n-1)*(k-1)/N);
    end
end

disp('DFT vector is');
ret

% Finding FFT .
FM = ret*thetha';

% Discarding the coefficients
[q,ind] = sort(abs(FM),'descend');
len = size(FM);
z = prod(len)/2;
FM(ind(z+1:end))=0;

% Calculating Inverse FT mask
for n=1:N
    for k=1:N
        ret(n,k)=exp(-1*sqrt(-1)*2*pi*(k-1)*(n-1)/N);
    end
end

% Calculating IFT
fms = (ret*FM).*(1/N);
figure;subplot(1,2,1);plot(fms); title('Restored Signal (IDFT)- With Formula ');


disp('Mean Square error (DFT restoration) is');
mse1 = mean((fms(:)-thetha(:)).^2)

% Repeating the FFT through Built in function
a = fft(thetha);
[q,ind] = sort(abs(a),'descend');

len = size(a);
z = prod(len)/2;

a(ind(z+1:end))=0;
y = (1/N)*ifft(a);

subplot(1,2,2);plot(y); title('Restored Signal (IDFT)- Built in function');

end