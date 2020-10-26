clear;
close all;
clc;
D=10;
NP=100;
Xs=20;
Xx=-20;
G=500;
pm=0.7;
alfa=1;
belta=1;
detas=0.2;
gen=0;
Ncl=10;
deta0=1*Xs;
f=rand(D,NP)*(Xs-Xx)+Xs;
for np=1:NP
    MSLL(np)=func1(f(:,np));
end
for np=1:NP
    for j=1:NP
        nd(j)=sum(sqrt((f(:,np)-f(:,j)).^2));
        if nd(j) < detas
            nd(j)=1;
        else
            nd(j)=0;
        end
    end
    ND(np)=sum(nd)/NP;
end
MSLL=alfa*MSLL-belta*ND;
[SortMSLL,Index]=sort(MSLL);
Sortf=f(:,Index);
while gen<G
    for i=1:NP/2
        a=Sortf(:,i);
        Na=repmat(a,1,Ncl);
        deta=deta0/gen;
        for j=1:Ncl
            for ii=1:D
                if rand<pm
                    Na(ii,j)=Na(ii,j)+(rand-0.5)*deta;
                end
                if(Na(ii,j)>Xs)||(Na(ii,j)<Xx)
                    Na(ii,j)=rand*(Xs-Xx)+Xx;
                end
            end
        end
        Na(:,1)=Sortf(:,i);
        for j=1:Ncl
            NaMSLL(j)=func1(Na(:,j));
        end
        [NaSortMSLL,Index]=sort(NaMSLL);
        aMSLL(i)=NaSortMSLL(1);
        NaSortf=Na(:,Index);
        af(:,i)=NaSortf(:,1);
    end
    for np=1:NP/2
        for j=1:NP/2
            nda(j)=sum(sqrt((af(:,np)-af(:,j)).^2));
            if nda(j)<detas
                nda(j)=1;
            else
                nda(j)=0;
            end
        end
        aND(np)=sum(nda)/NP*2;
    end
    aMSLL=alfa*aMSLL-belta*aND;
    bf=rand(D,NP/2)*(Xs-Xx)+Xx;
    for np=1:NP/2
        bMSLL(np)=func1(bf(:,np));
    end
    for np=1:NP/2
        for j=1:NP/2
            ndc(j)=sum(sqrt((bf(:,np)-bf(:,j)).^2));
            if ndc(j)<detas
                ndc(j)=1;
            else
                ndc(j)=0;
            end
        end
        bND(np)=sum(ndc)/NP*2;
    end
    bMSLL=alfa*bMSLL-belta*bND;
    f1=[af,bf];
    MSLL1=[aMSLL,bMSLL];
    [SortMSLL,Index]=sort(MSLL1);
    Sortf=f1(:,Index);
    gen=gen+1;
    trace(gen)=func1(Sortf(:,1));
end
Bestf=Sortf(:,1)
trace(end);
figure,plot(trace);
xlabel('迭代次数')
ylabel('目标函数值')
title('亲和度进化曲线')
function result=func1(x)
result=sum(x.^2);
end