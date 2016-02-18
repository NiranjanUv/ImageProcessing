% LZ77 compression Algorithm
function [timeC,timeDC,sourcestr,decoded] = LZ77()

clc;
close all;

prompt = 'Enter the character string to Encode: ';
sourcestr = input(prompt);

% Declaring Dictionary and Buffer Size
searchWindowLen=31;
lookAheadWindowLen=31;

fprintf('LZ77-Compression started.');      
sourcestr=[sourcestr '$'];

% Encoding the string. Calling the function Encode.
coded=encode(sourcestr,searchWindowLen,lookAheadWindowLen);

fprintf('\n LZ77-Compression finished\n');

fprintf('\n LZ77-Decompression started\n');

% Encoding the string. Calling the function Decode.
decoded=decode(coded,searchWindowLen,lookAheadWindowLen);
    
fprintf('\n LZ77-Decompression finished\n');

% Comaparing if the original string and decoded string are equal. 
if(isequal(sourcestr,decoded))
    fprintf('\n Source string and Decompressed string are same');
end
end

% Function which returns part of string based on start and end index
function result=returnPartOfString(str,startindex,endindex)
result=str(startindex:endindex);
end

% ######################################################################
% Encode the string
function compressed=encode(str,searchWindowLen,lookAheadWindowLen)

% Initializing compressed string value
compressed='';

% Codeindex
i=1; 

% while end of source string is reached repeat
while i<=length(str)
                    % Initialize the start index value.
    startindex=i-searchWindowLen;
    if(startindex)<1
        startindex=1;
    end
    
    % Search in the buffer to match the current part of the string
    if(i==1)
        searchBuffer='';
    else
    searchBuffer= returnPartOfString(str,startindex,i-1);
    end   
         
    endindex=i+lookAheadWindowLen-1;

    if(endindex)>length(str)
        endindex=length(str);
    end
    
    % Add to the buffer the string which is coded.
    lookAheadBuffer=returnPartOfString(str,i,endindex);
    
    j=1;
    
    % Add the remainning string left in the source string to "tobesearched".
    tobesearched=returnPartOfString(lookAheadBuffer,1,j);
    
    % Find the string in the buffer to find the repetitions if its already
    % there or part of it is there. 
    
    searchresult=strfind(searchBuffer,tobesearched);
    
    if(numel(lookAheadBuffer) > j)

    % repeat while there is strings still to encode
        while (size(searchresult)~=0)
            j=j+1;
            if(j<=numel(lookAheadBuffer))
             
            tobesearched=returnPartOfString(lookAheadBuffer,1,j);
            searchresult=strfind(searchBuffer,tobesearched);
            else
                break;
            end
        end
    end

    % Find the string in the buffer to find the repetitions if its already
    % there or part of it is there. 
    
    if (j>1)
    tobesearched=returnPartOfString(lookAheadBuffer,1,j-1);
    searchresult=strfind(searchBuffer,tobesearched);
    end

    dim=size(searchresult);

    % If part of the source string is already there then the location and
    % the length of match is found out and coded suitably.
    if(dim>0)
        occur=length(searchBuffer)-searchresult(dim(2))+1;
    else
        occur=0;
    end
    
        
    bytenum=length(dec2bin(searchWindowLen));

    % If the new string is new then add to the start location in the
    % compressed string and concatenate it.
    if(occur~=0)
        compressed=strcatNew(compressed,addZeros(dec2bin(occur),bytenum));
        compressed=strcatNew(compressed,addZeros(dec2bin(j-1),bytenum));
        if(j>searchWindowLen)
            compressed=strcatNew(compressed,addZeros(dec2bin(str(i+j)-0),8));
        else
            compressed=strcatNew(compressed,addZeros(dec2bin(lookAheadBuffer(j)-0),8));
        end
        
    else   % If not then add the lookahead symbol to the buffer.
        % Ignoring 2nd zero in compressed string
        compressed=strcatNew(compressed,addZeros(dec2bin(occur),bytenum));
        if(j>searchWindowLen)
            compressed=strcatNew(compressed,addZeros(dec2bin(str(i+j)-0),8));
        else
            compressed=strcatNew(compressed,addZeros(dec2bin(lookAheadBuffer(j)-0),8));
        end
        
    end

    fprintf('\n<%d,%d,C(%c)>',occur,j-1,lookAheadBuffer(j));
    i=i+j;
end
end

% ######################################################################
% Decode the encoded string
function decompressed=decode(binaryStr,searchWindowLen,lookAheadWindowLen)

%default value.
decompressed='';

% Getting the Dictionary and Buffer Length.
bytenumSW=length(dec2bin(searchWindowLen));
bytenumLA=length(dec2bin(lookAheadWindowLen));

% Code index
i=1; 

% while end of the coded word is reached repeat
while i<length(binaryStr)
            % collect the first coded word and collect the part of string
            % from the start position to next symbol.
    SW=returnPartOfString(binaryStr,i,i-1+bytenumSW);
    SWdec=bin2dec(SW);
    i=i+bytenumSW;    
    if(SWdec~=0)
        LA=returnPartOfString(binaryStr,i,i-1+bytenumLA);
        LAdec=bin2dec(LA);
        i=i+bytenumLA;
    else
        LAdec=0;
    end
    
    % Get the string/character and convert it to decimal.
    Chr=returnPartOfString(binaryStr,i,i-1+8);
    Chrch=char(bin2dec(Chr));
    i=i+8;

    
    if(SWdec==0)   % Concatetnate the decompresed part of the strings.
        decompressed=strcatNew(decompressed,Chrch)
 
    else           % Obtain the location from where repetitions should happen in the decompressed string.
        location=length(decompressed)-SWdec;
        
        % After having the location repeat the string at the end of the
        % decompressed string.
        for j=1:LAdec
        decompressed=strcatNew(decompressed,decompressed(location+j))
                
        end
        decompressed=strcatNew(decompressed,Chrch)

    end    
end
end

% ########################################################################
% Function to addzeros to the length of matched string in the buffer.
function str=addZeros(str,num)

for i=1:(num-length(str))
    str=strcatNew('0',str);
end
end

% ########################################################################
% Function to concatenate the strings
%--------------------------------------------------------------------------
function str=strcatNew(first,second)
str=[first second];
end
