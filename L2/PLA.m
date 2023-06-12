function [wout,bout]=PLA(x,y,w0,b0)
w=w0;
b=b0;
time1=clock;
while(1)
    t=0;
    for i = 1:length(x)
        if(y(i,1)*sign(x(i,:)*w+b)<0)
            w=w+y(i,1)*x(i,:)';
            b=b+y(i,1);
            break;
        end
    end
    for j = 1:length(x)
        if(y(j,1)*sign(x(j,:)*w+b)<0)
            t=t+1;
        end
    end
    if(t==0)
        break;
    end
    time2=clock;
    T=etime(time2,time1);
    if(T>1)
        break;
    end
end
wout=w;
bout=b;

