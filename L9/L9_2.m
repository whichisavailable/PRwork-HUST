% read train labels
fid = fopen('train-labels.idx1-ubyte', 'rb');
trainLabels = fread(fid, inf, 'uint8', 'l');
trainLabels = trainLabels(9:end);
fclose(fid);
% read test labels
fid = fopen('t10k-labels.idx1-ubyte', 'rb');
testLabels = fread(fid, inf, 'uint8', 'l');
testLabels = testLabels(9:end);
fclose(fid);
% read train images
fid = fopen('train-images.idx3-ubyte', 'rb');
trainImages = fread(fid, inf, 'uint8', 'l');
trainImages = trainImages(17:end);
fclose(fid);
trainData = reshape(trainImages, 784, size(trainImages,1) / 784)';
% read test images
fid = fopen('t10k-images.idx3-ubyte', 'rb');
testImages = fread(fid, inf, 'uint8', 'l');
testImages = testImages(17:end);
fclose(fid);
testData = reshape(testImages, 784, size(testImages,1) / 784)';
%%
trainData(:,2:785)=trainData;
trainData(:,1)=1;
testData(:,2:785)=testData;
testData(:,1)=1;
trainData=trainData./10000;
testData=testData./10000;
%%
batchsize=256;
epoch=10;
w0=0.1*randn(785,10);
%%
ypre0=testData*w0;
ypre0=exp(ypre0);
sy=sum(ypre0,2);
ypre0=ypre0./sy;
[maxa,yhat]=max(ypre0,[],2);
yhat=yhat-1;
T=testLabels-yhat;
count=0;
for i=1:10000
    if T(i,1)==0
        count=count+1;
    end
end
pos=count/10000;
%%
eta=0.1;
D=trainData;
ytemp=trainLabels;
yt(60000,10)=0;
for i=1:60000
    yt(i,ytemp(i,1)+1)=1;
end
iter=floor(length(trainData)/batchsize);
w=w0;
for n=1:epoch
    for i=1:iter
        batchi=D((i-1)*batchsize+1:i*batchsize,:);
        S=batchi*w;
        S1=exp(S);
        s=sum(S1,2);
        yh=S1./s;
        Y=yt((i-1)*batchsize+1:i*batchsize,:);
        grad=batchi'*(yh-Y);
        w=w-eta*grad;
    end
    r=randperm(length(D));   %生成关于行数的随机排列行数序列
    D=D(r,:);                %根据这个序列对D进行重新排序
    yt=yt(r,:);
    ytemp=ytemp(r,:);
    
    ypre1=testData*w;
    ypre1=exp(ypre1);
    sy=sum(ypre1,2);
    ypre1=ypre1./sy;
    [maxa,yhat1]=max(ypre1,[],2);
    yhat1=yhat1-1;
    T1=testLabels-yhat1;
    count=0;
    for j=1:10000
        if T1(j,1)==0
            count=count+1;
        end
    end
    postest(n,1)=count/10000;

    ypre2=trainData*w;
    ypre2=exp(ypre2);
    sy=sum(ypre2,2);
    ypre2=ypre2./sy;
    [maxa,yhat2]=max(ypre2,[],2);
    yhat2=yhat2-1;
    T2=trainLabels-yhat2;
    count=0;
    for j=1:60000
        if T2(j,1)==0
            count=count+1;
        end
    end
    postrain(n,1)=count/60000;

    Lin(n,1)=0;
    for j=1:60000
        Lin(n,1)=Lin(n,1)+1/length(D)*(-log(ypre2(j,trainLabels(j,1)+1)));
    end
end
%%
plot(1:epoch,postrain(:,1),'red','LineWidth',2)
hold on;
%%
plot(1:epoch,postest(:,1),'red','LineWidth',2)
hold on;
%%
plot(1:epoch,Lin(:,1),'red','LineWidth',2)
hold on;
%%
rt=floor(10000*rand(10,1));
Dt=testData(rt,:);
yp=testLabels(rt,1);
p=Dt*w;
p=exp(p);
ps=sum(p,2);
p=p./ps;
[maxa,yppp]=max(p,[],2);
yppp=yppp-1;