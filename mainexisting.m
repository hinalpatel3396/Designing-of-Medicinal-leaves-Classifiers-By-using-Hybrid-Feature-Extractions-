clc
close all
clear all

[file path]=uigetfile('*.*','Select leaf image');
img=imread(strcat(path,file));
subplot(1,3,1);
imshow(img);
title('Leaf');
I=rgb2gray(img);
subplot(1,3,2);
imshow(I);
title('Gray Leaf');

%GLCM
offsets = [0 1; -1 1;-1 0;-1 -1];
glcms= graycomatrix(I,'Offset',offsets);
stats1 = graycoprops(glcms)
%OTSU Segmentation
th=graythresh(I);
seg=~(im2bw(I,th));
subplot(1,3,3);
imshow(seg);
title('Segmented Leaf');
%Shap Feature
s = regionprops(seg,'Area','Eccentricity','EquivDiameter','Extent','Solidity');
area_values = [s.Area];
mx=find(area_values==max(area_values));
stats2=struct('Area',s(mx).Area,'Eccentricity',s(mx).Eccentricity,'EquivDiameter',s(mx).EquivDiameter,'Extent',s(mx).Extent,'Solidity',s(mx).Solidity)

%countour Detection
sb=edge(I,'sobel');
pr=edge(I,'prewitt');
rb=edge(I,'roberts');
cn=edge(I,'canny');
figure(2);
subplot(2,2,1);
imshow(sb);
title('Sobbel');
subplot(2,2,2);
imshow(sb);
title('Prewitt');
subplot(2,2,3);
imshow(sb);
title('Robert');
subplot(2,2,4);
imshow(sb);
title('Canny');





