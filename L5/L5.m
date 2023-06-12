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
[w1,Lin]=logistic(x,y,batchsize,epoch,eta);
%%
Dt(:,2)=t(:,1);
Dt(:,3)=t(:,2);
Dt(:,1)=1;
yhat=1./(1+exp(-Dt*w1));
%%
scatter(d1(:,1),d1(:,2),'red','filled')
hold on;
scatter(d2(:,1),d2(:,2),'green','filled')
hold on;
xp=linspace(min(d1(:,1)),max(d2(:,1)));
yp1=-w1(2,1)/w1(3,1)*xp-w1(1,1)/w1(3,1);
plot(xp,yp1,'blue','LineWidth',2)
hold on;
%%
plot(1:epoch,Lin(:,1),'red','LineWidth',2)
