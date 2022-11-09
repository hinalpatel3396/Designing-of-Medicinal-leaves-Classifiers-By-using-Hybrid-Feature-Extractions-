function [feature]=colorF(img)
for i=1:3
%Mean
[pixelcount gls]=imhist(img(:,:,i)); %gls is gray level scale
noofpixel=sum(pixelcount);
Mean1(i)=sum(gls.*pixelcount)/noofpixel;
%Standard Deviation
variance=sum((gls-Mean1(i)).^2.*pixelcount)/(noofpixel-1);
stddeviation1(i)=sqrt(variance);
end

img=rgb2hsv(img);

for i=1:3
%Mean
[pixelcount gls]=imhist(img(:,:,i)); %gls is gray level scale
noofpixel=sum(pixelcount);
Mean(i)=sum(gls.*pixelcount)/noofpixel;
%Standard Deviation
variance=sum((gls-Mean(i)).^2.*pixelcount)/(noofpixel-1);
stddeviation(i)=sqrt(variance);
end

feature=[Mean1,stddeviation1,Mean,stddeviation];
end