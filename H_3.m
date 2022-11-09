function [ F ] = H_3( img )
M = img/sum(img(:));
[m n]=size(img);
py = sum(M,1);
px = sum(M,2);
for i=1:m
    for j=1:n
    F(i,j) = i*j*M(i,j);
    end
end
ux = mean(px); sx=std(px);
uy = mean(py); sy=std(py);
F =(sum(F(:))-(ux*uy))/(sx*sy);
end