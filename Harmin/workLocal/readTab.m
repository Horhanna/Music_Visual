function seq = readTab(fileName, outputFileName)
fid = fopen(fileName, 'rt');
oFile = fopen(outputFileName,'wt');
y = 0;
seq = [];
classNumber = 255;
while feof(fid) == 0
    y = y + 1;
    curLine = fgetl(fid);     
    [tline, curLine] = strtok(curLine);
    while (length(tline) > 0)
        numLettersRoot = 1;
        accident = 0;
        if (strcmp(tline, '<255>'))
            fprintf(oFile, '255 \n');
            seq = [seq; 255];
            [tline, curLine] = strtok(curLine);
            continue;
        elseif(strcmp(tline, 'garbage'))
            fprintf(oFile, '\n');
            seq = [seq; 240];
            [tline, curLine] = strtok(curLine);
            continue;
        elseif(strcmp(tline, '/'))
            fprintf(oFile, '%d \n', classNumber);    
            seq = [seq; classNumber];
            [tline, curLine] = strtok(curLine);
            continue;
        elseif(length(tline) > 1)
            if(tline(2) == '#' )
                numLettersRoot = 2;
                accident = 1;
            elseif(tline(2) == 'b' )
                numLettersRoot = 2;
                accident = -1;
            end
        end
        switch (tline(1))
            case 'C'
                root = 0;
            case 'D'
                root = 2;
            case 'E'
                root = 4;
            case 'F'
                root = 5;
            case 'G'
                root = 7;
            case 'A'
                root = 9;
            case 'B'
                root = 11;
            otherwise
                disp('something strange with the root note');
        end
        root = root + accident;
        typeStr = tline(numLettersRoot+1:length(tline));
        if(length(typeStr) == 0)
            type = 0; %'' did not work
        else
            seventh = 0;        
            [typeStr, rest] = strtok(typeStr, '/');
            barInd = findstr('/',tline);
            if(length(barInd) > 0)
                if(barInd(1) == numLettersRoot + 1)
                    rest = ['/' typeStr];
                    typeStr = '';
                end
            end
            if(length(rest) > 1)
                [interval, bStr] = compInterval(root, rest);
                if(interval == 10)
                    seventh = 1;
                end
                typeStr = [typeStr bStr];
            end
            
            switch(typeStr)
            case {'', '7M', '7M(9)','6','6/9', '4','7M(#11)', '7M(#5/9)', '7M(6/9)', '6(9)', '7M(#5)', '7M(6)', '(add9)'}
                type = 0 + seventh;
            case {'7','7/4','7(b9)','7(9)','7(#9)','7(13)','7(b13)','7(b9','7(b5)','7(#11)','7(#5)','7(9', '4/7(9)','7(b9/b13)','4/7','4/7(13)','7(9/#11)','7/4(b9)','4/7(b9)', 'aug', '7(b9/#11)', '7(b9/13)','7(9/13)'}
                type = 1;
            case {'m', 'm6', 'm(b6)', 'min', 'm6(9)', 'm7M', 'm7M(9)', 'm(7M)'}
                type = 2 + seventh;
            case {'m7', 'm7(b5)','m7(9)','m7(11)','m7(b5','m7(b5/9)','min7'}
                type = 3;
                case {'�','�(b13)'}
                    type = 4;
                otherwise
                    disp(typeStr);
                    disp(y);
                    pause;
            end
        end
        %disp(tline);
        %disp(root);
        %disp(type);
        classNumber = root * 5 + type;
        fprintf(oFile, '%d \n', classNumber);    
        seq = [seq; classNumber];
        [tline, curLine] = strtok(curLine);
    end
end
fclose(fid); 
fclose(oFile);

function [i, backStr] = compInterval(root, invStr)
    accident = 0;
    backStr = '';
    if(length(invStr) > 2)
        if(invStr(3) == '#' )
            accident = 1;
        elseif(invStr(3) == 'b' )
            accident = -1;
        end
    end
    switch (invStr(2))
        case 'C'
            inv = 0;
        case 'D'
            inv = 2;
        case 'E'
            inv =  4;
        case 'F'
            inv =  5;
        case 'G'
            inv =  7;
        case 'A'
            inv =  9;
        case 'B'
            inv =  11;
        otherwise
            %disp('something strange with the inversion');
            %disp(invStr);
            backStr = invStr;
            i = 0;
            return;
    end
    inv = inv + accident;
 i = mod(inv - root, 12);