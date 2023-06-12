function [wout,Lin]=logistic(x,y,batchsize,epoch,eta)
w0=[1;0;0];
D(:,2)=x(:,1);
D(:,3)=x(:,2);
D(:,1)=1;
ytemp=y;
iter=length(y)/batchsize;
w=w0;
for n=1:epoch
    for i=1:iter
        batchi=D((i-1)*batchsize+1:i*batchsize,:);
        ybatch=ytemp((i-1)*batchsize+1:i*batchsize,:);
        ngrad=(-ybatch.*batchi)'*(1./(1+exp(-ybatch.*(batchi*w))));
        grad=1/batchsize*ngrad;
        w=w-eta*grad;
    end
    r=randperm(length(D));   %生成关于行数的随机排列行数序列
    D=D(r,:);                %根据这个序列对D进行重新排序
    ytemp=ytemp(r,:);
    L(n,1)=1/length(D)*sum(log(1+exp(-ytemp.*(D*w))));
end
wout=w;
Lin=L;
end