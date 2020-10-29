clear;
close all;
clc;
sqrs=[20.55 22.44 25.37 27.13 29.45 30.10 30.96 34.06 36.42 38.09...
    39.13 39.99 41.93 44.59 47.30 52.89 55.73 56.76 59.17 60.63];
sqjdcs=[0.6 0.75 0.85 0.9 1.05 1.35 1.45 1.6 1.7 1.85 2.15 2.2...
    2.25 2.35 2.5 2.6 2.7 2.85 2.95 3.1];
sqglmj=[0.09 0.11 0.11 0.14 0.20 0.23 0.23 0.32 0.32 0.34 0.36...
    0.36 0.38 0.49 0.56 0.59 0.59 0.67 0.69 0.79];
glkyl=[5126 6217 7730 9145 10460 11387 12353 15750 18304 19836 ...
    21024 19490 20433 22598 25107 33442 36836 40548 42927 43462];
glhyl=[1237 1379 1385 1399 1663 1714 1834 4322 8132 8936 11099 ...
    11203 10524 11115 13320 16762 18673 20724 20803 21804];
p=[sqrs;sqjdcs;sqglmj];
t=[glkyl;glhyl];
[P,minp,maxp,T,mint,maxt]=premnmx(p,t);
net=newff(minmax(P),[8 2],{'tansig','purelin'},'traingdx');
net.trainParam.show=50;
net.trainParam.lr=0.035;
net.trainParam.epochs=2000;
net.trainParam.goal=1e-3;
[net tr]=train(net,P,T);
A=sim(net,P);
a=postmnmx(A,mint,maxt);
inputWeights=net.IW{1,1};
inputbias=net.b{1};
layerWeights=net.LW{2,1};
layerbias=net.b{2};
x=1990:2009;
newk=a(1,:);
newh=a(2,:);
figure
plot(x,newk,'r-o',x,glkyl,'b--+');
legend('网络输出客运量','实际客运量');
xlabel('年份');ylabel('客运量/万人');

figure
plot(x,newh,'r-o',x,glhyl,'b--+');
legend('网络输出货运量','实际货运量');
xlabel('年份');ylabel('货运量/万吨');

pnew=[73.39 75.55;3.9 4.1;0.98 1.02];
SamNum=size(pnew,2);
pnewn=tramnmx(pnew,minp,maxp);

HiddenOut=tansig(inputWeights*pnewn+repmat(inputbias,1,SamNum));
anewn=purelin(layerWeights*HiddenOut+repmat(layerbias,1,SamNum));
anew=postmnmx(anewn,mint,maxt)

anew_=postmnmx(sim(net,pnewn),mint,maxt)