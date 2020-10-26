clear;
close all;
clc;
D=2;
NP=50;
Xs=4;
Xx=-4;
G=200;
pm=0.7;
alfa=2;
belta=1;
detas=0.2;
gen=0;
Ncl=5;
deta0=0.5*Xs;
f=rand(D,NP)*(Xs-Xx)+Xx;
for np=1:NP
    MSLL(NP)=func2(f(:,np));
end
for np=1:NP
    for j=1:NP
        nd(j)=sum(sqrt((f(:,np)-f(:,j)).^2));
        if nd(j)<detas
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
            NaMSLL(j)=func2(Na(:,j));
        end
        [NaSortMSLL,Index]=sort(NaMSLL);
        aMSLL(i)=NaSortMSLL(1);
        NaSortf=Na(:,Index);
        af(:,i)=NaSortf(:,1);
    end
    for np=1:NP/2
        for j=1:NP/2
            nda(j)=sum(sqrt((af(:,np)-af(:,j)).^2));
            if nda(j)< detas
                nda(j)=1;
            else
                nda(j)=0;
            end
        end
        aND(np)=sum(nda)/NP*2;
    end
    aMSLL=alfa*aMSLL-belta*aND;
    bf=rand(D,NP/2)*(Xs-Xx);
    for np=1:NP/2
        bMSLL(np)=func2(bf(:,np));
    end
    for np=1:NP/2
        for j=1:NP/2
            ndc(j)=sum(sqrt((bf(:,np)-bf(:,j)).^2));
            if ndc(j)< detas
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
    trace(gen)=func2(Sortf(:,1));
end
Bestf=Sortf(:,1)
trace(end);
figure,plot(trace);
xlabel('迭代次数');
ylabel('目标函数值')
title('亲和度进化曲线')
function value=func2(x)
value=5*sin(x(1)*x(2))+x(1)*x(1)+x(2)*x(2);
end