% LZW Compression Algorithm

function LZW()          

prompt = 'Enter the character string to Encode: ';
str = input(prompt);

fprintf('\nLZW-Compression started');      

% Call the encode function to compress the data
[packed,table]=encode(uint8(str));

fprintf('\nLZW-DeCompression started');
% Decode function to decode the compressed data
[unpacked,table] = decode(packed);

% show new table elements
fprintf('New Table elements are\n')
strvcat(table{257:end})

% Save the decompressed data
decompressed_data = char(unpacked)

% Comaparing if the original string and decoded string are equal. 
if(isequal(str,decompressed_data))
    fprintf('\n Source string and Decompressed string are same\n');
end
end

% ############################################################
function [output,table] = encode(vector)
if ~isa(vector,'uint8'),
	error('input argument must be a uint8 vector')
end

% vector as uint16 row
vector = uint16(vector(:)');

% Initialize table 
table = cell(1,256);
for index = 1:256,
	table{index} = uint16(index-1);
end

% Initialize output
output = vector;

% main loop
outputindex = 1;
startindex = 1;
for index=2:length(vector)
        % Get the input character
    element = vector(index);
        % Search for the character in the table.
	substr = vector(startindex:(index-1));
        % Get the code for the character from the table
	code = getcodefor([substr element],table);
        % If its empty then ADD it to the table
	if isempty(code)
		output(outputindex) = getcodefor(substr,table);
		[table,code] = addcode(table,[substr element]);
		code
        outputindex = outputindex+1;
		startindex = index;
    else
		% go on looping
	end
end

% Collect remainning character in the input string
substr = vector(startindex:index);

% Get the code for this character.
output(outputindex) = getcodefor(substr,table);

% Remove not used positions
output((outputindex+1):end) = [];
end

% ###############################################
function code = getcodefor(substr,table)
code = uint16([]);
if length(substr)==1
	code = substr;
else % this is to skip the first 256 known positions
	for index=257:length(table),
		if isequal(substr,table{index}),
			code = uint16(index-1);   % start from 0
			break
		end
	end
end
end

% ###############################################
function [table,code] = addcode(table,substr)
code = length(table)+1;   % start from 1
table{code} = substr;
code = uint16(code-1);    % start from 0
end

% ###############################################
function [output,table] = decode(vector)

% ensure to handle uint8 input vector
if ~isa(vector,'uint16'),
	error('input argument must be a uint16 vector')
end

% vector as a row
vector = vector(:)';

% Initialize ASCII table.
table = cell(1,256);
for index = 1:256,
	table{index} = uint16(index-1);
end

% Initialize output
output = uint8([]);

% Get the character of the coded word.
code = vector(1);
output(end+1) = code;
character = code;

% Till end of the coded word repeat
for index=2:length(vector),
	element = vector(index);
        % Get the element and its ASCII value and see if its in table.
	if (double(element)+1)>length(table)
		% If not then add it to the table.
		string = table{double(code)+1};
		string = [string character];
    
    else       % If present then get the corresponding string.
		string = table{double(element)+1};
    end
    
    % Add the decompressed character to the OUTPUT.
	output = [output string];
	character = string(1);
    
    % Add translation of OLD_CODE + CHARACTER to the translation table
	[table,code] = addcode(table,[table{double(code)+1} character]);
	code = element;
end
end