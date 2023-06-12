function [wout,bout]=pocket(x,y,w0,b0)
w=w0;
b=b0;
wf=0;
pocketw=w0;
pocketb=b0;
pocketf=1000;
for n=1:50000
    wf=0;
    for i = 1:length(x)
        if(y(i,1)*sign(x(i,:)*w+b)<0)
            w=w+y(i,1)*x(i,:)';
            b=b+y(i,1);
            break;
        end
    end
    for i = 1:length(x)
        if(y(i,1)*sign(x(i,:)*w+b)<0)
            wf=wf+1;
        end
    end
    if(wf<pocketf)
        pocketw=w;
        pocketb=b;
        pocketf=wf;
    end
end
wout=w;
bout=b;