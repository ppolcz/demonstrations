%% Script demo2_E_electric_dipole
%  
%  file:   demo2_E_electric_dipole.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.04.01. Saturday, 22:27:28
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_IbSWJNMuIiKbocfQKqXb = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% Erovonalak

Q1 = 1;
r1 = [0;1];

Q2 = -1;
r2 = [0;-1];

F = @(t,r) Q1*(r-r1) / norm(r-r1)^(3/2) + Q2*(r-r2) / norm(r-r2)^(3/2);

F_tmp = @(r) Q1*(r-repmat(r1,[1 size(r,2)])) ./ repmat(sum((r-repmat(r1,[1 size(r,2)])).^2,1).^(3/2),[2,1]) + ...
    Q2*(r-repmat(r2,[1 size(r,2)])) ./ repmat(sum((r-repmat(r2,[1 size(r,2)])).^2,1).^(3/2),[2,1]);

% [X,Y] = meshgrid(linspace(-3,3,10));

R = 0.01;
t = linspace(0,2*pi,70);
X = R*cos(t) + r1(1);
Y = R*sin(t) + r1(2);


figure, hold

for i = 1:numel(X)
    ri = [X(i);Y(i)];
    [t_ode,x_ode] = ode45(F,[0,10],ri);

    last = find(sum((x_ode - repmat(r2',[size(x_ode,1),1])).^2,2) < 0.0001,1);    
    x_ode_relevant = x_ode(1:last,:);

    % plot(x_ode(1,1),x_ode(1,2),'.b')
    plot(x_ode_relevant(:,1),x_ode_relevant(:,2),'b')
    
%     s = cumsum(sum(diff(x_ode_relevant,1).^2,2));
%     s = [s;s(end)+eps];
%     xx = interp1(s,x_ode_relevant,linspace(s(1),s(end),10));
%     E = F_tmp(xx')';
%     E = E ./ repmat(sqrt(sum(E.^2,2)),[1,2]);
%     quiver(xx(:,1),xx(:,2),E(:,1),E(:,2),0.4)
    
    drawnow
end

plot(r1(1),r1(2),'r.','MarkerSize',40);
plot(r2(1),r2(2),'b.','MarkerSize',40);

%%
% End of the script.
pcz_dispFunctionEnd(TMP_IbSWJNMuIiKbocfQKqXb);
clear TMP_IbSWJNMuIiKbocfQKqXb