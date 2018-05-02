clc;
clear;
close all;

num1 = 50;  mu1_prior=[3,-1]; sigma1_prior=[0.3,0.2;0.2,0.4];
num2 = 60;  mu2_prior=[-2,-3]; sigma2_prior=[0.4,0.1;0.1,0.3];
num3 = 70;  mu3_prior=[0,3]; sigma3_prior=[0.6,0;0,0.7];
action_risk = [0,2,1;1,0,2;2,1,0];
data1 = mvnrnd(mu1_prior,sigma1_prior,num1);
data2 = mvnrnd(mu2_prior,sigma2_prior,num2);
data3 = mvnrnd(mu3_prior,sigma3_prior,num3);


mu1 = mean(data1);
mu2 = mean(data2);
mu3 = mean(data3);

sigma1 = (data1-mu1)'*(data1-mu1)/length(data1);
sigma2 = (data2-mu2)'*(data2-mu2)/length(data2);
sigma3 = (data3-mu3)'*(data3-mu3)/length(data3);

P_prior = [0.3,0.3,0.4];

x = -6:0.3:6;
len = length(x);
X = zeros(len*len,2);
for i = 1:len
    x0 = x(i)*ones(len,1);
    X((len-1)*i+1:(len-1)*i+len,1)=x;
    X((len-1)*i+1:(len-1)*i+len,2)=x0;
end

P1_conditional = 1/((2*pi)^1.5*det(sigma1))*exp(-0.5*(X-mu1)*sigma1^-1*(X-mu1)');
P2_conditional = 1/((2*pi)^1.5*det(sigma2))*exp(-0.5*(X-mu2)*sigma2^-1*(X-mu2)');
P3_conditional = 1/((2*pi)^1.5*det(sigma3))*exp(-0.5*(X-mu3)*sigma3^-1*(X-mu3)');

PX = P1_conditional*P_prior(1)+P2_conditional*P_prior(2)+P3_conditional*P_prior(3);
P1_posterior = (P1_conditional*P_prior(1))./(PX);
P2_posterior = (P2_conditional*P_prior(2))./(PX);
P3_posterior = (P3_conditional*P_prior(3))./(PX);

P_posterior(1,:) = diag(P1_posterior);
P_posterior(2,:) = diag(P2_posterior);
P_posterior(3,:) = diag(P3_posterior);

R = action_risk*P_posterior;
[Rmin,index] = min(R);

figure;
for i = 1:num1
    plot(data1(i,1),data1(i,2),'rx');
    hold on;
end
for i = 1:num2
    plot(data2(i,1),data2(i,2),'gx');
    hold on;
end
for i = 1:num3
    plot(data3(i,1),data3(i,2),'bx');
    hold on;
end


for i = 1:len*len-1 
    %{
    if (index(i)~=index(i+1))
        plot(X(i,1),X(i,2),'ko');
        hold on;
    end
    %}
    switch index(i)
        case 1
            plot(X(i,1),X(i,2),'r.');
            hold on;
        case 2
            plot(X(i,1),X(i,2),'g.');
            hold on;
        case 3
            plot(X(i,1),X(i,2),'b.');
            hold on;
    end
end







