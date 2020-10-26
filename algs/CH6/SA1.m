clear;
close all;
clc;
D=10;
Xs=20;
Xx=-20;
L=200;
K=0.998;
S=0.01;
T=100;
YZ=1e-8;
P=0;
PreX=rand(D,1)*(Xs-Xx)+Xx;
PreBestX=PreX;
PreX=rand(D,1)*(Xs-Xx)+Xx;
BestX=PreX;
deta=abs(func1(BestX)-func1(PreBestX));
while (deta>YZ) && (T>0.001)
    T=K*T;
    for i=1:L
        NextX=PreX+S*rand(D,1)*(Xs-Xx)+Xx;
        for ii=1:D
            while NextX(ii)>Xs || NextX(ii)<Xx
                NextX(ii)=PreX(ii)+S*(rand*(Xs-Xx)+Xx);
            end
        end
        if(func1(BestX) > func1(NextX))
            PreBestX=BestX;
            BestX=NextX;
        end
        if(func1(PreX)-func1(NextX)>0)
            PreX=NextX;
            P=P+1;
        else
            changer=-1*(func1(NextX)-func1(PreX))/T;
            p1=exp(changer);
            if p1>rand
                PreX=NextX;
                P=P+1;
            end
        end
        trace(P+1)=func1(BestX);
    end
    deta=abs(func1(BestX)-func1(PreBestX));
end
disp('最小值在点:');
BestX
disp('最小值为:');
func1(BestX)
figure;
plot(trace(2:end))
xlabel('迭代次数')
ylabel('目标函数值')
title('适应度进化曲线')

function result=func1(x)
result=sum(x.^2);
end