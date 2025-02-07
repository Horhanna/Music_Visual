function Segment29400(directory)
ind = [1;2;3;4;5;6;7;8;9;10;11;12];
cd(directory);
mkdir('tempSeg');
files = dir;
dbFile = fopen('revisedChroma.db','w');
h = hann(29400);
segs = [];
for i=3:length(files)
    disp(files(i).name);
    [fName1, r] = strtok(files(i).name, '.');
    if(~isempty(findstr(lower(files(i).name),'.wav')))
        [w, nb, fr] = wavread(files(i).name);
        for k=1:length(w)/29400
            firstSample = (k - 1) * 29400 + 1;
            lastSample = k * 29400;
            w2 = w(firstSample:lastSample,1);
            w3 = zeros(32768, 1);
            w3(3685:33084) = h.*w2;
            fName2 = sprintf('tempSegs\\%s_%0.3d.wav',fName1,k);
            wavwrite(w3, nb, fr, fName2);
            
              [chromaSimple, chromaLinWeighted, chromaExpWeighted] = wav2chr(fName2);
              fprintf(dbFile, '%s\t %0.3d\n\r',files(i).name,k);
              for j=1:12
                  fprintf(dbFile, ' %0.4f', chromaSimple(j));
              end
              fprintf(dbFile, '\n\r');      
              for j=1:12
                  fprintf(dbFile, ' %0.4f', chromaLinWeighted(j));
              end
              fprintf(dbFile, '\n\r');      
              for j=1:12
                  fprintf(dbFile, ' %0.4f', chromaExpWeighted(j));
              end
              fprintf(dbFile, '\n\r');      
              ordered = indexsort(chromaExpWeighted, ind);
              for j=1:12
                  fprintf(dbFile, ' %d', ordered(j));
              end
              fprintf(dbFile, ' \n\r');      
        end
    end
end
%% cleaning...
cd('tempSeg');
files = dir;
for i=3:length(files)
    delete(files(i).name);
end
cd ..
rmdir('tempSeg')