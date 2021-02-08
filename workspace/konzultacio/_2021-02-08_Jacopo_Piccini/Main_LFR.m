%%
%  File: Main_LFR.m
%  Directory: 2_demonstrations/workspace/konzultacio/_2021-02-08_Jacopo_Piccini
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2021. February 08. (2020b)
%

close all;
clear;
clc;
fig = 0;
warning('off')
%% Main LFR

syms data alpha

A = -[
    2*alpha*data^2  2*alpha*data
    2*alpha*data    2*alpha
    ];

B = [
    2*alpha*data
    2*alpha
    ];

%%%%% Ideal observer %%%%%
C = [data, 1];                                   % y = dw + b 
D = 0;

setred('default')                                % Default order reduction
abcd = sym2gss([A, B; C, D]);                    % Static gain matrix
sys = abcd2gss(abcd, 2);                         % 2 is the number of states

% sys is the first M-Delta factorization 
% up to now the parameters have no nominal value and bounds, they need to
% be set
set(sys, 'data', 'Type', 'PAR', 'NomValue', 0.5, 'Bounds', [0, 0.99]);
set(sys, 'alpha', 'Type', 'PAR', 'NomValue', 1e-3, 'Bounds', [1e-5, 2]);

sys_lfr = gss2lfr(sys, 1);                       % warning display on
sys_lfr = minlfr(sys_lfr);
blk = sys_lfr.blk;

d = 0.5;
alp = 1e-3;
[int_sys, msg] = uplft(sys_lfr, {data, alpha}, {d, alp});
if msg == 1
    error('Upper LFT is not well-posed')
end
sys_uss = gss2uss(sys);

[M_uss, D_uss] = lftdata(sys_uss);
% If the parameter are changed please comment all the remaining part of the
% section to avoid issues, especially if \alpha is the only parameter
sys_uss.StateName{1, 1} = 'w';
sys_uss.StateName{2, 1} = 'b';
sys_uss.InputName{1, 1} = 'y';
sys_uss.OutputName{1, 1} = '\hat{y}';
%% Stability Analysis using the RC Toolbox

d_min = 0;
d_max = 0.99;
alpha_min = 1e-5;
alpha_max = 2;

% Nominal LTI system
A_0 = ltisys([0, 0; 0, 0]);
% Related to \alpha
A_1 = ltisys([0, 0; 0, -2], zeros(2));
% Related to \alpha * d
A_2 = ltisys([0, -2; -2, 0], zeros(2));
% Related to \alpha * d^2
A_3 = ltisys([-2, 0; 0, 0], zeros(2));

pv = pvec('box', [alpha_min alpha_max; alpha_min * d_min alpha_max * d_max; alpha_min * d_min ^ 2 alpha_max * d_max ^  2]);
pd_sys = psys(pv, [A_0, A_1, A_2, A_3]);

% options(1) = 1 -> maximizing the stability region by scaling the
% parameter box around its center
% 
% options(2) = 1 -> least conservative mode
%
% options(3) = -> precision, default = 1e-8
[tau_LMI, X_LMI] = quadstab(pd_sys); 
[tau_LPF, Q0, Q1, Q2, Q3] = pdlstab(pd_sys);

%% USS Analysis

nom_2norm = norm(M_uss, 2);                      % H_2 norm of the nominal system
nom_infnorm = hinfnorm(M_uss);                   % H_\infty norm of the nominal system

n_samples = 10000;
[sys_sampled, samples] = usample(sys_uss, n_samples);
alpha_sampled = [];
data_sampled = [];
sys_2norm = [];
D_norm = [];
rsys_v = [];
n2_finite = [];
n2_nfinite = [];

for i = 1 : length(samples)
    ad_st = samples(i, :, :);
    
    alpha_i = ad_st.alpha;
    data_i = ad_st.data;
    
    alpha_sampled = [alpha_sampled, alpha_i];
    data_sampled = [data_sampled, data_i];
    
    sys_i = sys_sampled(:, :, i);
    if rank(sys_i.A) == 3
        r_sys = true;
    else
        r_sys = false;
    end
    rsys_v = [rsys_v r_sys];
    
    sys2_i= norm(sys_i, 2);
    if isfinite(sys2_i)
        n2_finite = [n2_finite; i, alpha_i, data_i, sys2_i, hinfnorm(sys_i)];
        n2_nfinite = [n2_nfinite];
    else
        n2_finite = [n2_finite];
        n2_nfinite = [n2_nfinite; i, alpha_i, data_i, hinfnorm(sys_i)];
    end
    
end
inf_count = 0;
for j = 1 : length(n2_nfinite)
    if ~isfinite(n2_nfinite(j, 4))
        inf_count = inf_count + 1;
    else
        inf_count = inf_count;
    end
end

st_sys = length(n2_finite);
fprintf('\n There are %d systems with finite H_2 norm amongst the %d sampled', st_sys, n_samples)
fprintf('\n There are %d out of %d systems with finite H_infty norm while H_2 non-finite norm', length(n2_nfinite) - inf_count, length(n2_nfinite))
%% 
X = n2_finite(:, 2);                             % \alpha
Y = n2_finite(:, 3);                             % data
Z1 = n2_finite(:, 4);                            % H_2
Z2 = n2_finite(:, 5);                            % H_\infty

XX = n2_nfinite(:, 2);                           % \alpha when the h2 norm is nonfinite
YY = n2_nfinite(:, 3);                           % data when the h2 norm is nonfinite
ZZ = n2_nfinite(:, 4);                           % H_\infty norm when the h2 norm is nonfinite

[X_s, I_X] = sort(X);
Z1_s = [];
for i = 1 : length(I_X)
    Z1_s = [Z1_s; Z1(I_X(i))];
end
pp = polyfit(X_s, Z1_s, 13);
f1 = polyval(pp,X_s);

err = f1 - Z1_s;
err_rel = [];
for i = 1 : length(f1)
    er_i = (f1(i) - Z1_s(i)) / Z1_s(i) * 100;
    err_rel = [err_rel; er_i];
end
err_avg = sum(abs(err_rel)) / length(err_rel);

fig = fig + 1;
figure(fig);
scatter(X, Z1)
xlabel('\alpha')
% ylabel('data')
ylabel('H_2 norm')
% view(360, 360)
title('||H_2(\alpha)||')
hold on
grid on
plot(X_s, f1, 'r', 'LineWidth', 1)
legend('Sampled data', 'Interpolating polynomial')

fig = fig + 1;
figure(fig);
scatter3(X, Y, Z1)
xlabel('\alpha')
ylabel('data')
zlabel('H_2(\alpha, data)-Norm')
hold on
grid on
title('||H_2(\alpha, data)||')

fig = fig + 1;
figure(fig);
scatter3(X, Y, Z2)
xlabel('\alpha')
ylabel('data')
zlabel('H_\infty norm')
grid minor
title('||H_\infty(\alpha, data)||, when ||(.)||_2 is finite')

fig = fig + 1;
figure(fig);
% This graph is used to show the distribution of the used samples, in order
% to check if some areas of the domain p \in [[alpha_min, alpha_max], [data_min, data_max]]
% is not properly represented
scatter(alpha_sampled, data_sampled)
xlabel('\alpha')
ylabel('data')
title('All Samples Distribution')
hold on
scatter(X, Y, 'r')
legend('All sampled pairs', 'Finite H_2 norm sampled pairs')
title('(\alpha, data) pair distribution')

fig = fig + 1;
figure(fig);
% This plot is to try to understand if the finiteness/non-finiteness of the H_2 norm 
% can be bounded in a specific region of the domain
scatter(X, Y, 'r')
hold on
scatter(XX, YY, 'k*')
legend('Finite H_2 norm', 'Non-Finite H_2 norm')
title('(\alpha, data) pair distribution')

fig = fig + 1;
figure(fig);
% This plot shows how the H_\infty norm varies when the H_2 norm is
% non finite 
scatter3(XX, YY, ZZ);
xlabel('\alpha')
ylabel('data')
zlabel('H_{\infty} norm')
title('H_{\infty} norm wehn H_2 norm is non-finite')

fp_3 = fit([X, Y], Z1, 'linearinterp');
% This plot shows the interpolated surface of the H_2 norm w.r.t. \alpha,
% data
fig = fig + 1;
figure(fig);
plot(fp_3, [X, Y], Z1)
xlabel('\alpha')
ylabel('data')