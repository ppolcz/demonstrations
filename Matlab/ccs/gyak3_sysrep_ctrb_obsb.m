%%
%
%  file:   gyak3_sysrep_ctrb_obsb.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2017.03.02. Thursday, 14:14:49
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c;
persist.backup();
%clear persist

%% Example 1.
% Give the state space representation of the following system
%
% $$ y^{(3)} + 6 \ddot y + 11 \dot y + 6 y = 2 \ddot u - 3 \dot u + 6 u $$
%
% Transfer function:
b = [2 -3 6];
a = [1 6 11 6];
H = tf(b,a)

%%
% Transform it to state space representation
sys = ss(H)
A = sys.a;
B = sys.b;
C = sys.c;
D = sys.d;

%%
% Compute the bode diagram of system $H(s)$ using built-in function
% (angular frequency scale)!
figure, bode(H), grid on

%%
% Plot the bode diagram MANUALLY!
%
% * First of all, we compute the transfer function $H(s)$
syms s w
Hs_sym = poly2sym(b,s) / poly2sym(a,s);
pretty(Hs_sym)

%%
% * Compute the transfer function in the Fourier (i.e. frequency)
% domain
Hjw_sym = subs(Hs_sym, s, 1j*w);
pretty(Hjw_sym)

%%
% * Generate a function handle
Hjw_fh = matlabFunction(Hjw_sym);

%%
% 1) Linear frequency scale, amplitude on the frequency span between
% [0,f_max]
f_max = 5;
f_span = linspace(0,f_max,1000);
w_span = 2*pi*f_span;

amplitude = abs(Hjw_fh(w_span));
phase_shift = angle(Hjw_fh(w_span));

figure,
subplot(211), plot(f_span,amplitude), grid on
subplot(212), plot(f_span,phase_shift), grid on

%%
% 1) Logarithmic frequency scale, magnitude on the frequency span
% between [0,f_max]
f_max = 10;
f_span = logspace(-2,log10(f_max),1000);
w_span = 2*pi*f_span;

magnitude = 10*log(abs(Hjw_fh(w_span)));
phase_shift = angle(Hjw_fh(w_span));

figure,
subplot(211), semilogx(f_span,magnitude), grid on
subplot(212), semilogx(f_span,phase_shift), grid on
xlabel('Frequency [Hz]')

%%
% Compute the bode diagram of system $H(s)$ using built-in function
% (frequency scale)!
bodeopts = bodeoptions;
bodeopts.FreqUnits = 'Hz';
figure, bodeplot(H,bodeopts), grid on

%% Compute the controllability and observability matrix of a SSM

A = [-6 -4 ; 2 0];
B = [4 ; 0];
C = [0  1];

%%
% Controllability matrix
Cn = ctrb(A,B)
Cn_by_hand = [B A*B]

%%
% Rank of matrix $\mathcal C_n$
rank_Cn = rank(Cn)

%%
% Observability matrix
On = obsv(A,C)
On_with_ctrb = ctrb(A',C')'
On_by_hand = [C ; C*A]

%%
% Rank of matrix $\mathcal O_n$
rank_On = rank(On)

%%
%  See also:
%   - obsvf (Observability normal form)
%   - ctrbf (Controllability normal form)

%% Unobservable subspace
% 
% Starting the system from any initial condition within the
% unobservability subspace, the output will be the same.

A = [
    -3  -2  0
    1    0  0
    1    0 -3
    ];

C = [ 1 0 0 ]
On = obsv(A,C)
unobsv = null(On)
x0 = rand(3,1)

figure, hold on
for i = 1:10
    [t,x] = ode45(@(t,x) A*x, [0, 10], x0 + unobsv*rand(size(unobsv,2),1));
    plot(t,rand*0.02 +(C*x')')
end
%% end of the scope
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX