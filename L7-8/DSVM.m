function [wout,bout,alpha]=DSVM(x,y)
for i=1:length(x)
    for j=1:length(x)
        Q(i,j)=y(i,1)*y(j,1)*x(i,:)*x(j,:)';
    end
end
p(1:length(x),1)=-1;
A=eye(length(x));
c(1:length(x),1)=0;
r=y';
v=0;
alpha=quadprog(Q,p,-A,-c,r,v);
wout=(alpha'*(y.*x))';
for i=1:length(x)
    if alpha(i,1)>1e-6
        bout=y(i,1)-x(i,:)*wout;
        break;
    end
end
end