function [wout,bout] = pinvalgo(x,y)
D(:,2)=x(:,1);
D(:,3)=x(:,2);
D(:,1)=1;

w=pinv(D)*y;

bout=w(1,1);
wo(1,1)=w(2,1);
wo(2,1)=w(3,1);
wout=wo;
end