function [X,u,pf,t]=simoptsys(A,B,r,x0,tf)
[tb,p]=ode45(@DRE,-tf:0.001:0,[2;0;2]);
pf = flipud(p);
t = -flipud(tb);
k = (1/r)*pf(:,2:3);
X(:,1) = x0;
u(1) = -k(1,:)*X(:,1);

for n=1:length(t)-1
    X(:,n+1)=expm((A-B*k(n,:))*(t(n+1)-t(n)))*X(:,n);
    u(n+1) = -k(n+1,:)*X(:,n+1);
end
end