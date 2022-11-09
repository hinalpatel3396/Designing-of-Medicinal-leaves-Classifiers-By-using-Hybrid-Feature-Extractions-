function [veinfeatures] = veinF(binimg,filtimg)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
SE1=strel('disk',1);
SE2=strel('disk',2);
SE3=strel('disk',3);
SE4=strel('disk',4);
O1=imopen(binimg,SE1);
O2=imopen(binimg,SE2);
O3=imopen(binimg,SE3);
O4=imopen(binimg,SE4);
R1=imsubtract(filtimg,uint8(O1));
R2=imsubtract(filtimg,uint8(O2));
R3=imsubtract(filtimg,uint8(O3));
R4=imsubtract(filtimg,uint8(O4));
th1=graythresh(R1);
th2=graythresh(R2);
th3=graythresh(R3);
th4=graythresh(R4);

bw1=im2bw(R1,th1);
bw2=im2bw(R2,th2);
bw3=im2bw(R3,th3);
bw4=im2bw(R4,th4);


A=bwarea(binimg);

A1=bwarea(bw1);
A2=bwarea(bw2);
A3=bwarea(bw3);
A4=bwarea(bw4);

V1=A1/A;
V2=A2/A;
V3=A3/A;
V4=A4/A;

veinfeatures=[V1 V2 V3 V4];

end

