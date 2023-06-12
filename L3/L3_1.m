d1 = mvnrnd([-5,0],eye(2),200);
d2 = mvnrnd([0,5],eye(2),200);
x1 = d1(1:160,:);
x2 = d2(1:160,:);
x=[x1;x2];
y(1:160,1)=1;
y(161:320,1)=-1;
t=[d1(161:200,:);d2(161:200,:)];
ty(1:40,1)=1;
ty(41:80,1)=-1;
batchsize=20;
epoch=30;
eta=0.05;
%%
[w1,b1]=pinvalgo(x,y);
[w2,b2,Lin]=SGD(x,y,batchsize,epoch,eta);
%%
finv1=0;%广义逆训练集错误个数
finv2=0;%广义逆测试集错误个数
fsgd1=0;%SGD训练集错误个数
fsgd2=0;%SGD测试集错误个数
for i=1:length(x)
    if(y(i,1)*sign(x(i,:)*w1+b1) < 0)
        finv1=finv1+1;
    end
end
for i=1:length(x)
    if(y(i,1)*sign(x(i,:)*w2+b2) < 0)
        fsgd1=fsgd1+1;
    end
end
for i=1:length(t)
    if(ty(i,1)*sign(t(i,:)*w1+b1) < 0)
        finv2=finv2+1;
    end
end
for i=1:length(t)
    if(ty(i,1)*sign(t(i,:)*w2+b2) < 0)
        fsgd2=fsgd2+1;
    end
end
%%
scatter(d1(:,1),d1(:,2),'red','filled')
hold on;
scatter(d2(:,1),d2(:,2),'green','filled')
hold on;
xp=linspace(min(d1(:,1)),max(d2(:,1)));
yp1=-w1(1,1)/w1(2,1)*xp-b1/w1(2,1);
yp2=-w2(1,1)/w2(2,1)*xp-b2/w2(2,1);
plot(xp,yp1,'blue','LineWidth',2)
hold on;
plot(xp,yp2,'y--','LineWidth',2)
%%
plot(1:epoch,Lin(:,1),'red','LineWidth',2)
