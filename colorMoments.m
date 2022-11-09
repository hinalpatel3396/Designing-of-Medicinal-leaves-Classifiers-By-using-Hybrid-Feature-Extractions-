function [feature]=colorMoments(img)
for i=1:3
%Mean
[pixelcount gls]=imhist(img(:,:,i)); %gls is gray level scale
noofpixel=sum(pixelcount);
Mean(i)=sum(gls.*pixelcount)/noofpixel;
%Standard Deviation
variance=sum((gls-Mean(i)).^2.*pixelcount)/(noofpixel-1);
stddeviation(i)=sqrt(variance);
%Skewness
skew(i)=sum((gls-Mean(i)).^3.*pixelcount)/((noofpixel-1)*stddeviation(i)^3);
%Kurtosis
kurtosis(i)=sum((gls-Mean(i)).^4.*pixelcount)/((noofpixel-1)*stddeviation(i)^4);
end
Mean=mean(Mean);
stddeviation=mean(stddeviation);
skew=mean(skew);
kurtosis=mean(kurtosis);
feature=[Mean,stddeviation,skew,kurtosis];
end