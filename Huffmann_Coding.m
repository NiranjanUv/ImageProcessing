% Huffmann Coding Implementation

function Huffmann_Coding 
clc;
close all;

prompt = 'Enter the character string to Encode: ';
string = input(prompt);

% Collecting the unique characters in the string
allChar = unique(string);

% Creating histogram to store the probailty values
histogram = zeros(1,26);

% Making the entry of the alphabets in string content to 1 for array
% processing
for n=1:length(string)  
    currentLetter=string(n);
    histogram(currentLetter-96)=histogram(currentLetter-96)+1;
end

% Taking the ASCII value of the unique characters in the string and storing
% in x for calculating the percentage of occurence of the string.
for n = 1:length(allChar)
    temp = allChar(n);
    temp = double(temp);
    x(n) = histogram(temp - 96);
end

% Calculating the ratio of each unique character in the string.
for i = 1:length(allChar)
     temp = allChar(i);
     temp = double(temp);
     a(i) = histogram(temp - 96)/sum(x(:));
end

% Calculating the number of Bits required to represent each character in the string
bits = ceil(log2(length(allChar)));
probabilities = a;

% For each probability create and empty codewaord and ...
for index = 1:length(probabilities)
    codewords{index} = [];
    % Create a set containing with only this codeword
    set_contents{index} = index;
    % Store the probability associated with this set
    set_probabilities(index) = probabilities(index);
end

% Keep going until all the sets have been merged into one
while length(set_contents) > 1
    
    % Determine which sets have the lower probabilities
    [temp, sorted_indices] = sort(set_probabilities);

    % Get the set having the lower probability
    zero_set = set_contents{sorted_indices(1)};
    % Get that probability
    zero_probability = set_probabilities(sorted_indices(1));
    % For each codeword in the set ...
    for codeword_index = 1:length(zero_set)
        % append a zero
        codewords{zero_set(codeword_index)} = [codewords{zero_set(codeword_index)}, 0];       
    end
    
    % Get the set having the second lower probability
    one_set = set_contents{sorted_indices(2)};
    % Get that probability
    one_probability = set_probabilities(sorted_indices(2));
    % For each codeword in the set...
    for codeword_index = 1:length(one_set)
        % ...append a one
        codewords{one_set(codeword_index)} = [codewords{one_set(codeword_index)}, 1];       
    end

    disp('The symbols, their probabilities and the allocated bits are:');
    % For each codeword...
    for index = 1:length(codewords)
        % ...display its bits
        disp([num2str(index),'    ',num2str(probabilities(index)),'    ',num2str(codewords{index})]);
    end
    
    % Remove the two sets having the lower probabilities which are
    % processed now and merge them into new set.
    set_contents(sorted_indices(1:2)) = [];
    set_contents{length(set_contents)+1} = [zero_set, one_set];
    
    % Remove the two lower probabilities and give their sum to the new set.
    set_probabilities(sorted_indices(1:2)) = [];
    set_probabilities(length(set_probabilities)+1) = zero_probability + one_probability;
            
    disp('The sets and their probabilities are:')
    for set_index = 1:length(set_probabilities)
        disp([num2str(set_probabilities(set_index)),'    ', num2str(set_contents{set_index})]);
    end
    
    
end

disp('-------------------------------------------------------------------------');
disp('The symbols, their probabilities and the allocated Huffman codewords are:');

% For each codeword displacy its bits in REVERSE order.
for index = 1:length(codewords)
    disp([num2str(index), '    ', num2str(probabilities(index)),'    ',num2str(codewords{index}(length(codewords{index}):-1:1))]);
end

end