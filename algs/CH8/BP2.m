clear;
close all;
clc;
p=[2056 2395 2600 2298 1634 1600 1873 1478 1900
    2395 2600 2298 1634 1600 1873 1478 1900 1500
    2600 2298 1634 1600 1873 1478 1900 1500 2046];
t=[2298 1634 1600 1873 1478 1900 1500 2046 1556];
pmax=max(max(p));
pmin=min(min(p));
P=(p-pmin)./(pmax-pmin);
tmax=max(t);
tmin=min(t);
T=(t-tmin)./(tmax-tmin);
net=newff(minmax(P),[5,1],{'tansig','logsig'},'traingdx');
net.trainParam.show=50;
net.trainParam.lr=0.05;
net.trainParam.epochs=1000;
net.trainParam.goal=1e-3;
[net,tr]=train(net,P,T);
A=sim(net,P);
a=A.*(tmax-tmin)+tmin;
x=4:12;
figure
plot(x,t,'+');
hold on;
plot(x,a,'or');
hold off
xlabel('月份')
ylabel('销量')
legend('实际销量 ','预测销量');