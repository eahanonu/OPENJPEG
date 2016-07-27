function waveletcdf97_demo
%Demo for waveletcdf97

% Pascal Getreuer 2006


%%% Image approximation demo %%%

fprintf(['\n*** Wavelet Image Approximation ***\n',...
      'This demo applies waveletcdf97 to image approximation.  First,\n',...
      'the input image is converted from RGB to the JPEG Y''CbCr\n',...
      'colorspace.  The Y''CbCr image is transformed using waveletcdf97,\n',...
      'all but the largest transform coefficients are set to zero, and\n',...
      'then inverse transformed.\n\n']);

ImageFile = '../tif_input.tif';

% Load the demo image, a photograph of a palm tree
X = double(imread(ImageFile))/255;
N = size(X);

figure; colormap(gray(256));
subplot(2,1,1);
image(X);
axis image; axis off;
title(sprintf('Original (%dx%d)',N(2),N(1)));
drawnow;

X = RGBToYCbCr(X);      % Use YCbCr colorspace for processing

subplot(2,2,3);
Y = waveletcdf97(X(:,:,1),1);  % 1-stage transform of the intensity channel
imagesc(abs(Y).^0.5);
axis image; axis off;
title('1-stage transform');
drawnow;

subplot(2,2,4);
Y = waveletcdf97(X(:,:,1),3);  % 3-stage transform
imagesc(abs(Y).^0.5);
axis image; axis off;
title('3-stage transform');
drawnow;

L = 6;
Y = waveletcdf97(X,L);

figure;
drawnow;
subplot(2,2,1);
R = waveletcdf97(keep(Y,1/10),-L);
image(YCbCrToRGB(R));
axis image; axis off;
title(sprintf('10:1 approximation, PSNR %.1f dB',psnr(X,R)));
drawnow;

subplot(2,2,2);
R = waveletcdf97(keep(Y,1/20),-L);
image(YCbCrToRGB(R));
axis image; axis off;
title(sprintf('20:1 approximation, PSNR %.1f dB',psnr(X,R)));
drawnow;

subplot(2,2,3);
R = waveletcdf97(keep(Y,1/40),-L);
image(YCbCrToRGB(R));
axis image; axis off;
title(sprintf('40:1 approximation, PSNR %.1f dB',psnr(X,R)));
drawnow;

subplot(2,2,4);
R = waveletcdf97(keep(Y,1/80),-L);
image(YCbCrToRGB(R));
axis image; axis off;
title(sprintf('80:1 approximation, PSNR %.1f dB',psnr(X,R)));
drawnow;
return;


function X = keep(X,Ratio)
% Set all but the largest elements of X to zero

if size(X,3) > 1
   NumElements = prod(size(X));
   % Number of components to keep in the Y channel
   NumY = floor(NumElements*Ratio*0.92);
   % Number of components to keep in the Cb channel
   NumCb = floor(NumElements*Ratio*0.04);
   % Number of components to keep in the Cr channel
   NumCr = floor(NumElements*Ratio*0.04);

   X(:,:,1) = keep(X(:,:,1),NumY);
   X(:,:,2) = keep(X(:,:,2),NumCb);
   X(:,:,3) = keep(X(:,:,3),NumCr);
   return;
end

if Ratio > 1
   Num = Ratio;
else
   Num = floor(prod(size(X))*Ratio);
end

[tmp,i] = sort(abs(X(:)));
X(i(1:end-Num)) = 0;
return;


function p = psnr(A,B)
% Compute the PSNR value of B relative to A
p = -10*log10(mean((A(:) - B(:)).^2) / (max(A(:)) - min(A(:)))^2);
return;


function X = RGBToYCbCr(X)
% Convert from RGB to JPEG YCbCr colorspace
M = [0.299,0.587,0.114;-0.168736,-0.331264,0.5;0.5,-0.418688,-0.081312];
R = X(:,:,1); G = X(:,:,2); B = X(:,:,3);
X(:,:,1) = M(1)*R + M(4)*G + M(7)*B;  % Intensity Y channel
X(:,:,2) = M(2)*R + M(5)*G + M(8)*B;  % Blue chroma Cb channel
X(:,:,3) = M(3)*R + M(6)*G + M(9)*B;  % Red chroma Cr channel
X = min(max(X,-1),1);  % Clip result to [-1,1]
return;


function X = YCbCrToRGB(X)
% Convert from JPEG YCbCr to RGB colorspace
X = min(max(X,-1),1);
M = inv([0.299,0.587,0.114;-0.168736,-0.331264,0.5;0.5,-0.418688,-0.081312]);
Y = X(:,:,1); Cb = X(:,:,2); Cr = X(:,:,3);
X(:,:,1) = M(1)*Y + M(4)*Cb + M(7)*Cr;  % Red channel
X(:,:,2) = M(2)*Y + M(5)*Cb + M(8)*Cr;  % Green channel
X(:,:,3) = M(3)*Y + M(6)*Cb + M(9)*Cr;  % Blue channel
X = min(max(X,0),1);  % Clip result to [0,1]
return;
