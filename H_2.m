function [ F ] = H_2( img )
M = img/sum(img(:));
[m n]=size(img);
px_y=zeros(1,m);
for i=1:m
    for j=1:n
 px_y(abs(i-j)+1) = px_y(abs(i-j)+1)+M(i,j);
    end
end
for k=1:m
    F(k) = (k-1)^2*px_y(k);
end
F = sum(F(:));

end