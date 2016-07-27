

p1 = fopen(['DecoderData\' nms{n}]);

img = {NaN(512,512,3)};
imgC = repmat(img,length(nms),1);  %variable for codeblock coefficients
imgE = repmat(img,length(nms),1);  %variable for codeblock error

img2 = NaN(512,512,3);
for n = 1:length(coeffdata)



if p1<0
    fclose('all');
    continue;
end

dat = NaN(5000,1);
n0 = 1;
ln = fgetl(p1);
while ischar(ln)
    dat(n0) = str2double(ln);
    ln = fgetl(p1);
    n0 = n0 + 1;
end
fclose(p1);
dat(isnan(dat)) = [];
cw = round(dat(6));
ch = round(dat(7));
tmp = reshape(dat(8:end),ch,cw)';
tmp = tmp ./ max(abs(tmp(:))); %Normalize each codeblock for viewing
pos = round(dat(1:2));

imgC{n}(pos(2)+1:pos(2)+ch,pos(1)+1:pos(1)+cw,str2double(nms{n}(2))+1) = tmp;
tmp(:) = dat(3);  %codeblock max error
imgE{n}(pos(2)+1:pos(2)+ch,pos(1)+1:pos(1)+cw,str2double(nms{n}(2))+1) = tmp;

disp(n);
end

tmp = 0;
for n = 1:length(imgC)
    tmp = tmp + imgC{n};
end


% figure
% subplot(1,3,1)
% imshow(img(:,:,1),[]);
% subplot(1,3,2)
% imshow(img(:,:,2),[]);
% subplot(1,3,3)
% imshow(img(:,:,3),[]);
% 
% figure
% subplot(1,3,1)
% imagesc(img
% subplot(1,3,2)
% imshow(img2(:,:,2),[]);
% subplot(1,3,3)
% imshow(img2(:,:,3),[]);
