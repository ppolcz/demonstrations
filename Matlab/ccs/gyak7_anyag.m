%% Script gyak7_anyag
%
%  file:   gyak7_anyag.m
%  author: Peter Polcz <ppolcz@gmail.com>
%
%  Created on 2017.03.30. Thursday, 10:25:44
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

%%

s = tf('s');

G = (s - 1) / (s^2 + 3*s + 2);

nyquist(G), hold on
t = 0:0.1:2*pi;
plot(sin(t),cos(t),'--'),
axis tight

[Gm,Pm,Wgm,Wpm] = margin(G)

%% Miert jobb a negativ visszacsatolas?
% Ha K = 1.

syms s



%% Gradient descent

syms x y real

f = x^2 + y^2;
df = gradient(f);

f_fh = matlabFunction(f, 'vars', {[x;y]});
df_fh = matlabFunction(df, 'vars', {[x;y]});

N = 50;
x = zeros(2,N);
x(:,1) = [10;10];
gamma = 0.1;
for i = 2:N
    x(:,i) = x(:,i-1) - gamma*df_fh(x(:,i-1));
end
x

%% Egytarolos tag vs tobbszoros gyoku egytarolos tagok

s = tf('s');

tau = 1;
figure(1), Fh = subplot(211); hold off

N = 15;
Tmax = N*tau;

for n = 6:20
    [h1,t1] = impulse(1/(1+s*tau)^n,Tmax);
    plot(t1,h1,'Color',[1 1 1]*0.9, 'LineWidth', 0.1), hold on
end

[h1,t1] = impulse(1/(1+s*tau),Tmax);
f1 = plot(t1,h1,'LineWidth',2); hold on

[h2,t2] = impulse(1/(1+s*tau)^2,Tmax);
f2 = plot(t2,h2);

[h3,t3] = impulse(1/(1+s*tau)^3,Tmax);
f3 = plot(t3,h3);

[h4,t4] = impulse(1/(1+s*tau)^4,Tmax);
f4 = plot(t4,h4);

[h5,t5] = impulse(1/(1+s*tau)^5,Tmax);
f5 = plot(t5,h5);

ptitle 'Impulse response'

L = legend([f1 f2 f3 f4 f5], ...
    '$\frac{1}{1+s\tau}$',...
    '$\frac{1}{(1+s\tau)^2}$',...
    '$\frac{1}{(1+s\tau)^3}$',...
    '$\frac{1}{(1+s\tau)^4}$',...
    '$\frac{1}{(1+s\tau)^5}$',...
    '');
L.Interpreter = 'latex';
L.FontSize = 17;

xlim([0, Tmax])

plot(...
    [0 tau tau 2*tau 2*tau 2*tau 3*tau 3*tau 3*tau 4*tau 4*tau],...
    [1/tau 0 interp1(t1,h1,tau) 0 interp1(t2,h2,2*tau) ...
    interp1(t1,h1,2*tau) ...
    0 interp1(t3,h3,3*tau) ...
    interp1(t1,h1,3*tau) ...
    0 interp1(t4,h4,4*tau) ...
    ],'k--')

set(gca,'XTick',(0:N)*tau)
labels = cellfun(@(a) {['' num2str(a) '\tau']}, num2cell(2:N));
set(gca,'XTickLabel',[ '0' '\tau' labels ])
grid on

subplot(212), hold off

[v1,t1] = step(1/(1+s*tau),Tmax);
f1 = plot(t1,v1,'LineWidth',2); hold on

[v2,t2] = step(1/(1+s*tau)^2,Tmax);
f2 = plot(t2,v2);

[v3,t3] = step(1/(1+s*tau)^3,Tmax);
f3 = plot(t3,v3);

[v4,t4] = step(1/(1+s*tau)^4,Tmax);
f4 = plot(t4,v4);

[v5,t5] = step(1/(1+s*tau)^5,Tmax);
f5 = plot(t5,v5);

L = legend([f1 f2 f3 f4 f5], ...
    '$\frac{1}{1+s\tau}$',...
    '$\frac{1}{(1+s\tau)^2}$',...
    '$\frac{1}{(1+s\tau)^3}$',...
    '$\frac{1}{(1+s\tau)^4}$',...
    '$\frac{1}{(1+s\tau)^5}$',...
    '');
L.Interpreter = 'latex';
L.FontSize = 17;

set(gca,'XTick',(0:N)*tau)
labels = cellfun(@(a) {['' num2str(a) '\tau']}, num2cell(2:N));
set(gca,'XTickLabel',[ '0' '\tau' labels ])
grid on

ptitle 'Step response'

%% Egytarolos tag

syms s t T K
H = K / (1 + s*T);
h(t) = ilaplace(H);
dh(t) = diff(h,t);

% y = f'(x0)(x - x0) + f(x0)
dh(0)*(T - 0) + h(0)
dh(T)*(2*T - T) + h(T)

%% Kettarolos tag - szimbolikus

syms xi tau s

a(s) = 1 + 2*xi*tau*s + tau^2*s^2;
simplify(solve(a(s),s)), pretty(ans)

assume((tau > 0) & (0 < xi) & (xi < 1))

h = ilaplace(subs(1/a), s)
pretty(h)
h = rewrite(h,'sincos')
pretty(h)

%% Kettarolos tag - numerikus

figure(1), subplot(211), hold off

s = tf('s');
tau = 1;
xi = 1;
H = 1 / (1 + 2*xi*tau*s + tau^2*s^2)
[h,t] = impulse(H);
plot(t,h), grid on

w0 = 1/tau;
we = w0*sqrt(1 - xi^2);
sigma_e = xi*w0;
phi = acos(sigma_e / w0);
h = -w0 / we * exp(-sigma_e*t).*(-sigma_e*sin(we*t+phi) + we*cos(we*t+phi));

hold on
plot(t,h)

subplot(212), hold off

step(H), grid on

%% 2 tarolos lengo tag

T = 4/pi;
xi = 0.6;
% xi = 0.2;
tspan = 20;

s = tf('s');
H_s = 1 / (1 + 2*xi*T*s + T^2*s^2);

[num,den] = tfdata(H_s);

s_sym = sym('s');
H_sym = poly2sym(cell2mat(num),s_sym)/poly2sym(cell2mat(den),s_sym);
H_fh = matlabFunction(H_sym);

[h,t,x] = impulse(H_s,tspan);

w0 = 1/T;
we = w0 * sqrt(1 - xi^2);

t_max = (1:3) * pi / we;
h_max = interp1(t,h,t_max);

figure(1)

subplot(211), hold off
% plot_erinto(t,h,t(1),t(2),0,[])
plot(t,h), hold on, grid on
plot(t_max,h_max, 'r*')
legend 'impulse response' 't_{max}, h_{max}'


[h,t,x] = step(H_s,tspan);
t_max = (1:3) * pi / we;
h_max = interp1(t,h,t_max);

subplot(212), hold off
% plot_erinto(t,h,t(1),t(2),[],1)
plot(t,h), hold on, grid on
plot(t_max,h_max, 'r*')

% subplot(133)
% nyquist(H_s)

%% tulloves

Dv = @(xi) exp(-pi * xi ./ sqrt(1 - xi.^2));
Dv([0 0.5 0.6 0.7 1])

%%

clear h

syms w0 we sigma_e t phi xi s T
assume(w0 > 0 & we > 0 & sigma_e > 0 & (tau > 0) & (0 < xi) & (xi < 1) &...
    in(w0,'real') & in(we, 'real') & in(sigma_e,'real') & in(t,'real') &...
    in(phi,'real') & in(xi,'real'))

h(t) = -w0/we * exp(-sigma_e*t)*(-sigma_e*sin(we*t+phi)+we*cos(we*t+phi));
pretty(h)

H = simplify(laplace(h));
pretty(H)

H = subs(H,'cos(phi)', xi);
H = subs(H,'sin(phi)', sqrt(1-xi^2));
H = subs(H,sigma_e, xi*w0);
H = subs(H,we, sqrt(1-xi^2)*w0);
H = simplify(H);
pretty(H)
H = simplify(subs(H,w0,1/T));
pretty(H)

syms theta
v(t) = int(subs(h,t,theta), theta, 0, t)

%%

syms w0 we sigma_e t phi xi s T
assume(w0 > 0 & we > 0 & sigma_e > 0 & (tau > 0) & (0 < xi) & (xi < 1) &...
    in(w0,'real') & in(we, 'real') & in(sigma_e,'real') & in(t,'real') &...
    in(phi,'real') & in(xi,'real') & in(T,'real') & in(s,'real') & T > 0 & s > 0)

ilaplace(H/s,s)
pretty(ans)

%%

xi = 0.7;
tau = 2;
w0 = 1/tau;
we = sqrt(1 - xi^2)/tau;
sigma_e = xi*w0;
phi = acos(xi);

h(t) = subs(h);
v(t) = subs(v);
dh(t) = diff(h(t),t);

double(simplify(h((1:3) * pi / we)))

%%

tau = 0.2;
xi = 0.7;
H = 1 / (1 + 2*xi*tau*s + tau^2*s^2);
[h,t] = impulse(H);
plot(t,h)

tau = 0.5;
xi = 0.7;
H = 1 / (1 + 2*xi*tau*s + tau^2*s^2);
[h,t] = impulse(H);
plot(t,h)

grid on

%% Vagasi frekvencia

s = tf('s');

H = 4 / (s + 2);

figure(1), subplot(211), hold off
bode(H), grid on

subplot(212), hold off
nyquist(H), hold on
t = 0:0.1:2*pi;
plot(sin(t),cos(t), 'r--')

%% PID tervezes

s = tf('s');
G = 1 / (s - 1);

Kp = 1;
Kd = 0;
Ki = 0.25;

PID = Kp*(1 + Kd*s + Ki/s);

Ge = feedback(series(PID,G),1)
[p,z] = pzmap(Ge)
impulse(Ge,8*pi)

%%
% End of the script.
pcz_dispFunctionEnd(TMP_IbSWJNMuIiKbocfQKqXb);
clear TMP_IbSWJNMuIiKbocfQKqXb