function [cMat, qMap] = spatial_quality( dmat, levels )
%spatial_quality get spatial quality from wavelet decomposition
%Assumes a power of 2 square image size for now...

%Starting index, top left corner of HL subband
xp = size(dmat,2)/2 + 1;

cMat = nan(prod(size(dmat)/2), 100);
%cLoc = nan(prod(size(dmat)/2),8);
qMap = nan(size(dmat));

n0 = 1;
for x0 = xp:size(dmat,2)
    for y0 = 1:(size(dmat,2)/2)
        
        %Location in full image
%         cLoc(n0,1) = 2*(x0-xp)+1;
%         cLoc(n0,2) = 2*y0-1;
%         cLoc(n0,3) = 2*(x0-xp)+2;
%         cLoc(n0,4) = 2*y0-1;
%         cLoc(n0,5) = 2*(x0-xp)+1;
%         cLoc(n0,6) = 2*y0;
%         cLoc(n0,7) = 2*(x0-xp)+2;
%         cLoc(n0,8) = 2*y0;
        
        cMat(n0,1) = dmat(y0,x0); %HL
        cMat(n0,2) = dmat(y0+xp-1,x0); %HH
        cMat(n0,3) = dmat(y0+xp-1,x0-xp+1); %LH
        
        for n1 = 1:levels-2
           cMat(n0,n1+3) = dmat(ceil(y0/(2^n1)), ceil(x0/(2^n1))); %HL
           cMat(n0,n1+(levels-2)+3) = dmat(ceil((xp+y0-1)/(2^n1)), ceil(x0/(2^n1))); %HH
           cMat(n0,n1+2*(levels-2)+3) = dmat(ceil((xp+y0-1)/(2^n1)), ceil(x0/(2^n1))); %LH
        end
        
        cMat(n0,(levels-2)+2*(levels-2)+4) = dmat(ceil(y0/(2^n1)), ceil(x0/(2^n1)) - (2^(levels-2)));
        
        %Quality map based on avg VT
        %Q = nanmean(cMat(n0,:));
        tmp = cMat(n0,~isnan(cMat(n0,:))); 
        Q = (sum(tmp.^4)/16).^(1/4);  %Minkowski, p=4
        %Q = max(tmp);
        qc = 2*(x0-xp)+1;
        qr = 2*y0-1;
        qMap(qr,qc) = Q;
        qMap(qr+1,qc) = Q;
        qMap(qr,qc+1) = Q;
        qMap(qr+1,qc+1) = Q;
        
        
        n0 = n0 + 1;
    end
end

cMat = cMat(:,~isnan(cMat(1,:)));
end
