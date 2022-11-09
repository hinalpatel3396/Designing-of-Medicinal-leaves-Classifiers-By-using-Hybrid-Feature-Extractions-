clc
close all
clear all


trclass=[];
trdataset_E=[];
trdataset_P=[];

d1=uigetdir();
ls1=dir(d1);
ls1(1:2)=[];


for m=1:length(ls1)
mdir=dir([d1 '/' ls1(m).name '/']);
mdir(1:2)=[];
for nn=1:length(mdir)
trclass=[trclass;m];
img=imresize(imread([d1 '/' ls1(m).name '/' mdir(nn).name]),[128 128]);
gr=rgb2gray(img);
gr=medfilt2(gr);
th=graythresh(gr);
seg=~im2bw(gr,th);

%Exi
%shap
F1= shapE(seg);
%color
F2=colorF(img);
%texture
F3= textF(gr,seg);
%invarient
F4= Zk_Hu_Feat(img,seg);
F=[F1,F2,F3,F4];
trdataset_E=[trdataset_E;F];
clear F

%Pro
%S
F1 = ShapP(seg);
%c
F2=colorMoments(img);
%T
offsets = [0 1; -1 1;-1 0;-1 -1];
glcms= graycomatrix(gr,'Offset',offsets);
F3 = graycoprops(glcms);
F3=cell2mat(struct2cell(F3));
F3=F3(:)';
%V
F4=veinF(seg,gr);
F=[F1,F2,F3,F4];
trdataset_P=[trdataset_P;F];
clear F
nn
end
end
data=struct2cell(ls1);
fdata=data(1,:);
save('Train_Dataset.mat','trdataset_E','trdataset_P','trclass','fdata');

