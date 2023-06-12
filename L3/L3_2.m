t=-10:0.1:10;
f=t.*cos(pi/4*t);
plot(t,f,'blue','LineWidth',2)
hold on;
x(1,1)=-4;
eta=0.4;
%%
func=@(a)(a.*cos(pi/4*a));
grad=@(b)(cos(pi/4*b)-pi/4*b.*sin(pi/4*b));
for i=1:50          %梯度下降
    x(i+1,1)=x(i,1)-eta*grad(x(i,1));
end
fx=func(x(:,1));
plot(x(:,1),fx(:,1),'r--','LineWidth',2)
hold on;
%%
for i=1:50          %随机梯度下降
    x(i+1,1)=x(i,1)-eta*(grad(x(i,1))+rand/2);
end
fx=func(x(:,1));
plot(x(:,1),fx(:,1),'green','LineWidth',2)
hold on;
%%
for i=1:50          %adagrad
    sigma(i)=sqrt(1/i*sum(grad(x(1:i,1)).^2))+1e-6;
    x(i+1,1)=x(i,1)-eta/sigma(i)*grad(x(i,1));
end
fx=func(x(:,1));
plot(x(:,1),fx(:,1),'red','LineWidth',2)
hold on;
%%
alpha=0.9;
sigma(1)=1;
for i=1:50          %RMSProp 
    x(i+1,1)=x(i,1)-eta/sigma(i)*grad(x(i,1));
    sigma(i+1)=sqrt(alpha*sigma(i)^2+(1-alpha)*grad(x(i+1,1))^2)+1e-6;
end
fx=func(x(:,1));
plot(x(:,1),fx(:,1),'red','LineWidth',2)
hold on;
%%
lamda=0.9;
m(1)=0;
for i=1:50          %动量法
    m(i+1)=lamda*m(i)-eta*grad(x(i,1));
    x(i+1,1)=x(i,1)+m(i+1);
end
fx=func(x(:,1));
plot(x(:,1),fx(:,1),'r','LineWidth',2)
hold on;
%%
alpha=0.8;
beta1=0.9;
beta2=0.999;
m(1)=0;
mhat(1)=0;
v(1)=0;
vhat(1)=0;
for i=1:1000         %adam
    m(i+1)=beta1*m(i)+(1-beta1)*grad(x(i,1));
    v(i+1)=beta2*v(i)+(1-beta2)*grad(x(i,1))^2;
    mhat(i+1)=m(i+1)/(1-beta1^i);
    vhat(i+1)=v(i+1)/(1-beta2^i);
    x(i+1,1)=x(i,1)-alpha*mhat(i+1)/(sqrt(vhat(i+1))+1e-6);
end
fx=func(x(:,1));
plot(x(:,1),fx(:,1),'r','LineWidth',2)
hold on;