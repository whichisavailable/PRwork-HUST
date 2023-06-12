function [wout,bout,Lin] = SGD(x,y,batchsize,epoch,eta)
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
        yhat=batchi*w;
        ybatch=ytemp((i-1)*batchsize+1:i*batchsize,:);
        ngrad=batchi'*(yhat-ybatch);
        grad=1/batchsize*ngrad;
        w=w-eta*grad;
    end
    r=randperm(length(D));   %生成关于行数的随机排列行数序列
    D=D(r,:);                %根据这个序列对D进行重新排序
    ytemp=ytemp(r,:);
    L(n,1)=1/length(D)*sum((D*w-ytemp).^2);
end
bout=w(1,1);
wo(1,1)=w(2,1);
wo(2,1)=w(3,1);
wout=wo;
Lin=L;
end