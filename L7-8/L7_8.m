d1 = mvnrnd([3,0],eye(2),200);
d2 = mvnrnd([0,3],eye(2),200);
x1 = d1(1:160,:);
x2 = d2(1:160,:);
x=[x1;x2];
y(1:160,1)=1;
y(161:320,1)=-1;
t=[d1(161:200,:);d2(161:200,:)];
ty(1:40,1)=1;
ty(41:80,1)=-1;
%%
[w1,b1]=PSVM(x,y);
[w2,b2,alphad]=DSVM(x,y);
flag=1;%0表示核函数为四次多项式，1表示为高斯核函数
[b3,alphak]=KSVM(x,y,flag);
%%
fpsvm1=0;%PSVM训练集错误个数
fpsvm2=0;%PSVM测试集错误个数
fdsvm1=0;%DSVM训练集错误个数
fdsvm2=0;%DSVM测试集错误个数
fksvm1=0;%KSVM训练集错误个数
fksvm2=0;%KSVM测试集错误个数
for i=1:length(x)
    if(y(i,1)*sign(x(i,:)*w1+b1) < 0)
        fpsvm1=fpsvm1+1;
    end
end
for i=1:length(x)
    if(y(i,1)*sign(x(i,:)*w2+b2) < 0)
        fdsvm1=fdsvm1+1;
    end
end
if flag==0
    for i=1:length(x)
        s=0;
        for j=1:length(x)
            if alphak(j,1)>1e-6
                s=s+alphak(j,1)*y(j,1)*(1+x(j,:)*x(i,:)'+(x(j,:)*x(i,:)')^2+ ...,
                (x(j,:)*x(i,:)')^3+(x(j,:)*x(i,:)')^4);
            end
        end
        if(sign(s+b3)*y(i,1) < 0)
            fksvm1=fksvm1+1;
        end
    end
end
if flag==1
    for i=1:length(x)
        s=0;
        for j=1:length(x)
            if alphak(j,1)>1e-6
                s=s+alphak(j,1)*y(j,1)*exp(-(x(i,:)-x(j,:))*(x(i,:)-x(j,:))');
            end
        end
        if(sign(s+b3)*y(i,1) < 0)
            fksvm1=fksvm1+1;
        end
    end
end
for i=1:length(t)
    if(ty(i,1)*sign(t(i,:)*w1+b1) < 0)
        fpsvm2=fpsvm2+1;
    end
end
for i=1:length(t)
    if(ty(i,1)*sign(t(i,:)*w2+b2) < 0)
        fdsvm2=fdsvm2+1;
    end
end
if flag==0
    for i=1:length(t)
        s=0;
        for j=1:length(x)
            if alphak(j,1)>1e-6
                s=s+alphak(j,1)*y(j,1)*(1+x(j,:)*t(i,:)'+(x(j,:)*t(i,:)')^2+ ...,
                (x(j,:)*t(i,:)')^3+(x(j,:)*t(i,:)')^4);
            end
        end
        if(sign(s+b3)*ty(i,1) < 0)
            fksvm2=fksvm2+1;
        end
    end
end
if flag==1
    for i=1:length(t)
        s=0;
        for j=1:length(x)
            if alphak(j,1)>1e-6
                s=s+alphak(j,1)*y(j,1)*exp(-(t(i,:)-x(j,:))*(t(i,:)-x(j,:))');
            end
        end
        if(sign(s+b3)*ty(i,1) < 0)
            fksvm2=fksvm2+1;
        end
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
syms xx yy
if flag==0
    f=alphak'*(y.*(1+(xx*x(:,1)+yy*x(:,2))+(xx*x(:,1)+yy*x(:,2)).^2+ ...,
        (xx*x(:,1)+yy*x(:,2)).^3+(xx*x(:,1)+yy*x(:,2)).^4))+b3;
%     f1=alphak'*(y.*(1+(xx*x(:,1)+yy*x(:,2))+(xx*x(:,1)+yy*x(:,2)).^2+ ...,
%         (xx*x(:,1)+yy*x(:,2)).^3+(xx*x(:,1)+yy*x(:,2)).^4))+b3+1;
%     f2=alphak'*(y.*(1+(xx*x(:,1)+yy*x(:,2))+(xx*x(:,1)+yy*x(:,2)).^2+ ...,
%         (xx*x(:,1)+yy*x(:,2)).^3+(xx*x(:,1)+yy*x(:,2)).^4))+b3-1;
end
if flag==1
    f=alphak'*(y.*exp(-(xx*x(:,1)+yy*x(:,2))))+b3;
%     f1=alphak'*(y.*exp(-(xx*x(:,1)+yy*x(:,2))))+b3+1;
%     f2=alphak'*(y.*exp(-(xx*x(:,1)+yy*x(:,2))))+b3-1;
end
plot(xp,yp1,'blue','LineWidth',2)
hold on;
plot(xp,yp2,'y--','LineWidth',2)
hold on;
ezplot(f,[-3 6 -3 6])
hold on;
% ezplot(f1,[min(d1(:,1)) max(d2(:,1)) min(d1(:,2)) max(d2(:,2))])
% hold on;
% ezplot(f2,[min(d1(:,1)) max(d2(:,1)) min(d1(:,2)) max(d2(:,2))])
% hold on;
%%
for j=1:length(x)
    if alphak(j,1)>1e-6
        scatter(x(j,1),x(j,2),'blue','filled')
        hold on;
    end
end
for j=1:length(x)
    if alphad(j,1)>1e-6
        scatter(x(j,1),x(j,2),'yellow','filled')
        hold on;
    end
end
%%
zhong=[119.28,26.08;
    121.31,25.03;
    121.47,31.23;
    118.06,24.27;
    121.46,39.04;
    122.10,37.50;
    124.23,40.07;
    113.53,29.58;
    116.25,39.54];
ri=[129.87,32.75;
    130.33,31.36;
    131.42,31.91;
    130.24,33.35;
    133.33,15.43;
    138.38,24.98;
    140.47,36.37;
    139.46,35.42;
    136.54,35.10];
yzhong(1:9,1)=1;
yri(1:9,1)=-1;
X=[zhong;ri];
Y=[yzhong;yri];
[w2,b2,alphad1]=DSVM(X,Y);
scatter(zhong(1:7,1),zhong(1:7,2),'red','filled')
hold on;
scatter(zhong(8:9,1),zhong(8:9,2),'red','+')
hold on;
scatter(ri(1:7,1),ri(1:7,2),'green','filled')
hold on;
scatter(ri(8:9,1),ri(8:9,2),'green','+')
hold on;
xp=linspace(min(zhong(:,1)),max(ri(:,1)));
yp1=-w2(1,1)/w2(2,1)*xp-b2/w2(2,1);
plot(xp,yp1,'blue','LineWidth',2)
for j=1:length(X)
    if alphad1(j,1)>1e-6
        scatter(X(j,1),X(j,2),'yellow','filled')
        hold on;
    end
end
scatter(123.28,25.45,'blue','filled')