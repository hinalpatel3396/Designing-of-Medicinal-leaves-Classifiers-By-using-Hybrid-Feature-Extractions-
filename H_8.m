function [ F ] = H_8( img )
M = img/sum(img(:));
[m n]=size(img);
pxy=zeros(1,2*m);
for i=1:m
    for j=1:n
pxy(i+j) = pxy(i+j)+M(i,j);
    end
end
for i=2:2*m
    F(i) = pxy(i)*log(pxy(i)+eps);
end
F = -sum(F);

end