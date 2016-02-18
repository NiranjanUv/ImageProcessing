% Arithmetic Coding Implementation

function Arithmetic_Coding()

clc;
clear all
format long;

prompt = 'Enter the character string to Encode: ';
seqin = input(prompt);

fprintf('\nArithmetic Encoding started');  

% Get the length of the input string
l1 = length (seqin);

% Get the unique characters and its length in the input string
allChar = unique(seqin);
l2=length(allChar);

% Initialize count matrix
for i=1:l2
 count(i)=0;
end

% Creating histogram to store the probailty values
histogram = zeros(1,26);

% Making the entry of the alphabets in string content to 1 for array
% processing
for n=1:length(seqin)  
    currentLetter=seqin(n);
    histogram(currentLetter-96)=histogram(currentLetter-96)+1;
    % Collecting the number of occurences of alphabet in String in the
    % array.
    x(n) = histogram(currentLetter-96);
end

% Calculate the probability of occurence of each letter in the string
j=1;
pr = zeros(l1);
for i = 1:length(seqin)
    if(histogram(i) ~= 0)
        pr(j) = histogram(i)/sum(x(:));
        j=j+1;
    end
end

% Call the Encoder for compression.
codeword = encoder(allChar,pr,seqin)

% Call the Decoder for decompression.
seqout = decoder(allChar,pr,codeword,10)

end

% ###############################################
% Encoder...
function arcode= encoder(symbol,pr,seqin)

high_range=[];

% Initialize High_Range pdf
for k=1:length(pr),
   high_range=[high_range sum(pr(1:k))];
end

% Initialize Low Range matrix
low_range=[0 high_range(1:length(pr)-1)];

% Initialize temp zero matrix of size of input string
sbidx=zeros(size(seqin));

% Find all the symbols in the string as in the dictionary
for i=1:length(seqin),
   sbidx(i)=find(symbol==seqin(i));
end

% Initial value of LOW and HIGH
low=0; high=1;

% Calculate LOW and HIGH value for all the symbols in the string
for i=1:length(seqin),
   range=high-low;
   high = low + range*high_range(sbidx(i));
   low = low + range*low_range(sbidx(i));
end

% Return the LOW value of the last coded symbol
arcode=low;

end

% ########################################################
% Decoder ........
function symseq=decoder(symbol,pr,codeword,symlen)

format long
high_range=[];

% Initialize High_Range matrix
for k=1:length(pr),
   high_range=[high_range sum(pr(1:k))];
end

% % Initialize Low_Range 
low_range=[0 high_range(1:length(pr)-1)];

% Take minimum of the probability vector
prmin=min(pr); 
symseq=[];

% Till end of the symbol length is reached
for i=1:symlen, 
   idx=max(find(low_range<=codeword));
   codeword=codeword-low_range(idx);
   
   % Sometimes the encoded number 
   % will be slightly smaller than the current lower bound.
   % If this happens, a correction is required.
   %if abs(codeword-pr(idx))< 0.01.*prmin, 
    %  idx=idx+1; 
     % codeword=0;
   %end
   
   % Decode using the formula
   symseq=[symseq symbol(idx)]
   codeword=codeword/pr(idx);
   if abs(codeword)<0.01*prmin,
      i=symlen+1;  % break the for loop immediately
   end
end

end
