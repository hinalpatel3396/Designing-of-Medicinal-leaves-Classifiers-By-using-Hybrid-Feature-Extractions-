function [feature] = Zk_Hu_Feat(img,seg)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
[Z A Phi] = Zernikmoment(seg,4,2);
eta_mat = SI_Moment(img,seg); 
feature = [real(Z),A,Phi,1,Hu_Moments(eta_mat)];
end

