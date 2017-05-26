function [abra, t, x, x_pont, darabszam, terulet] = zh2_f12_sol(a,b,c,d)

% teljesen ugyanilyen tipusu diffegyenletek, amelyekrol ez a feladat lett mintazva (csak a szamok masok, az elv egy az egyben ugyanaz), a kovetkezok:
% 1. feladat    https://wiki.itk.ppke.hu/twiki/pub/PPKE/Matlab/10_lab_matlab_2017_1517.pdf
% 4. pelda MAGYARAZATTAL      https://wiki.itk.ppke.hu/twiki/pub/PPKE/Matlab/06_lab_matlab_2017.pdf
% 2. feladat https://wiki.itk.ppke.hu/twiki/pub/PPKE/Matlab/11_lab_matlab_2017.pdf
% (+ 6.5 feladat a van der pol osszcillatoros a feladatgyujtemenybol, amely
% szinten mutatja az atirast!)
% ode45 help 2. pelda "Solve nonstiff equation"

% Vegeredmenyben tehat ez a fajta diffegyenlet tipus (masodrendu) 3(!)
% kulonbozo oran is elokerult.

% 1.5x''-(1-a^-2)*x' + x + 2.3 = 3 where a is an input parameter
% x(0) = 3 x'(0) = cos(b), where b is in degrees (input as well)
% defining so that x' = y and x'' = y' = ((3-2.3) - x + (1-a^-2)y)/1.5

tspan = [15 35]; 
init_cond = [3 cosd(b)]; %b fokban ->cos helyett cosd

odefun = @(t,x) [x(2); ((3-2.3)-x(1)+(1+a^-2)*x(2))/1.5];

[t, y] = ode45(odefun, tspan, init_cond);

x = y(:,1);
x_pont = y(:,2);

abra = figure;
subplot 121

plot(t,x,'k--')
hold on
plot(t,x_pont,'r-')

xlabel('ido')
ylabel('y(t)')
title('idotartomanybeli valtozasok')

log_ind = x <= mean(x);
darabszam = sum(log_ind); % ezt nyilvan tobbfelekeppen ossze lehetett szamolni
plot(t(log_ind),x(log_ind),'g*', 'MarkerSize', 3)

ind1 = find(t >= c,1);
ind2 = find(t >= d,1);

terulet = trapz(t(ind1:ind2), x(ind1:ind2));

legend('x', 'dx/dt', 'atlagnal kisebb pontok')


subplot 122
plot(x,x_pont,'b')
xlabel('ido')
ylabel('y(t)')
title('allapotter')


end




