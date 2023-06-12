function [wout,bout]=PSVM(x,y)
Q(1,1:3)=0;
Q(1:3,1)=0;
Q(2:3,2:3)=eye(2);
P(1:3,1)=0;
D(:,2)=x(:,1);
D(:,3)=x(:,2);
D(:,1)=1;
a=y.*D;
c(1:length(x),1)=1;
u=quadprog(Q,P,-a,-c);
bout=u(1,1);
wout=u(2:3,1);
end