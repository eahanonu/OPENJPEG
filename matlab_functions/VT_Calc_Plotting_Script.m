%VT_Calc_Plotting_Script


%% Plots for coefficients
%Encoder subplots
figure
subplot(2,3,1)
imagesc(wavenc(:,:,1));
axis image
axis off
colorbar
title('Encoder - Y');
subplot(2,3,2)
imagesc(wavenc(:,:,2));
axis image
axis off
colorbar
title('Encoder - Cb');
subplot(2,3,3)
imagesc(wavenc(:,:,3));
axis image
axis off
colorbar
title('Encoder - Cr');

%Decoder subplots
subplot(2,3,4)
imagesc(wavdec(:,:,1));
axis image
axis off
colorbar
title('Decoder - Y');
subplot(2,3,5)
imagesc(wavdec(:,:,2));
axis image
axis off
colorbar
title('Decoder - Cb');
subplot(2,3,6)
imagesc(wavdec(:,:,3));
axis image
axis off
colorbar
title('Decoder - Cr');



%% Plots for VT
%Encoder subplots
figure
subplot(2,3,1)
imagesc(wavencVT(:,:,1));
axis image
axis off
colorbar
title('Encoder - Y');
subplot(2,3,2)
imagesc(wavencVT(:,:,2));
axis image
axis off
colorbar
title('Encoder - Cb');
subplot(2,3,3)
imagesc(wavencVT(:,:,3));
axis image
axis off
colorbar
title('Encoder - Cr');

%Decoder subplots
subplot(2,3,4)
imagesc(wavdecVT(:,:,1));
axis image
axis off
colorbar
title('Decoder - Y');
subplot(2,3,5)
imagesc(wavdecVT(:,:,2));
axis image
axis off
colorbar
title('Decoder - Cb');
subplot(2,3,6)
imagesc(wavdecVT(:,:,3));
axis image
axis off
colorbar
title('Decoder - Cr');
