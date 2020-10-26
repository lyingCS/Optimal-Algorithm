clear;
close all;
clc;
N=100;
D=10;
T=200;
c1=1.5;
c2=1.5;
Wmax=0.8;
Wmin=0.4;
Vmax=10;
Vmin=-10;
V=300;
C=[95,75,23,73,50,22,6,57,89,98];
W=[89,59,19,43,100,72,44,16,7,64];
afa=2;
x=randi([0,1],N,D);
v=rand(N,D)*(Vmax-Vmin)+Vmin;
p=x;
pbest=ones(N,1);
for i=1:N
    pbest(i)=func4(x(i,:),C,W,V,afa);
end
g=ones(1,D);
gbest=eps;
for i=1:N
    if(pbest(i)>gbest)
        g=p(i,:);
        gbest=pbest(i);
    end
end
gb=ones(1,T);
for i=1:T
    for j=1:N
        if(func4(x(j,:),C,W,V,afa)>pbest(j))
            p(j,:)=x(j,:);
            pbest(j)=func4(x(j,:),C,W,V,afa);
        end
        if(pbest(j)>gbest)
            g=p(j,:);
            gbest=pbest(j);
        end
        w=Wmax-(Wmax-Wmin)*i/T;
        v(j,:)=w*v(j,:)+c1*rand*(p(j,:)-x(j,:))+c2*rand*(g-x(j,:));
        for ii=1:D
            if v(j,ii) > Vmax || v(j,ii) < Vmin
                v(j,ii)=rand*(Vmax-Vmin)+Vmin;
            end
        end
        vx(j,:)=1./(1+exp(-v(j,:)));
        for jj=1:D
            if vx(j,jj) > rand
                x(j,jj)=1;
            else
                x(j,jj)=0;
            end
        end
    end
    gb(i)=gbest;
end
g
figure
plot(gb)
xlabel('迭代次数')
ylabel('适应度值')
title('适应度进化曲线')

function result=func4(f,C,W,V,afa)
fit=sum(f.*W);
TotalSize=sum(f.*C);
if(TotalSize<=V)
    fit=fit;
else
    fit=fit-afa*(TotalSize-V);
end
result=fit;
end