% This is the Enigma function that accept a file name as a parameter and ..
%   crypto the content of the file using Enigma technology, then write it
%   to a file
function ENIGMA(fileName)
    %Generate txt file
    fileToRead = strcat(fileName, ".txt");
    
    %Read text from file
    plainText = fileread(fileToRead);
    
    %Find Uppers and alphabet characters
    uppers = isstrprop(plainText,'upper');
    alpha = isstrprop(plainText,'alpha');
    
    %Load the provided reflector and rotors
    load Reflector.mat
    load Rotors.mat
    
    %Generate an empty cipher text
    cipherTxt = plainText;
    
    %Generate the counters
    rot1Counter = 1;
    rot2Counter = 1;
    rot3Counter = 1;
        
    %Loop throug all charachters in plain text
    for letterNr = 1:length(plainText)
        %Find position of the character in the Alphabet
        pos = postiton(lower(plainText(letterNr)));
        
        %Check if it's a letter to do the crypto
        if alpha(letterNr) == 1
            % Do the Crypto for all 3 rotors
            r3 = rot3(rot2(rot1(pos)));
            % Reflect
            ref = refl(r3);
            % Do the crypto again other direction
            r1 = rot1(rot2(rot3(ref)));
            
            % Find the letter for this number
            stm = letterRankToLetter(r1);
            
            %Check if the letter is Capital
            if uppers(letterNr) == 1
                % Add to cipher text
                cipherTxt(letterNr) = upper(stm);
            else
                % Add to cipher text
                cipherTxt(letterNr) = stm;
            end
           
            % Change the rotor 1
            rot1Counter = rot1Counter + 1 ;
            rot1 = rot1 + 1;            % All elements + 1
            rot1(rot1 > 26) = 1;        % Replace elements > 26 by 1
            rot1 = circshift(rot1,1);   % All elements moves 1 position 
            if rot1Counter > 26
                rot1Counter = 1;
                rot2Counter = rot2Counter + 1;
                
                % Change the rotor 2
                rot2 = rot2 + 1;            % All elements + 1
                rot2(rot2 > 26) = 1;        % Replace elements > 26 by 1
                rot2 = circshift(rot2,1);   % All elements moves 1 position
                if rot2Counter > 26
                    rot2Counter = 1;
                    rot3Counter = rot3Counter + 1;
                    
                    % Change the rotor 3
                    rot3 = rot3 + 1;            % All elements + 1
                    rot3(rot3 > 26) = 1;        % Replace elements > 26 by 1
                    rot3 = circshift(rot3,1);   % All elements moves 1 position
                    if rot3Counter > 26
                        rot3Counter = rot3Counter + 1;
                    end % End of rot 3
                end % End of rot 2
            end % End of rot 1
        end % End of IF-statment for not a letter
    end % End of For Loop
   
    %Generate the name of the outputfile
    newFile = strcat(fileName, ".enigma.txt");
    
    %Write to the output file
    fid = fopen(newFile, 'w');
    fwrite(fid, char(cipherTxt), 'char');
    fclose(fid);
end

%Function to return the position of the letter in the alphabet
%Link => https://fr.mathworks.com/matlabcentral/answers/124256-trying-to-make-a-function-who-says-the-position-for-a-letter-in-the-alphabet#answer_131819
function h = postiton(letter)
    Alfabetet=['a';'b';'c';'d';'e';'f';'g';'h';'i';'j';'k';'l';'m';'n';'o';'p';'q';'r';'s';'t';'u';'v';'w';'x';'y';'z';];
    h = find(ismember(Alfabetet, letter));
end

%Function to return the letter that refers to a given number
%Link => https://fr.mathworks.com/matlabcentral/answers/41238-turning-numbers-into-letters-based-on-alphabetical-order#answer_50829
function c = letterRankToLetter(n)
    c = char('a'+n-1);
end