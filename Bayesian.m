clc;
clear;
close all;

action_risk = [0,1;6,0];
data1 = [-3.9847,-3.5549,-1.2401,-0.9780,-0.7932,-2.8531,-2.7605,-3.7287,-3.5414,...
    -2.2692,-3.4549,-3.0752,-3.9934,-0.9780,-1.5799,-1.4885,-0.7431,-0.4221,...
    -1.1186,-2.3462,-1.0826,-3.4196,-1.3193,-0.8367,-0.6579,-2.9683];
data2 = [2.8792,0.7932,1.1882,3.0682,4.2532,0.3271,0.9846,2.7648,2.6588];

P1_prior = 0.9;
P2_prior = 0.1;
mu1 = mean(data1);
sigma1 = (data1-mu1)*(data1-mu1)'/length(data1);
mu2 = mean(data2);
sigma2 = (data2-mu2)*(data2-mu2)'/length(data2);

x = -5:0.001:5;
P1_conditional  = 1/((2*pi)^0.5*sigma1)*exp(-0.5*((x-mu1)/sigma1).^2);
P2_conditional  = 1/((2*pi)^0.5*sigma2)*exp(-0.5*((x-mu2)/sigma2).^2);

P1_posterior = (P1_conditional*P1_prior)./(P1_conditional*P1_prior+P2_conditional*P2_prior);
P2_posterior = (P2_conditional*P2_prior)./(P1_conditional*P1_prior+P2_conditional*P2_prior);

P_posterior(1,:) = P1_posterior;
P_posterior(2,:) = P2_posterior;

R = action_risk*P_posterior;

len = length(R(1,:));
for i = 1:len-1
    if((R(1,i)>R(2,i))&&(R(1,i+1)<=R(2,i+1)))
        boundary = x(i+1);
    elseif((R(1,i)<R(2,i))&&(R(1,i+1)>=R(2,i+1)))
        boundary = x(i+1);
    end
    
end
figure;
plot(x,R(1,:),x,R(2,:));
title('风险分布');
figure;
plot(data1,0,'bx');
hold on;
plot(data2,0,'ro');
hold on;
plot(boundary,-1:0.01:1,'k.');
title('分类结果');


