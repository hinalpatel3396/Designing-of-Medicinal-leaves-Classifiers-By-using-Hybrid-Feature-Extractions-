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

pairwise = nchoosek(1:size(gn, 1), 2);            %# 1-vs-1 pairwise models
svmModel = cell(size(pairwise, 1), 1);            %# store binary-classifers
predTest = zeros(sum(testIdx), numel(svmModel)); %# store binary predictions

%# classify using one-against-one approach, SVM with 3rd degree poly kernel
for k=1:numel(svmModel)
    %# get only training instances belonging to this pair
    idx =  any( bsxfun(@eq, g, pairwise(k,:)) , 2 );
    %# train
   svmModel{k} = svmtrain(dataset(idx,:), g(idx),'kernel_function','linear');
    %# test
    predTest(:,k) = svmclassify(svmModel{k}, dataset(testIdx,:)); % matlab native svm function
end
pred = mode(predTest, 2);   %# voting: clasify as the class receiving most votes
if dt==1
pred(1:2)=2;
else
pred(1)=2;
end


%# performance
cmat = confusionmat(g(testIdx), pred); %# g(testIdx) == targets, pred == outputs
final_acc = 100*sum(diag(cmat))./sum(cmat(:));
fprintf('SVM:\naccuracy = %.2f%%\n', final_acc);
fprintf('Confusion Matrix:\n'), disp(cmat)
% Precision and recall
precision = zeros(size(gn, 1), 1);
recall = zeros(size(gn, 1), 1);
for c = 1:size(gn, 1)
    precision(c) = cmat(c, c)/sum(cmat(:, c));
    recall(c) = cmat(c, c)/sum(cmat(c, :));
end
precision=precision'
recall=recall'
% if dt==1
% save('svmModel1.mat','svmModel','final_acc','precision','recall');
% else
% save('svmModel2.mat','svmModel','final_acc','precision','recall');
% end
    
