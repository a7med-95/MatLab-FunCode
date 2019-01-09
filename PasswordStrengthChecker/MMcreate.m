% This is a function to create, build and train the matrix based on the
% password list that are given in the text file besides
function MMcreate()
    MM = zeros(95,95);              % Create a matrix of zeors
    
    allValidChars = char(33:126);   % Get all valid chars as a string
    % Convert sting to Array
    validCharsArr = num2cell(allValidChars);
     
    fileToRead = "list.txt";        % Assign file name
    
    fid=fopen(fileToRead);          % Load passwords file data
    tline = fgetl(fid);             % Read lines
   
    % Go throw the list line by line 
    while ischar(tline)
        wholeLine = tline;          % Sting to present the whole line
        
        % Split the whole line into fields, first Number of apperance (nOa)
        % and second the password (pwd) it self
        allParts = strsplit(wholeLine);        
        nOa = str2double(allParts{1});
        pwd = convertStringsToChars(allParts{2});
        
        from = 0;                   % Assign 0 as start value
        % loop through the whole password
        for i =1:length(pwd)
            if from == 0         
                toChar = pwd(i);    % Get the first char in the password
                % Get the position of the char from our valid char list
                to = find([validCharsArr{:}] == toChar);
                
                % Start playing with the matrix
                MM(from + 1 , to + 1) = MM(from + 1 , to + 1) + nOa;
                
                % Update positions on From and To variables
                from = to;
            else                    % For sure, we are not at the begging
                % Update positions on From and To variables
                from = to;
                toChar = pwd(i);
                to = find([validCharsArr{:}] == toChar);
                
                % Update the matrix
                MM(from + 1 , to + 1) = MM(from + 1 , to + 1) + nOa;    
            end
        end
        
        from = 0;                   % Reset from for the next password
        
        % Update to the next word
        tline = fgetl(fid);
    end
    fclose(fid);                    % Close the list file
    
    % Start Normalizing the matrix
    MM = MM./sum(MM,2);

    save('model.mat', 'MM');        % Save the workspace and the MM
end