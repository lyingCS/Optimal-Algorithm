clear;
close all;
clc;
N=100;
D=2;
T=200;
c1=1.5;
c2=1.5;
Wmax=0.8;
Wmin=0.4;
Xmax=4;
Xmin=-4;
Vmax=1;
Vmin=-1;
x=rand(N,D)*(Xmax-Xmin)+Xmin;
v=rand(N,D)*(Vmax-Vmin)+Vmin;
p=x;
pbest=ones(N,1);
for i=1:N
    pbest(i)=func2(x(i,:));
end
g=ones(1,D);
gbest=inf;
for i=1:N
    if(pbest(i)<gbest)
        g=p(i,:);
        gbest=pbest(i);
    end
end
gb=ones(1,T);
for i=1:T
    for j=1:N
        if(func2(x(j,:)) < pbest(j))
            p(j,:)=x(j,:);
            pbest(j)=func2(x(j,:));
        end
        if(pbest(j)<gbest)
            g=p(j,:);
            gbest=pbest(j);
        end
        w=Wmax-(Wmax-Wmin)*i/T;
        v(j,:)=w*v(j,:)+c1*rand*(p(j,:)-x(j,:))+c2*rand*(g-x(j,:));
        x(j,:)=x(j,:)+v(j,:);
        for ii=1:D
            if (v(j,ii) > Vmax) || (v(j,ii) < Vmin)
                v(j,ii)=rand*(Vmax-Vmin)+Vmin;
            end
            if (x(j,ii) > Xmax) || (x(j,ii) < Xmin)
                x(j,ii)=rand*(Xmax-Xmin)+Xmin;
            end
        end
    end
    gb(i)=gbest;
end
g
gb(end)
figure
plot(gb)
xlabel('迭代次数')
ylabel('适应度值')
title('适应度进化曲线')

function value=func2(x)
value=3*cos(x(1)*x(2))+x(1)+x(2)^2;
end