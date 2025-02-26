function [chrSimple, chrLinDist, chrExpDist] = wav2chr(FileName)
chrSimple = zeros(12,1);
chrLinDist = zeros(12,1);
chrExpDist = zeros(12,1);
nci = zeros(12,1); %number of chroma instances
slcd = zeros(12,1); %sum of linear chroma distances
secd = zeros(12,1); %sum of exponential chroma distances
[buf, fs, b] = wavread(FileName);
hw = hann(length(buf));
hb = hw.*buf;
sp = abs(fft(hb));
sSpect = size(sp,1);
firstBin = ceil(50*sSpect/fs);
lastBin = floor(5000*sSpect/fs);
%factor = (2^(1/12)-1)/2;
%distMax = ((lastBin)*fs)/(sSpect*2)-((lastBin-1)*fs)/(sSpect*2);
for bin=firstBin:lastBin
    hertz = bin*fs/sSpect;
    exactMidi = 69+12 * log(abs(hertz)/440)/log(2);
    midi=round(exactMidi);
    %distMax = (440 * exp ((ceil(exactMidi)-69) * log(2)/12))*factor;
    distanc = abs(exactMidi - midi);
    chrBin = mod(midi-1, 12)+1;
    chrSimple(chrBin) = chrSimple(chrBin) + sp(bin);    
    chrLinDist(chrBin) = chrLinDist(chrBin) + sp(bin)*(1 - distanc*2);
    chrExpDist(chrBin) = chrExpDist(chrBin) + sp(bin)*(1 - distanc^2*4);
    slcd(chrBin) = slcd(chrBin) + (1 - (distanc)*2);
    secd(chrBin) = secd(chrBin) + (1 - (distanc^2)*4);
    nci(chrBin) = nci(chrBin) + 1;
end
cEDMax = 0;
cEDMin = inf;
for i=1:12
    if(secd(i)~=0)
        chrExpDist(i) = chrExpDist(i)/secd(i);
        if (chrExpDist(i) > cEDMax)
            cEDMax = chrExpDist(i);
        end
%         if (chrExpDist(i) < cEDMin)
%             cEDMin = chrExpDist(i);
%         end
    end
end
cEDMin = 0.0;
for i=1:12
    chrExpDist(i) = (chrExpDist(i)-cEDMin)/(cEDMax-cEDMin);
    chrExpDist(i) = chrExpDist(i) * chrExpDist(i);
end
cLDMax = 0;
cLDMin = inf;
for i=1:12
    if(slcd(i)~=0)
        chrLinDist(i) = chrLinDist(i)/slcd(i);
        if (chrLinDist(i) > cLDMax)
            cLDMax = chrLinDist(i);
        end
%         if (chrLinDist(i) < cLDMin)
%             cLDMin = chrLinDist(i);
%         end
    end
end
cLDMin = 0.0;
for i=1:12
    chrLinDist(i) = (chrLinDist(i)-cLDMin)/(cLDMax-cLDMin);
    chrLinDist(i) = chrLinDist(i) * chrLinDist(i);
end
cSMax = 0;
cSMin = inf;
for i=1:12
    if(nci(i)~=0)
        chrSimple(i) = chrSimple(i)/nci(i);
        if (chrSimple(i) > cSMax)
            cSMax = chrSimple(i);
        end
%         if (chrSimple(i) < cSMin)
%             cSMin = chrSimple(i);
%         end
    end
end
cSMin = 0.0;
for i=1:12
    chrSimple(i) = (chrSimple(i)-cSMin)/(cSMax-cSMin);
    chrSimple(i) = chrSimple(i) * chrSimple(i);
end