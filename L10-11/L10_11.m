load iris.mat
r=randperm(50);
D1=iris(r,:);%第一类打乱
r=randperm(50);
D2=iris(50+r,:);%第二类打乱
r=randperm(50);
D3=iris(100+r,:);%第三类打乱
dataTrainIris=[D1(1:30,2:5);D2(1:30,2:5);D3(1:30,2:5)];
labelTrainIris=[D1(1:30,6);D2(1:30,6);D3(1:30,6)];
dataTestIris=[D1(31:50,2:5);D2(31:50,2:5);D3(31:50,2:5)];
labelTestIris=[D1(31:50,6);D2(31:50,6);D3(31:50,6)];
%%
netiris=newff(dataTrainIris',labelTrainIris',[10,12,100,8],{'tansig','tansig','tansig','tansig'});
netiris.trainParam.epochs = 1000;
netiris.trainParam.goal = 1e-12;
netiris.trainParam.lr = 0.1;
netiris.divideFcn='';
netiris=train(netiris,dataTrainIris',labelTrainIris');
%%
yhatiris=sim(netiris,dataTestIris');
for i=1:60 
    yhatiris(1,i)=round(yhatiris(1,i));
end
flag=0;
for i=1:60
    if labelTestIris(i,1)==yhatiris(1,i)
        flag=flag+1;
    end
end
pos=flag/60;
%%
load mnist.mat

layers = [
    imageInputLayer([28 28 1],"Name","imageinput")
    convolution2dLayer([5 5],6,"Name","conv-1","Padding",[2 2 2 2])
    sigmoidLayer("Name","sigmoid_1")
    averagePooling2dLayer([2 2],"Name","avepool-1","Stride",[2 2])
    convolution2dLayer([5 5],16,"Name","conv-2")
    sigmoidLayer("Name","sigmoid_2")
    averagePooling2dLayer([2 2],"Name","avepool-2","Stride",[2 2])
    flattenLayer("Name","flatten")
    fullyConnectedLayer(120,"Name","fc-1")
    tanhLayer("Name","sigmoid_3")
    fullyConnectedLayer(84,"Name","fc-2")
    tanhLayer("Name","sigmoid_4")
    fullyConnectedLayer(10,"Name","fc-3")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];

options = trainingOptions('sgdm', ...        
    'LearnRateSchedule','piecewise', ...      
    'LearnRateDropFactor',0.1, ...   
    'Shuffle','every-epoch', ... 
    'LearnRateDropPeriod',5, ...
    'MaxEpochs',10, ...                       
    'MiniBatchSize',256, ...     
    'Plots','training-progress'); 


size=[28,28,1];
aug=augmentedImageDatastore(size,trainData,trainLabels);

net=trainNetwork(aug,layers,options); 
%%
yhat=classify(net,testData);
flag=0;
for i=1:10000
    if testLabels(i,1)==yhat(i,1)
        flag=flag+1;
    end
end
pos=flag/10000;