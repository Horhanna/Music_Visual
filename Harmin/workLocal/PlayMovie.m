function AdaptContMovie = PlayMovie(matFile)
load(matFile);
nSegs = size(costFunction, 1);
for i=1:nSegs
    f = squeeze(costFunction(i, :, :));
    a = squeeze(adaptFunction(i, :, :));
    c = squeeze(contFunction(i, :, :));
    minAdapt = min(min(a));
    maxAdapt = max(max(a));
    minCont = min(min(c));
    maxCont = max(max(c));
    minFunct = min(min(f));
    maxFunct = max(max(f));
    origChord = origSegs(i).chord;
    origIndex = origSegs(i).index;
    nRows = size(a, 1);
    nCols = size(a, 2);
    if (origChord ~= 256)
        for j=1:nRows
            for k=1:nCols-1
                if(a(j, k) == -1)
                    a(j,k) = a(origChord, origIndex);
                    c(j,k) = c(origChord, origIndex);
                    f(j,k) = f(origChord, origIndex);
                end        
            end
            %a(j, nCols) = a(origChord, origIndex);
        end
    else
        for j=1:nRows
            for k=1:nCols-1
                if(a(j, k) == -1)
                    a(j,k) = 0;
                    c(j,k) = 0;
                    f(j,k) = 0;
                end        
            end
        end
    end    
    varAdapt = (maxAdapt-minAdapt)/nRows;
    varCont = (maxCont-minCont)/nRows;
    varFunct = (maxFunct-minFunct)/nRows;
    for j=1:nRows
        a(j, nCols) = minAdapt + varAdapt*(nRows-j);
        c(j, nCols) = minCont + varCont*(nRows-j);
        f(j, nCols) = minFunct + varFunct*(nRows-j);
    end
    subplot(2,2,1);
    
    imagesc(f);
    title(titles(i).text);
    subplot(2,2,2);
    surfc(f);
    subplot(2,2,3);
    imagesc(a);
    title('adaptation');
    subplot(2,2,4);
    imagesc(c);
    title('continuation');
    AdaptContMovie(1) = getframe(gcf);
    %pause;
end