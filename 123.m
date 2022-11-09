[file path]=uigetfile('*.*','Select Leaf Image');
img=imresize(imread([path file]),[128 128]);
gr=rgb2gray(img);

imshow(gr);
figure;