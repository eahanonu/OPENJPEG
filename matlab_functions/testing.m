

img = reshape(randperm(256),16,16);
img2 = nan(2*size(img));
img3 = nan(2*size(img2));

for x0 = 1:size(img,2)
    for y0 = 1:size(img,1)
        img2(2*x0-1,2*y0-1) = img(x0,y0);
        img2(2*x0,2*y0-1) = img(x0,y0);
        img2(2*x0-1,2*y0) = img(x0,y0);
        img2(2*x0,2*y0) = img(x0,y0);
    end
end

for x0 = 1:size(img2,2)
    for y0 = 1:size(img2,1)
        img3(2*x0-1,2*y0-1) = img2(x0,y0);
        img3(2*x0,2*y0-1) = img2(x0,y0);
        img3(2*x0-1,2*y0) = img2(x0,y0);
        img3(2*x0,2*y0) = img2(x0,y0);
    end
end

imagesc(img)
figure
imagesc(img2)
figure
imagesc(img3)


np = 0:decdata(1,11)/2:30; 
nt = [fliplr(-np(2:end)),np];