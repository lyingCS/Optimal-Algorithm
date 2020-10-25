clear;
close all;
clc;
N=100;
D=20;
T=200;
c1=1.5;
c2=1.5;
Wmax=0.8;
Wmin=0.4;
Xs=9;
Xx=0;
Vmax=10;
Vmin=-10;
x=randi([0,1],N,D);
v=rand(N,D)*(Vmax-Vmin)+Vmin;
p=x;
pbest=ones(N,1);
for i=1:N
    pbest(i)=func3(x(i,:),Xs,Xx);
end
g=ones(1,D);
gbest=inf;
for i=1:N
    if(pbest(i) < gbest)
        g=p(i,:);
        gbest=pbest(i);
    end
end
gb=ones(1,T);
for i=1:T
    for j=1:N
        if(func3(x(j,:),Xs,Xx) < pbest(j))
            p(j,:)=x(j,:);
            pbest(j)=func3(x(j,:),Xs,Xx);
        end
        if(pbest(j) < gbest)
            g=p(j,:);
            gbest=pbest(j);
        end
        w=Wmax-(Wmax-Wmin)*i/T;
        v(j,:)=w*v(j,:)+c1*rand*(p(j,:)-x(j,:))+c2*rand*(g-x(j,:));
        for ii=1:D
            if (v(j,ii) > Vmax) || (v(j,ii) < Vmin)
                v(j,ii)=rand*(Vmax-Vmin)+Vmin;
            end
        end
        vx(j,:)=1./(1+exp(-v(j,:)));
        for jj=1:D
            if(vx(j,jj)>rand)
                x(j,jj)=1;
            else
                x(j,jj)=0;
            end
        end
    end
    gb(i)=gbest;
end
g;
m=0;
for j=1:D
    m=g(j)*2^(j-1)+m;
end
f1=Xx+m*(Xs-Xx)/(2^D-1)
figure
plot(gb)
xlabel('迭代次数')
ylabel('适应度值')
title('适应度进化曲线')

function result=func3(x,Xs,Xx)
m=0;
D=length(x);
for j=1:D
    m=x(j)*2^(j-1)+m;
end
f=Xx+m*(Xs-Xx)/(2^D-1);
fit=f+6*sin(4*f)+9*cos(5*f);
result=fit;
end