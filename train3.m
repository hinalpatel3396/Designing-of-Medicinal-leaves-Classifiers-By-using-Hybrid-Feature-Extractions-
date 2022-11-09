clc
close all
clear all


load('Train_Dataset.mat')
dt=2;
if dt==1
dataset=[trdataset_E]; %base paper
else
dataset=[trdataset_P];
end

[g gn] = grp2idx(trclass);

%# split training/testing sets
[trainIdx testIdx] = crossvalind('HoldOut', trclass, 0.20); % split the train and test labels 
traind=find(trainIdx==1);

B=TreeBagger(50,dataset,trclass,'Method','classification');
testd=find(testIdx==1);
Predicte=B.predict(dataset(testd,:));
%view(B.Trees{50},'Mode','graph');
for i=1:length(Predicte)
P(i,:)=str2num(Predicte{i});
end
cmat = confusionmat(g(testIdx), P); %# g(testIdx) == targets, pred == outputs
final_acc = 100*sum(diag(cmat))./sum(cmat(:));
fprintf('RF:\naccuracy = %.2f%%\n', final_acc);
fprintf('Confusion Matrix:\n'), disp(cmat)
% Precision and recall
precision = zeros(size(gn, 1), 1);
recall = zeros(size(gn, 1), 1);
for c = 1:size(gn, 1)
    precision(c) = cmat(c, c)/sum(cmat(:, c));
    recall(c) = cmat(c, c)/sum(cmat(c, :));
end
precision'
recall'


% save('RF2.mat','B','final_acc','precision','recall');