iris(1:50,6)=1;
iris(51:100,6)=2;
iris(101:150,6)=3;
%%
r=randperm(50);
D1=iris(r,:);%第一类打乱
r=randperm(50);
D2=iris(50+r,:);%第二类打乱
r=randperm(50);
D3=iris(100+r,:);%第三类打乱
%%
Dtrain1=D1(1:30,2:5);
Dtrain2=D2(1:30,2:5);
Dtrain3=D3(1:30,2:5);
Dtest1=D1(31:50,2:5);
Dtest2=D2(31:50,2:5);
Dtest3=D3(31:50,2:5);
y(1:30,1)=1;
y(31:60,1)=-1;
D1=[Dtrain1;Dtrain2];
D2=[Dtrain1;Dtrain3];
D3=[Dtrain2;Dtrain3];
%%
[w1,b1,alpha1]=DSVM(D1,y);%1为第一类-1为第二类
[w2,b2,alpha2]=DSVM(D2,y);%1为第一类-1为第三类
[w3,b3,alpha3]=DSVM(D3,y);%1为第二类-1为第三类
%%
%第一类
yhat1=sign(Dtest1*w1+b1);
yhat2=sign(Dtest1*w2+b2);
yhat3=sign(Dtest1*w3+b3);
for i=1:20
    flag1=0;
    flag2=0;
    flag3=0;
    if yhat1(i,1)==1
        flag1=flag1+1;
    end
    if yhat1(i,1)==-1
        flag2=flag2+1;
    end
    if yhat2(i,1)==1
        flag1=flag1+1;
    end
    if yhat2(i,1)==-1
        flag3=flag3+1;
    end
    if yhat3(i,1)==1
        flag2=flag2+1;
    end
    if yhat3(i,1)==-1
        flag3=flag3+1;
    end
    if flag1==max(flag1,max(flag2,flag3))
        yhat(i,1)=1;
    end
    if flag2==max(flag1,max(flag2,flag3))
        yhat(i,1)=2;
    end
    if flag3==max(flag1,max(flag2,flag3))
        yhat(i,1)=3;
    end
end
%%
%第二类
yhat1=sign(Dtest2*w1+b1);
yhat2=sign(Dtest2*w2+b2);
yhat3=sign(Dtest2*w3+b3);
for i=1:20
    flag1=0;
    flag2=0;
    flag3=0;
    if yhat1(i,1)==1
        flag1=flag1+1;
    end
    if yhat1(i,1)==-1
        flag2=flag2+1;
    end
    if yhat2(i,1)==1
        flag1=flag1+1;
    end
    if yhat2(i,1)==-1
        flag3=flag3+1;
    end
    if yhat3(i,1)==1
        flag2=flag2+1;
    end
    if yhat3(i,1)==-1
        flag3=flag3+1;
    end
    if flag1==max(flag1,max(flag2,flag3))
        yhat(i,1)=1;
    end
    if flag2==max(flag1,max(flag2,flag3))
        yhat(i,1)=2;
    end
    if flag3==max(flag1,max(flag2,flag3))
        yhat(i,1)=3;
    end
end
%%
%第三类
yhat1=sign(Dtest3*w1+b1);
yhat2=sign(Dtest3*w2+b2);
yhat3=sign(Dtest3*w3+b3);
for i=1:20
    flag1=0;
    flag2=0;
    flag3=0;
    if yhat1(i,1)==1
        flag1=flag1+1;
    end
    if yhat1(i,1)==-1
        flag2=flag2+1;
    end
    if yhat2(i,1)==1
        flag1=flag1+1;
    end
    if yhat2(i,1)==-1
        flag3=flag3+1;
    end
    if yhat3(i,1)==1
        flag2=flag2+1;
    end
    if yhat3(i,1)==-1
        flag3=flag3+1;
    end
    if flag1==max(flag1,max(flag2,flag3))
        yhat(i,1)=1;
    end
    if flag2==max(flag1,max(flag2,flag3))
        yhat(i,1)=2;
    end
    if flag3==max(flag1,max(flag2,flag3))
        yhat(i,1)=3;
    end
end
%%
eta=0.1;
Dtrain1(:,2:5)=Dtrain1;
Dtrain1(:,1)=1;
Dtrain2(:,2:5)=Dtrain2;
Dtrain2(:,1)=1;
Dtrain3(:,2:5)=Dtrain3;
Dtrain3(:,1)=1;
D=[Dtrain1;Dtrain2;Dtrain3];
Dtest1(:,2:5)=Dtest1;
Dtest1(:,1)=1;
Dtest2(:,2:5)=Dtest2;
Dtest2(:,1)=1;
Dtest3(:,2:5)=Dtest3;
Dtest3(:,1)=1;
Dtest=[Dtest1;Dtest2;Dtest3];
Y(1:30,1)=1;
Y(1:30,2:3)=0;
Y(31:60,1)=0;
Y(31:60,2)=1;
Y(31:60,3)=0;
Y(61:90,1:2)=0;
Y(61:90,3)=1;
%%
w(1:5,1:3)=0;
for i=1:1000
    S=D*w;
    S=exp(S);
    s=sum(S,2);
    yhat=S./s;
    grad=D'*(yhat-Y);
    w=w-eta*grad;
end
%%
ypre=Dtest*w;
ypre=exp(ypre);
sy=sum(ypre,2);
ypre=ypre./sy;