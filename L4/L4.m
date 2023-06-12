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
%%
sw=eye(2)+eye(2);
w=inv(sw)*([-5;0]-[0;5]);
s=w'*([-5;0]+[0;5])/2;
%%
f1=0;%训练集错误个数
f2=0;%测试集错误个数
for i=1:length(x)
    if(y(i,1)*w'*x(i,:)'<y(i,1)*s)
        f1=f1+1;
    end
end
for i=1:length(t)
    if(y(i,1)*w'*x(i,:)'<y(i,1)*s)
        f2=f2+1;
    end
end
%%
scatter(d1(:,1),d1(:,2),'red','filled')
hold on;
scatter(d2(:,1),d2(:,2),'green','filled')
hold on;
quiver(0,0,w(1,1),w(2,1),1,'b');
hold on;
xp=linspace(min(d1(:,1)),max(d2(:,1)));
yp=-w(1,1)/w(2,1)*xp+s/w(2,1);
plot(xp,yp,'blue','LineWidth',2)
hold on;
axis equal