close all;
clear all;
clc;
ds = tabularTextDatastore('heart_DD.csv','TreatAsMissing','NA',.....
    'MissingValue',0,'ReadSize',25000);
T = read(ds);
size(T);
Alpha=.15;
m=length(T{:,1});
U0=T{:,2};
U=T{:,[1 4]};
U2=U.^2;
X=[ones(m,1) U U2];

n=length(X(1,:));
for w=2:n
    if max(abs(X(:,w)))~=0
    X(:,w)=(X(:,w)-mean((X(:,w))))./std(X(:,w));
    end
end

Y=T{:,14};
Theta=zeros(n,1);
k=1;

% E(k)=(1/(2*m))*sum((X*Theta-Y).^2);%error calculation
h=1/(1+exp(-X*Theta));
J(k)=1/m*(-Y'*log10(h)'-(1-Y')*log10(h)');


R=1;
while R==1
Alpha=Alpha*1;
h=1./(1+exp(-X*Theta));
Theta=Theta-(Alpha/m)*X'*(h-Y);%gradient descent
k=k+1
J(k)=1/m*(-Y'*log10(h)-(1-Y')*log10(h));%new error
if J(k-1)-J(k)<0
    break
end 
q=(J(k-1)-J(k))./J(k-1);
if q <.000001
    R=0;
end
end
J(end)