function [ featureF ] = shapE( L )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
s = regionprops(L,'centroid','EquivDiameter','Solidity','Eccentricity','Extent','Area','Perimeter','MajorAxisLength','MinorAxisLength','ConvexArea');
area_values = [s.Area];
mx=find(area_values==max(area_values));
shp=struct('Centoid1',s(mx).Centroid(1),'Centoid2',s(mx).Centroid(2),'EquivDiameter',s(mx).EquivDiameter,'Solidity',s(mx).Solidity,'Eccentricity',s(mx).Eccentricity,'Extent',s(mx).Extent,'Area',s(mx).Area,'Perimeter',s(mx).Perimeter,'MajorAxisLength',s(mx).MajorAxisLength,'MinorAxisLength',s(mx).MinorAxisLength,'ConvexArea',s(mx).ConvexArea);
feature=cell2mat(struct2cell(shp));
feature=feature';
featureF(1:9)=feature(1);
featureF(9:18)=feature(2);
%eqdia
featureF(19)=feature(3);
%solid
featureF(20)=feature(4);
%accen
featureF(21)=feature(5);
%extend
featureF(22)=feature(6);
%Compactness
cpt=4*pi*(feature(7)/feature(8)^2);
featureF(23)=cpt;
%asprto
aspx=feature(9)/feature(10);
featureF(24)=aspx;
%entirety
entrr=(feature(11)-feature(7))/feature(7);
featureF(25)=entrr;
%periratio
perrat=feature(8)/(feature(9)+feature(10));
featureF(26)=perrat;
end

