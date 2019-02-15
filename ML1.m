close all;
clear all;
clc;
d=csvread('house_prices_data_training_data.csv',1,0);
s=size(d);
d1=d;
d=[ones(s(1),1) d];
f=[1 5 6];
d(:,f)=d(:,f)./max(d(:,f));
p=2;
m=s(1);
theta=100000*ones(1,length(f));
theta(1)=min(d(:,p));
delta=0.001;
mseo=1000;
msen=0;
alpha=1;
error=[];
idx=1;
thetac=theta;
thetac2=theta;
while((abs(mseo-msen)/max(mseo,msen)>delta))
    mseo=msen;
    for i=1:length(theta)
        diff=1;
%         thetac=theta;
        to=thetac(i);
        tn=thetac(i);
        while diff>delta
            a=0;
            for j=1:m
                a=a+(sum(thetac.*d(j,f))-d(j,p))*d(j,f(i));
            end
            to=tn;
            tn=to-alpha/m*a;
            diff=abs(tn-to)/max(tn,to);
            thetac(i)=tn;
        end
        thetac2(i)=thetac(i);
    end
    theta=thetac2;
    msen=0;
    for j=1:m
        msen=msen+(d(j,p)-sum(d(j,f).*theta))^2;
    end
    msen=msen/(2*m)
    error(idx)=msen;
    idx=idx+1;
end
robs=(d(:,f))'*(d(:,f));
robssig=(d(:,f))'*(d(:,1));
h=inv(robs)*robssig;
pp=h'*((d(:,f)))';
error2=sum((((d(:,1)/max(d(:,1)))'-pp).^2))/(2*s(1));
plot(1:idx-1,error);