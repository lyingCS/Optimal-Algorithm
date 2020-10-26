clear;
close all;
clc;
NP=20;
D=2;
G=100;
F=0.5;
CR=0.1;
Xs=4;
Xx=-4;
x=zeros(D,NP);
v=zeros(D,NP);
u=zeros(D,NP);
x=rand(D,NP)*(Xs-Xx)+Xx;
for m=1:NP
    Ob(m)=func2(x(:,m));
end
trace(1)=min(Ob);
for gen=1:G
    for m=1:NP
        r1=randi([1,NP],1,1);
        while (r1==m)
            r1=randi([1,NP],1,1);
        end
        r2=randi([1,NP],1,1);
        while (r2==m) || (r2==r1)
            r2=randi([1,NP],1,1);
        end
        r3=randi([1,NP],1,1);
        while(r3==m) || (r3==r1) || (r3==r2)
            r3=randi([1,NP],1,1);
        end
        v(:,m)=x(:,r1)+F*(x(:,r2)-x(:,r3));
    end
    r=randi([1,D],1,1);
    for n=1:D
        cr=rand(1);
        if (cr<=CR) || (n-r)
            u(n,:)=v(n,:);
        else
            u(n,:)=x(n,:);
        end
    end
    for n=1:D
        for m=1:NP
            if(u(n,m) < Xx)
                u(n,m)=Xx;
            end
            if(u(n,m) > Xs)
                u(n,m)=Xs;
            end
        end
    end
    for m=1:NP
        Ob1(m)=func2(u(:,m));
    end
    for m=1:NP
        if(Ob1(m) < Ob(m))
            x(:,m)=u(:,m);
        end
    end
    for m=1:NP
        Ob(m)=func2(x(:,m));
    end
    trace(gen+1)=min(Ob);
end
[SortOb,Index]=sort(Ob);
x=x(:,Index);
X=x(:,1)
Y=min(Ob);
figure
plot(trace);
xlabel('迭代次数');
ylabel('目标函数值');
title('DE目标函数值');
function value=func2(x)
value=3*cos(x(1)*x(2))+x(1)+x(2);
end