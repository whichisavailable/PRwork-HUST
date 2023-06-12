d1 = mvnrnd([1,0],eye(2),200);
d2 = mvnrnd([0,1],eye(2),200);
x1 = d1(1:160,:);
x2 = d2(1:160,:);
x=[x1;x2];
y(1:160,1)=1;
y(161:320,1)=-1;
t=[d1(161:200,:);d2(161:200,:)];
ty(1:40,1)=1;
ty(41:80,1)=-1;
w0=[0;0];
b0=1;
%%
time1=clock;
[w1,b1]=PLA(x,y,w0,b0);
time2=clock;
T1=etime(time1,time2);
time1=clock;
[w2,b2]=pocket(x,y,w0,b0);
time2=clock;
T2=etime(time1,time2);
%%
fpla1=0;%PLA训练集错误个数
fpla2=0;%PLA测试集错误个数
fpoc1=0;%pocket训练集错误个数
fpoc2=0;%pocket测试集错误个数
for i=1:length(x)
    if(y(i,1)*sign(x(i,:)*w1+b1) < 0)
        fpla1=fpla1+1;
    end
end
for i=1:length(x)
    if(y(i,1)*sign(x(i,:)*w2+b2) < 0)
        fpoc1=fpoc1+1;
    end
end
for i=1:length(t)
    if(ty(i,1)*sign(t(i,:)*w1+b1) < 0)
        fpla2=fpla2+1;
    end
end
for i=1:length(t)
    if(ty(i,1)*sign(t(i,:)*w1+b1) < 0)
        fpoc2=fpoc2+1;
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