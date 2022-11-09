function [feature] = ShapP(seg)
%UNTITLED7 Summary of this function goes here
s = regionprops(seg,'centroid','Area','Perimeter','MajorAxisLength','MinorAxisLength');
area_values = [s.Area];
mx=find(area_values==max(area_values));
shp=struct('Centoid1',s(mx).Centroid(1),'Centoid2',s(mx).Centroid(2),'Perimeter',s(mx).Perimeter,'MajorAxisLength',s(mx).MajorAxisLength,'MinorAxisLength',s(mx).MinorAxisLength);
feature=cell2mat(struct2cell(shp));
feature=feature';   
end

