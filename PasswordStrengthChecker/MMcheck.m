% Fuction to calculate the score of probability of a how good or bad a
% given password is. This uses the Model.mat file that was produces by my
% MMcreate.m => Low score as result means bad password, also easy to guess.
% High cl means a good password
function score = MMcheck(input)
    load('model.mat');                  % Load the matix MM
    
    pwd = char(input);                  % Change the format to Char
    allValidChars = char(33:126);       % Get all valid chars as a string
    % Convert sting to Array
    validCharsArr = num2cell(allValidChars);
    
    prob = 1;                           % Assign default awnser
    from = 0;                           % Assign the first location
    % loop through the whole password
    for i =1:length(pwd)
        % Get the position of the char from our valid char list
        to = find([validCharsArr{:}] == pwd(i)) + 1;
        
        % If it's the first letter assign from as 1
        if i == 1
            from = 1;
        end
        
        % Get the result from the matrix for the provided location and
        % result it (multiplay with ans)
        prob = prob * MM(from, to);
        
        from = to;                      % Assign from as the to last location 
    end
                    
    score = log(1/prob);                % Calculate the score
end