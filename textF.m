function [F] = textF(gr,seg)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
gr=im2double(gr);
%Contras
F(1)= H_2(gr);
%sAVEG
F(2)= H_6(gr);
%SeNT
F(3)= H_8(gr);
%Correlation
F(4)= H_3(gr);
F(5)= H_3(gr);

%Contras
F(6)= H_2(seg);
%s7VEG
F(7)= H_6(seg);
%SeNT
F(8)= H_8(seg);
%Correlation
F(9)= H_3(seg);
F(10)= H_3(seg);


end

