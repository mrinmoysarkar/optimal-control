function pd=DRE(t,p)
r = 500;
q1 = 80;
q2 = 1;
pd=[q1-p(2)^2/r;...
    p(1)-p(2)*p(3)/r;...
    2*p(2)+q2-p(3)^2/r];
end