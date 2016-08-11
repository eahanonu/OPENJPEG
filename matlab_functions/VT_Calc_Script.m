exdir = '../../build/src/bin/jp2/';
%Get the codeblock info
[encdata, enccoeffs, encdist, encdisto] = codeblockinfo([exdir 'encoderdata.dat']);
[decdata, deccoeffs, decsteps] = codeblockinfo([exdir 'decoderdata.dat']);
encdata(:,14:15) = nan(size(encdata,1),2);
decdata(:,14:15) = nan(size(encdata,1),2);
coefvt = cell(length(decsteps),1);
distomat = cell(length(decsteps),1);
coefvtdec = coefvt;

for n0 = 1:size(encdata,1)
    resno = encdata(n0,2);
    comp = encdata(n0,1);
    sig2_uq = encdata(n0,12);
    sig2_q = encdata(n0,13);
    band = encdata(n0,3);
    cstep = encdata(n0,11);
    encdata(n0,14) = VTfind(resno,comp,sig2_uq,band, cstep);
    encdata(n0,15) = VTfind(resno,comp,sig2_q, band, cstep);
    
    
    ustep = unique(decsteps{n0});
    uvt = [];
    for n1 = 1:length(ustep)
        uvt(n1) = VTfind(resno, comp, sig2_q, band, ustep(n1));
    end
    
    coefvt{n0} = zeros(size(decsteps{n0}));
    for n1 = 1:numel(decsteps{n0})
       coefvt{n0}(n1) = uvt(ustep==decsteps{n0}(n1)); 
    end
    
    resno = decdata(n0,2);
    comp = decdata(n0,1);
    sig2_uq = decdata(n0,12);
    sig2_q = decdata(n0,13);
    band = decdata(n0,3);
    cstep = decdata(n0,11);
    decdata(n0,14) = VTfind(resno,comp,sig2_uq,band, cstep);
    decdata(n0,15) = VTfind(resno,comp,sig2_q, band, cstep);

    uvt = [];
    for n1 = 1:length(ustep)
        uvt(n1) = VTfind(resno, comp, sig2_q, band, ustep(n1));
    end
    
    coefvtdec{n0} = zeros(size(decsteps{n0}));
    for n1 = 1:numel(decsteps{n0})
       coefvtdec{n0}(n1) = uvt(ustep==decsteps{n0}(n1)); 
    end
    
    tmp = [];
    for n1 = 1:prod(encdata(n0,8:9))
        tmp(n1) = encdisto{n0}(end-1-decdata(n0,10)) - encdisto{n0}(end-decdata(n0,10));
    end
    tmp = reshape(tmp,encdata(n0,8),encdata(n0,9)).';
    distomat{n0} = tmp;
end

var_err = abs((encdata(:,12) - decdata(:,12))./encdata(:,12))*100;
vtdata = [encdata(:,12), decdata(:,12),var_err, encdata(:,13), decdata(:,13)];

%Want to go through and put the wavelet decomposition map together
img = imread([exdir 'tif_input.tif']);
imgdec = imread([exdir 'tif_output.tif']);
imgd = size(img);
wavdec_q = nan(imgd(1),imgd(2),3);
wavdec_uq = wavdec_q;
wavenc_q = wavdec_q;
wavenc_uq = wavdec_q;
wavdecVT = nan(size(wavdec_q));
wavencVT = nan(size(wavenc_q));
varinfo = nan(size(wavenc_q));
csp = nan(size(wavenc_q));
waverr = wavenc_q;
distinfo = waverr;
for comp = 0:2
    t1 = decdata(decdata(:,1)==comp,:);
    t2 = deccoeffs(decdata(:,1)==comp,:);
    t3 = encdata(encdata(:,1)==comp,:);
    t4 = enccoeffs(encdata(:,1)==comp,:);

    coefs = coefvt(encdata(:,1)==comp);
    coefsdec = coefvtdec(encdata(:,1)==comp);
    %coefs = decsteps(encdata(:,1)==comp);
    
    % 6=x, 7=y
    for n0 = 1:size(t1,1)
        wavdec_uq(t1(n0,5)+1:t1(n0,5)+t1(n0,9),t1(n0,4)+1:t1(n0,4)+t1(n0,8),comp+1) = t2{n0,1};
        wavdec_q(t1(n0,5)+1:t1(n0,5)+t1(n0,9),t1(n0,4)+1:t1(n0,4)+t1(n0,8),comp+1) = t2{n0,2};
        wavenc_uq(t3(n0,5)+1:t3(n0,5)+t3(n0,9),t3(n0,4)+1:t3(n0,4)+t3(n0,8),comp+1) = t4{n0,1};
        wavenc_q(t3(n0,5)+1:t3(n0,5)+t3(n0,9),t3(n0,4)+1:t3(n0,4)+t3(n0,8),comp+1) = t4{n0,2};
        
        csp(t1(n0,5)+1:t1(n0,5)+t1(n0,9),t1(n0,4)+1:t1(n0,4)+t1(n0,8),comp+1) = decsteps{n0};
   
        wavencVT(t1(n0,5)+1:t1(n0,5)+t1(n0,9),t1(n0,4)+1:t1(n0,4)+t1(n0,8),comp+1) = coefs{n0};
        wavdecVT(t1(n0,5)+1:t1(n0,5)+t1(n0,9),t1(n0,4)+1:t1(n0,4)+t1(n0,8),comp+1) = coefsdec{n0};
        
        varinfo(t1(n0,5)+1:t1(n0,5)+t1(n0,9),t1(n0,4)+1:t1(n0,4)+t1(n0,8),comp+1) = abs(t2{n0,1} - (t4{n0,2}/32));

        distinfo(t1(n0,5)+1:t1(n0,5)+t1(n0,9),t1(n0,4)+1:t1(n0,4)+t1(n0,8),comp+1) = encdist{n0};
    end  
end

% 
% %Make some plots
% figure
% imshowpair(img,imgdec,'montage')
%
a1 = wavenc_uq(:,:,1);
a1 = a1 / 30;
a2 = wavdec_q(:,:,1);
%[~, qMap] = spatial_quality(varinfo(:,:,1),6);
% [~, qMap] = spatial_quality(100*abs(a1-a2)./abs(a1),6);
[~, qMap2] = spatial_quality((a1-a2).^2,6);
% [~, qMap3] = spatial_quality(csp(:,:,1).*wavenc_uq(:,:,1),6);
% [~, qMap4] = spatial_quality(distinfo(:,:,1),6);
[~, qMap5] = spatial_quality(wavencVT(:,:,1),6);
[~, qMap6] = spatial_quality(wavdecVT(:,:,1),6);

h=subplot(2,2,1);
set(h,'pos',[0 .5 .5 .5])
imshow(img)
h=subplot(2,2,2);
set(h,'pos',[.5 .5 .5 .5])
imshow(imgdec)
h=subplot(2,2,3);
set(h,'pos',[0 0 .5 .5])
imagesc(qMap5)
colorbar
axis image
axis off
h=subplot(2,2,4);
set(h,'pos',[.5 0 .5 .5])
imagesc(qMap6)
colorbar
axis image
axis off






