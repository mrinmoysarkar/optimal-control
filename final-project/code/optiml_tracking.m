%% author: mrinmoy sarkar
% email: msarkar@aggies.ncat.edu

clear all;
close all;

t0 = 0;
tf = 20;
dt = 0.001;
t = t0:dt:tf;

no_of_state = 4;
no_of_input = 1;



M = .5;
m = 0.2;
b = 0.1;
i = 0.006;
g = 9.8;
l = 0.3;

p = i*(M+m)+M*m*l^2; %denominator for the A and B matricies
A = [0      1              0           0;
    0 -(i+m*l^2)*b/p  (m^2*g*l^2)/p   0;
    0      0              0           1;
    0 -(m*l*b)/p       m*g*l*(M+m)/p  0];
B = [     0;
    (i+m*l^2)/p;
    0;
    m*l/p];
C = [0 0 1 0];
x0 = [0 0 0 0]';

QQ = [2700,79700];
pptf = [0, 10000];

ref1 = zeros(length(t),1);
refdummy = 2*sin(2*pi*t/20);
% for sinusoidal input
ref1(:,1) = refdummy;

% for step input
%ref1(:,1) = 1;
%ref1(1:2000,1)=0;


for qq=1:2
    for pp=1:2
        
        Q = QQ(qq);%79700;
        R = 1;
        ptf = pptf(pp);% 10000;
        
        
        
        
        ref1 = flipud(ref1);
        ref = (ref1(1,:))';
        
        
        
        S = zeros(no_of_state,no_of_state);
        nu = zeros(no_of_state,1);
        
        
        
        all_nu = zeros(length(t),size(nu,1)*size(nu,2));
        all_nu(1,:) = C'*ptf*ref;
        
        all_s = zeros(length(t),size(S,1)*size(S,2));
        stf = C'*ptf*C;
        all_s(1,:) = stf(:);
        all_k = zeros(length(t),no_of_state*no_of_input);
        K = (R^(-1))*B'*stf;
        all_k(1,:) = K(:);
        
        for i=2:length(t)
            S0 = reshape(all_s(i-1,:),size(S));
            S = S0;
            S_dot = A'*S + S*A - S*B*(R^(-1))*B'*S + C'*Q*C;
            k1 = dt*S_dot;
            
            S = S0 + k1./2;
            S_dot = A'*S + S*A - S*B*(R^(-1))*B'*S + C'*Q*C;
            k2 = dt*S_dot;
            
            S = S0 + k2./2;
            S_dot = A'*S + S*A - S*B*(R^(-1))*B'*S + C'*Q*C;
            k3 = dt*S_dot;
            
            S = S0 + k3;
            S_dot = A'*S + S*A - S*B*(R^(-1))*B'*S + C'*Q*C;
            k4 = dt*S_dot;
            
            S = S0 + k1./6 + k2./3 + k3./3 + k4./6;
            
            all_s(i,:) = S(:);
            
            K = (R^(-1))*B'*S;
            all_k(i,:) = K(:);
            
            nu0 = reshape(all_nu(i-1,:),size(nu));
            nu = nu0;
            ref = (ref1(i,:))';
            nu_dot = (A-B*K)'*nu + C'*Q*ref;
            k1 = dt*nu_dot;
            
            nu = nu0 + k1./2;
            nu_dot = (A-B*K)'*nu + C'*Q*ref;
            k2 = dt*nu_dot;
            
            nu = nu0 + k2./2;
            nu_dot = (A-B*K)'*nu + C'*Q*ref;
            k3 = dt*nu_dot;
            
            nu = nu0 + k3;
            nu_dot = (A-B*K)'*nu + C'*Q*ref;
            k4 = dt*nu_dot;
            
            nu = nu0 + k1./6 + k2./3 + k3./3 + k4./6;
            
            all_nu(i,:) = nu(:);
        end
        
        all_k = flipud(all_k);
        all_nu = flipud(all_nu);
        all_s = flipud(all_s);
        ref1 = flipud(ref1);
        
        u = zeros(length(t), no_of_input);
        x = zeros(length(t), no_of_state);
        x(1,:) = x0';
        F = 1;
        u(1,:) = -(reshape(all_k(1,:),size(K)))*(x(1,:))' + F*(R^(-1))*B'*reshape(all_nu(1,:),size(nu));
        for i=2:length(t)
            
            xx0 = (reshape(x(i-1,:),size(x0)));
            xx = xx0;
            xx_dot = A*xx + B*(u(i-1,:)');
            k1 = dt*xx_dot;
            
            xx = xx0 + k1./2;
            xx_dot = A*xx + B*(u(i-1,:)');
            k2 = dt*xx_dot;
            
            xx = xx0 + k2./2;
            xx_dot = A*xx + B*(u(i-1,:)');
            k3 = dt*xx_dot;
            
            xx = xx0 + k3;
            xx_dot = A*xx + B*(u(i-1,:)');
            k4 = dt*xx_dot;
            
            xx = xx0 + k1./6 + k2./3 + k3./3 + k4./6;
            
            x(i,:) = xx(:);
            %F = pinv(C*pinv(-A+B*(reshape(all_k(i,:),size(K))))*B);
            u(i,:) = -(reshape(all_k(i,:),size(K)))*(x(i,:))' + F*(R^(-1))*B'*reshape(all_nu(i,:),size(nu));
        end
        figure(1)
        plot(t,ref1)
        xlabel('time(t) in second')
        ylabel('reference signal(r(t)) in degree')
        grid on
        figure(2)
        %clf
        subplot(231)
        plot(t,u)
        hold on
        xlabel('time(t) in second')
        ylabel('control input(u) in newton')
        grid on
        subplot(232)
        plot(t,x(:,1))
        hold on
        xlabel('time(t) in second')
        ylabel('linear position(x) in m')
        grid on
        subplot(233)
        plot(t,x(:,2))
        hold on
        xlabel('time(t) in second')
        ylabel('linear velocity(v) in m/s')
        grid on
        subplot(234)
        plot(t,x(:,3))
        hold on
        xlabel('time(t) in second')
        ylabel('angle with respect to vertical line(phi) in degree ')
        grid on
        subplot(235)
        plot(t,x(:,4))
        hold on
        xlabel('time(t) in second')
        ylabel('angular velocity(phi dot) in degree/s')
        grid on
        subplot(236)
        plot(t,x(:,3))
        xlabel('time(t) in second')
        ylabel('phi and ref angle in degree')
        hold on
        %plot(t,ref1)
        %hold on
        %legend('phi','ref')
        grid on
        figure(3)
        plot(t, abs(x(:,3)'-ref1'))
        xlabel('time(t) in second')
        ylabel('error in tracking')
        hold on
    end
end

figure(2)
subplot(231)
legend('Q=2700, R=1, ptf=0', 'Q=2700, R=1, ptf=10000', 'Q=79700, R=1, ptf=0', 'Q=79700, R=1, ptf=10000')

subplot(232)
legend('Q=2700, R=1, ptf=0', 'Q=2700, R=1, ptf=10000', 'Q=79700, R=1, ptf=0', 'Q=79700, R=1, ptf=10000')
subplot(233)
legend('Q=2700, R=1, ptf=0', 'Q=2700, R=1, ptf=10000', 'Q=79700, R=1, ptf=0', 'Q=79700, R=1, ptf=10000')
subplot(234)
legend('Q=2700, R=1, ptf=0', 'Q=2700, R=1, ptf=10000', 'Q=79700, R=1, ptf=0', 'Q=79700, R=1, ptf=10000')
subplot(235)
legend('Q=2700, R=1, ptf=0', 'Q=2700, R=1, ptf=10000', 'Q=79700, R=1, ptf=0', 'Q=79700, R=1, ptf=10000')
subplot(236)
plot(t,ref1)
legend('phi,Q=2700, R=1, ptf=0', 'phi,Q=2700, R=1, ptf=10000', 'phi,Q=79700, R=1, ptf=0', 'phi,Q=79700, R=1, ptf=10000','ref')
figure(3)
legend('Q=2700, R=1, ptf=0', 'Q=2700, R=1, ptf=10000', 'Q=79700, R=1, ptf=0', 'Q=79700, R=1, ptf=10000')



