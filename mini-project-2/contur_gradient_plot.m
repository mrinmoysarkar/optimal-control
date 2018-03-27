syms x y;
f=x^2-x*y+y^2+2*x;
figure
fcontour(f)
grid on
hold on
g = gradient(f, [x, y])

[X, Y] = meshgrid(-5:.1:5,-5:.1:5);
G1 = subs(g(1), [x y], {X,Y});
G2 = subs(g(2), [x y], {X,Y});
quiver(X, Y, G1, G2)
