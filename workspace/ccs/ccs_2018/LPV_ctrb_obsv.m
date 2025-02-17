%% LPV system computations
% 
%  File: LPV_ctrb_obsv.m
%  Directory: 2_demonstrations/workspace/ccs/ccs_2018
%  Author: Peter Polcz (ppolcz@gmail.com) 
% 
%  Created on 2018. October 09.

%% Define a very nice affine LPV system

A0 = [
    1 3
    0 -3
    ];

A1 = [
    0 -1
    0 1
    ];

A2 = [
    0 0.5
    0 0
    ];

B0 = [
    1
    0
    ];

B1 = [
    0.5
    0
    ];

B2 = [
    0.1
    0
    ];

C = [ 1 0 ];

D = 0;

% n: number of states,                n = dim(x)
% m: number of inputs,                m = dim(u)
% p: number of outputs,               p = dim(y)
% r: number of uncertain parameters,  r = dim(rho)

[n,m] = size(B0);
p = size(C,1);
r = 2;

A_fh = @(rho) A0 + rho(1)*A1 + rho(2)*A2;
B_fh = @(rho) B0 + rho(1)*B1 + rho(2)*B2;

rho1_lim = [-1 1];
rho2_lim = [-2 2];

rho_lim = [
    rho1_lim
    rho2_lim
    ];

rho_lims_cell = num2cell(rho_lim,2);
X = allcomb(rho_lims_cell{:});


%% Quadratic detectability
% Using linear matrix inequalities, try to find an observer gain $L$, such
% that the observer's dynamics is $\dot {\hat x} = A(\varrho) \hat x + B u
% + L(y - \hat y)$, and the error dynamics $\dot e = \dot x - \dot {\hat x}
% = (A(\varrho) - L C) e$ is asymptotically stable by the means of a
% quadratic Lyapunov function $V(x) = x^T P x$ for any admissible parameter
% value.

M = sdpvar(n,p,'full');
P = sdpvar(n);

CONS = [ P - 0.001*eye(n) >= 0 ];
for i = 1:size(X,1)
    rhoi = X(i,:)';
    Ai = A_fh(rhoi);
    
    CONS = [ CONS 
        Ai'*P + P*Ai - M*C - C'*M' + 0.001*eye(n) <= 0
        ];
end

sdpopts = sdpsettings('solver', 'sedumi');
sol = optimize(CONS,[],sdpopts)

P = double(P);
M = double(M);
L = P\M;

%%
% Check solution

for i = 1:size(X,1)
    rhoi = X(i,:)';
    Ai = A_fh(rhoi);
        
    eig(Ai - L*C)
end

%% Estimate L2 norm
% Compute the induced $\mathcal L_2$ operator gain for system $(A(\varrho) -
% B(\varrho) K, B(\varrho), C)$, where $K = (5 , 5)$ is a robust
% stabilising static state feedback gain.

K = [5 5];

P = sdpvar(n);
gammaSqr = sdpvar;

CONS = [ P - 0.001*eye(n) >= 0, gammaSqr >= 0 ];
for i = 1:size(X,1)
    rhoi = X(i,:)';
    Ai = A_fh(rhoi);
    Bi = B_fh(rhoi); 

    Ak = Ai - Bi*K;
    eig(Ak)
    
    Lambda = [
        Ak'*P + P*Ak + C'*C , P * Bi
        Bi'*P               , -eye(m)*gammaSqr
        ];
        
    CONS = [ CONS 
        Lambda <= 0
        ];
end

sdpopts = sdpsettings('solver', 'sedumi');
sol = optimize(CONS,gammaSqr,sdpopts)

% Check LMI solution
check(CONS)

gammaSqr = double(gammaSqr);

gamma = sqrt(gammaSqr)


%% Minimize L2 norm
% Compute the optimal feedback gain $K$, \mbox{$u = -K x + v$} (where $v$
% is a disturbance input), that stabilizes the system and gives a minimal
% L2 gain from the disturbance $v$ to the output $y$.

N = sdpvar(m,n, 'full');
Q = sdpvar(n);
gammaSqr = sdpvar;

CONS = [ Q - 0.001*eye(n) >= 0, gammaSqr >= 0 ];
for i = 1:size(X,1)
    rhoi = X(i,:)';
    Ai = A_fh(rhoi);
    Bi = B_fh(rhoi); 
    
    Lambda = [
        Q*Ai' + Ai*Q - Bi*N - N'*Bi' , Bi               , Q*C'
        Bi'                          , -eye(m)*gammaSqr , zeros(m,p)
        C*Q                          , zeros(p,m)       , -eye(p)
        ];
        
    CONS = [ CONS 
        Lambda <= 0
        ];
end

sdpopts = sdpsettings('solver', 'sedumi');
sol = optimize(CONS,gammaSqr,sdpopts)
check(CONS)

Q = double(Q);
N = double(N);
P = inv(Q);
K = N/Q;

gammaSqr = double(gammaSqr);

gamma = sqrt(gammaSqr)

%% Check optimal L2 with simulation

rho = @(t) [
    min(max(sin(14*t) + randn(size(t)) * rho1_lim(2),rho1_lim(1)),rho1_lim(2))
    min(max(sin(41*t) + randn(size(t)) * rho2_lim(2),rho2_lim(1)),rho2_lim(2))
    ];

% v = @(t) sign(sin(31*t.^2));
v = @(t) ones(size(t));

f_ode = @(t,x) A_fh(rho(t))*x + B_fh(rho(t))*(-K*x + v(t));

[t,x] = ode45(f_ode, [0,1], [0;1]);

y = C*x';

figure

subplot(311), plot(t,v(t)), grid on, title 'Disturbance input v'
subplot(312), plot(t,x(:,1)), grid on, title 'State x(1) = y'
subplot(313), plot(t,x(:,2)), grid on, title 'Uncontrollable state x(2)'

L2_norm = @(t,u) sqrt( trapz(t,u.^2) );

L2_norm_of_v = L2_norm(t,v(t))

L2_norm_of_y = L2_norm(t,y)

Output_gain_for_this_input = L2_norm_of_y / L2_norm_of_v





return

%% Using the Robust Control Toolbox
% Unfortunatelly we do not have this toolbox yet.

d1 = ureal('d1', 0, 'Range', rho_lim(1,:));
d2 = ureal('d2', 0, 'Range', rho_lim(2,:));


A = [
         2*d1 - 3,        0,        0,             0,        0
                0, d1/2 - 1,        0,             0,        0
    d2 - 2*d1 + 2,        0,   d2 - 1,             0,        0
           2 - d2,        0, 4 - 2*d1, 2*d1 + d2 - 5, 2*d1 - 4
    d2 - 2*d1 + 2,        0,        0,             0,   d2 - 1
    ];


B = [
                -1
                 0
     d2 - 2*d1 - 5
     2*d2 - d1 - 2
          - d1 - 2
    ];

C = [ -3    4   -2    2    4 ];

D = 0;

sys_unc = ss(A,B,C,D);
simplify(sys_unc,'full');

figure
bopts = bodeoptions;
bopts.MagUnits = 'abs';
% bodeplot(sys_unc,bopts), grid on;
bodeplot(gridureal(sys_unc,30), bopts), grid on

Nr_samples = 2500;
[peak_gain,freki] = getPeakGain(gridureal(sys_unc,Nr_samples));

[peak_gain,I] = max(peak_gain);

[wcg,wcu] = wcgain(sys_unc)


%%

sys_fdb = ss(A-B*K,B,C,D);
simplify(sys_fdb,'full');

figure
bopts = bodeoptions;
bopts.MagUnits = 'abs';
% bodeplot(sys_unc,bopts), grid on;
bodeplot(gridureal(sys_fdb,30), bopts), grid on

Nr_samples = 2500;
[peak_gain,freki] = getPeakGain(gridureal(sys_fdb,Nr_samples));

[peak_gain,I] = max(peak_gain);

[wcg,wcu] = wcgain(sys_fdb)

