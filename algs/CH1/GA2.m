clear;
close all;
clc;
D=10;
NP=100;
Xs=20;
Xx=-20;
G=1000;
f=zeros(D,NP);
nf=zeros(D,NP);
Pc=0.8;
Pm=0.1;
f=rand(D,NP)*(Xs-Xx)+Xs;
for np=1:NP
    MSLL(np)=func2(f(:,np));
end
[sortMSLL,Index]=sort(MSLL);
Sortf=f(:,Index);
for gen=1:G
    Emper=Sortf(:,1);
    NoPoint=round(D*Pc);
    PoPoint=randi([1 D],NoPoint,NP/2);
    nf=Sortf;
    for i=1:NP/2
        nf(:,2*i-1)=Emper;
        nf(:,2*i)=Sortf(:,2*i);
        for k=1:NoPoint
            nf(PoPoint(k,i),2*i-1)=nf(PoPoint(k,i),2*i);
            nf(PoPoint(k,i),2*i)=Emper(PoPoint(k,i));
        end
    end
    for m=1:NP
        for n=1:D
            r=rand(1,1);
            if r < Pm
                nf(n,m)=rand(1,1)*(Xs-Xx)+Xx;
            end
        end
    end
    for np=1:NP
        NMSLL(np)=func2(nf(:,np));
    end
    [NSortMSLL,Index]=sort(NMSLL);
    NSortf=nf(:,Index);
    f1=[Sortf,NSortf];
    MSLL1=[SortMSLL,NSortMSLL];
    [SortMSLL1,Index]=sort(MSLL1);
    Sortf1=f1(:,Index);
    SortMSLL=SortMSLL1(1:NP);
    Sortf=Sortf1(:,1:NP);
    trace(gen)=SortMSLL(1);
end
Bestf=Sort(:,1);
trace(end);
figure
plot(trace)
xlabel('迭代次数')
ylabel('目标函数值')
title('适应度进化曲线')
function result=func2(x)
summ=sum(x.^2);
result=summ;
end