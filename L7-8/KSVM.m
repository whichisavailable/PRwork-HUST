function [bout,alpha]=KSVM(x,y,flag)
if flag==0%四次多项式
    for i=1:length(x)
        for j=1:length(x)
            Q(i,j)=y(i,1)*y(j,1)*(1+x(i,:)*x(j,:)'+(x(i,:)*x(j,:)')^2+ ...,
                (x(i,:)*x(j,:)')^3+(x(i,:)*x(j,:)')^4);
        end
    end
    p(1:length(x),1)=-1;
    A=eye(length(x));
    c(1:length(x),1)=0;
    r=y';
    v=0;
    alpha=quadprog(Q,p,-A,-c,r,v);
    for i=1:length(x)
        if alpha(i,1)>1e-6
            m=i;
            break;
        end
    end
%     wout=0;
    s=0;
    for i=1:length(x)
        if alpha(i,1)>1e-6
%             wout=wout+alpha(i,1)*y(i,1)*[1;x(i,1);x(i,2);x(i,1)^2;x(i,1)*x(i,2);x(i,2)^2; ...,
%                 x(i,1)^3;x(i,1)^2*x(i,2);x(i,1)*x(i,2)^2;x(i,2)^3; ...,
%                 x(i,1)^4;x(i,1)^3*x(i,2);x(i,1)^2*x(i,2)^2;x(i,1)*x(i,2)^3;x(i,2)^4];
            s=s+alpha(i,1)*y(i,1)*(1+x(i,:)*x(m,:)'+(x(i,:)*x(m,:)')^2+ ...,
                (x(i,:)*x(m,:)')^3+(x(i,:)*x(m,:)')^4);
        end
    end
    bout=y(m,1)-s;
end
if flag==1%高斯核函数
    for i=1:length(x)
        for j=1:length(x)
            Q(i,j)=y(i,1)*y(j,1)*exp(-sum((x(i,:)-x(j,:)).^2));
        end
    end
    p(1:length(x),1)=-1;
    A=eye(length(x));
    c(1:length(x),1)=0;
    r=y';
    v=0;
    alpha=quadprog(Q,p,-A,-c,r,v);
    for i=1:length(x)
        if alpha(i,1)>1e-6
            m=i;
            break;
        end
    end
    s=0;
    for i=1:length(x)
        if alpha(i,1)>1e-6
            s=s+alpha(i,1)*y(i,1)*exp(-sum((x(i,:)-x(m,:)).^2));
        end
    end
    bout=y(m,1)-s;
end
end