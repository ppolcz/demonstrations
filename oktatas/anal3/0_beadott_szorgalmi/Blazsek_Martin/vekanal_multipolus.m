%% Multipólus erőtere és ennek integrálgörbéi
%  File: vekanal_multipolus.m
%  Author: Blazsek Martin János 
%  Reviewed by Polcz Péter on 2017. November 26.
% 
%%
% *Megjegyzés.* A Matlab kódokat érdemes szépen kommentelni annak
% érdekében, hogy a html-be való konvertálása szép és informatív legyen.
% Lásd:
% <https://www.mathworks.com/help/matlab/matlab_prog/marking-up-matlab-comments-for-publishing.html
% Matlab Publishing Markup>
%%
Qi = [ 2  0.5  -1 1];
xi = [-1  0     1 1];
yi = [-1  1    -1 2];

lim = 3;
step = 0.15;

%r1 = [xp yp]';
%r2 = [xn yn]';

XY = [xi; yi];

[X,Y] = meshgrid(-lim:step:lim);
eps0 = 8.854*10^-12;

U = zeros(length(X));
V = zeros(length(Y));

for i = 1:length(Qi)
    U = U+(1/(4*pi*eps0))*((Qi(i)*(X-xi(i))./(sqrt((X-xi(i)).^2+(Y-yi(i)).^2).^3)));
    V = V+(1/(4*pi*eps0))*((Qi(i)*(Y-yi(i))./(sqrt((X-xi(i)).^2+(Y-yi(i)).^2).^3)));
end

hold on;
L = sqrt(U.^2+V.^2);
quiver(X,Y,U./L,V./L,'color',[150/255 150/255 150/255]);
xlim([-lim lim]);
ylim([-lim lim]);

f = @(t,r) [0; 0];
for i = 1:length(Qi)
    f = @(t,r) f(t,r) + ...
        [
        (Qi(i)/(4*pi*eps0))*(((r(1)-xi(i))/norm(r - XY(:,i))^3));
        (Qi(i)/(4*pi*eps0))*(((r(2)-yi(i))/norm(r - XY(:,i))^3));
        ];
end
disp(f);    

for i = 1:length(Qi)
    for n = -0.02:0.01/Qi(i):0.02
        for m = -0.02:0.01/Qi(i):0.02  
            if (Qi(i)>0) 
                [t,x] = ode15s(f,[0 10000],[xi(i)+n yi(i)+m]);
                plot(x(:,1),x(:,2),'k','linewidth',1.5);
            end
        end
    end
end

for i = 1:length(Qi)
    if (Qi(i)>0)
        plot(xi(i),yi(i),'or','markerfacecolor','r','markersize',Qi(i)*10);
    else 
        plot(xi(i),yi(i),'ob','markerfacecolor','b','markersize',abs(Qi(i))*10);
    end
end
