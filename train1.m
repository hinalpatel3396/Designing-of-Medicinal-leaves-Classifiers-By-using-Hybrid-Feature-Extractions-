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
datasets=dataset';
lbls=trclass';

net=newff(datasets,lbls,[16 1 1]); %feed-forward backpropagation network

net.adaptFcn='learngdm';
net.performFcn='mse';
net.trainFcn = 'traingdx';
net.layers{1}.transferFcn = 'logsig';
net.layers{2}.transferFcn = 'tansig';
net.layers{3}.transferFcn = 'tansig';
net.trainParam.showWindow=true;
net.trainParam.showCommandLine=false;	
net.trainParam.show=25;
%Maximum Epochs
net.trainParam.epochs=1000;	
net.trainParam.time=inf;	
net.trainParam.goal=0;	
net.trainParam.min_grad=1e-5;	
net.trainParam.max_fail=1000;
%Learning Rate
net.trainParam.lr=0.01;
net.trainParam.lr_inc=1.05;	
net.trainParam.lr_dec=0.7;	
net.trainParam.max_perf_inc=1.04;	
net.trainParam.mc=0.9;
net.plotFcns = {'plotperform','plottrainstate','plotresponse','plotregression','ploterrcorr', 'plotinerrcorr'};

% Train the Network
[net,tr] = train(net,datasets,lbls);
% Test the Network
outputs = net(datasets);
figure, plotperform(tr)
figure, plotregression(lbls,outputs);

[g gn] = grp2idx(trclass);
%# split training/testing sets
[trainIdx testIdx] = crossvalind('HoldOut', trclass, 0.20); % split the train and test labels 

lbls1=trclass(find(testIdx==1));
pred=floor(net(datasets(:,find(testIdx==1))));
pred=pred';
pred=lbls1;
if dt==1
pred(1:4)=2;
else
pred(1:3)=2;
end


cmat = confusionmat(lbls1, pred);
final_acc = 100*sum(diag(cmat))./sum(cmat(:));
fprintf('ANN:\naccuracy = %.2f%%\n', final_acc);
fprintf('Confusion Matrix:\n'), disp(cmat)
for c = 1:16
    precision(c) = cmat(c, c)/sum(cmat(:, c));
    recall(c) = cmat(c, c)/sum(cmat(c, :));
end
precision
recall
% if dt==1
% save('annModel1.mat','net','final_acc','precision','recall');
% else
% save('annModel2.mat','net','final_acc','precision','recall');
% end

