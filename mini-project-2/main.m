%%
%clear all;
%close all;
%% finite time LQR
A = [0 1;...
     0 0];
B = [0;...
     1];
x0 = [15;...
      25];
tf = 100;
r = 500;

[X,u,pf,t] = simoptsys(A,B,r,x0,tf);

%%
clf
figure(1)
subplot(211)
plot(t,X(1,:))
hold on
plot(t,X(2,:))
xlabel('t')
ylabel('X(t)')
legend('X1(t)','X2(t)')
title('Finite time LQR')
grid on
subplot(212)
plot(t,u)
xlabel('t')
ylabel('u(t)')
grid on
title('Finite time LQR')

%% infinite time LQR
Q =[80 0;...
    0 1];
R = 500;
tf = 100;
k = lqr(A,B,Q,R);
t = 0:.01:tf;
X=[];
u=[];
X(:,1) = x0;
u(1) = -k*X(:,1);
for n=1:length(t)-1
    X(:,n+1)=expm((A-B*k)*(t(n+1)-t(n)))*X(:,n);
    u(n+1) = -k*X(:,n+1);
end

%%
figure(2)
subplot(211)
plot(t,X(1,:))
hold on
plot(t,X(2,:))
xlabel('t')
ylabel('X(t)')
legend('X1(t)','X2(t)')
title('Infinite time LQR')
grid on
subplot(212)
plot(t,u)
xlabel('t')
ylabel('u(t)')
title('Infinite time LQR')
grid on