clear;
close all;
clc;
m=50;
Alpha=1;
Beta=5;
Rho=0.1;
G=200;
Q=100;
C=[1304 2312;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;...
    3238 1229;4196 1044;4312 790;4386 570;3007 1970;2562 1756;...
    2788 1491;2381 1676;1332 695;3715 1678;3918 2179;4061 2370;...
    3780 2212;3676 2578;4029 2838;4263 2931;3429 1908;3507 2376;...
    3394 2643;3439 3201;2935 3240;3140 3550;2545 2357;2778 2826;2370 2975];
n=size(C,1);
D=zeros(n,n);
for i=1:n
    for j=1:n
        if i~=j
            D(i,j)=((C(i,1)-C(j,1))^2+(C(i,2)-C(j,2))^2)^0.5;
        else 
            D(i,j)=eps;
        end
    end
end
Eta=1./D;
Tau=ones(n,n);
Tabu=zeros(m,n);
NC=1;
R_best=zeros(G,n);
L_best=inf.*ones(G,1);
figure(1);
while NC <=G
    Randpos=[];
    for i=1:(ceil(m/n))
        Randpos=[Randpos,randperm(n)];
    end
    Tabu(:,1)=(Randpos(1,1:m))';
    for j=2:n
        for i=1:m
            visited=Tabu(i,1:(j-1));
            J=zeros(1,(n-j+1));
            P=J;
            Jc=1;
            for k=1:n
                if isempty(find(visited==k, 1))
                    J(Jc)=k;
                    Jc=Jc+1;
                end
            end
            for k=1:length(J)
                P(k)=(Tau(visited(end),J(k))^Alpha)*(Eta(visited(end),J(k))^Beta);
            end
            P=P/sum(P);
            Pcum=cumsum(P);
            Select=find(Pcum >= rand);
            to_visit=J(Select(1));
            Tabu(i,j)=to_visit;
        end
    end
    if NC >= 2
        Tabu(1,:)=R_best(NC-1,:);
    end
    L=zeros(m,1);
    for i=1:m
        R=Tabu(i,:);
        for j=1:(n-1)
            L(i)=L(i)+D(R(j),R(j+1));
        end
        L(i)=L(i)+D(R(1),R(n));
    end
    L_best(NC)=min(L);
    pos=find(L==L_best(NC));
    R_best(NC,:)=Tabu(pos(1),:);
    Delta_Tau=zeros(n,n);
    for i=1:m
        for j=1:(n-1)
            Delta_Tau(Tabu(i,j),Tabu(i,j+1))=Delta_Tau(Tabu(i,j),Tabu(i,j+1))+Q/L(i);
        end
        Delta_Tau(Tabu(i,n),Tabu(i,1))=Delta_Tau(Tabu(i,n),Tabu(i,1))+Q/L(i);
    end
    Tau=(1-Rho).*Tau+Delta_Tau;
    Tabu=zeros(m,n);
    for i=1:n-1
        plot([C(R_best(NC,i),1),C(R_best(NC,i+1),1)],...
            [C(R_best(NC,i),2),C(R_best(NC,i+1),2)],'bo-');
        hold on;
    end
    plot([C(R_best(NC,1),1),C(R_best(NC,n),1)],...
        [C(R_best(NC,1),2),C(R_best(NC,n),2)],'ro-');
    title(['优化最短距离:',num2str(L_best(NC))]);
    hold off;
    pause(0.005);
    NC=NC+1;
end
Pos=find(L_best==min(L_best));
Shortest_Route=R_best(Pos(1),:);
Shortest_Length=L_best(Pos(1));
figure(2);
plot(L_best);
xlabel('迭代次数')
ylabel('目标函数值')
title('适应度进化曲线')