close all;
clear all;
clc;
ds = tabularTextDatastore('house_prices_data_training_data1.csv','TreatAsMissing','NA',.....
    'MissingValue',0,'ReadSize',25000);
T = read(ds);
size(T);
Alpha=.15;
m=length(T{:,1});
U0=T{:,2};
U=T{:,4:19};

U1=T{:,20:21};
U2=U.^2;
% U3=1./(T{:,21}+eps);
% U3=U3/min(U3);
% U4=1./(T{:,7}+eps);
% U4=U4/max(U4);
% U5=T{:,4};%rayleigh distribution max at 4
X=[ones(m,1) U2];

n=length(X(1,:));
for w=2:n
    if max(abs(X(:,w)))~=0
    X(:,w)=(X(:,w)-mean((X(:,w))))./std(X(:,w));
    end
end

Y=T{:,3}/mean(T{:,3});
Theta=zeros(n,1);
k=1;
E(k)=(1/(2*m))*sum((X*Theta-Y).^2);%error calculation

R=1;
while R==1
Alpha=Alpha*1;
Theta=Theta-(Alpha/m)*X'*(X*Theta-Y);%gradient descent
k=k+1
E(k)=(1/(2*m))*sum((X*Theta-Y).^2);%new error
if E(k-1)-E(k)<0
    break
end 
q=(E(k-1)-E(k))./E(k-1);
if q <.000001
    R=0;
end
end
E(end)