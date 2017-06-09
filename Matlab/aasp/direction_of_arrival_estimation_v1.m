%% Array Signal Processing, Direction of Arrival (DoA) estimation
%  
%  file:   direction_of_arrival_estimation_v1.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.06.09. Friday, 10:01:27
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% Constants

% Speed of light
c = 299792458;

% Carrier frequency
fc = 10*1e9; % in GHz

% Wavelength of the carrier signal
lambda = c / fc;

% Sampling period and sampling frequency
Samples_per_period = 10;
fs = fc*Samples_per_period;
Ts = 1/fs;

% Period per symbol
Period_per_symbol = 10;

% Number of samples per symbol
Samples_per_symbol = Samples_per_period * Period_per_symbol;

% Number of antennas
M = 20;

% Distance between the uniformly aligned antennas (ULA)
Delta = lambda / 2;


%%
% Design a bandpass filter

order    = 5;
fcutlow  = fc * 0.5;
fcuthigh = fc * 2;
[b,a]    = butter(order,[fcutlow,fcuthigh]/(fs/2), 'bandpass');

pzmap(tf(b,a,Ts))

%% 
% Generate PSK

% Number of sources
d = 3;

% Number of symbols per record
S = 4;

% Number of sample per record
N = Samples_per_symbol * S;

% Alphabet size of the PSK modulation
alphabet_size = 4;

% Data to be sent and its modulation as a complex amplitude
data = randi([0 alphabet_size-1],S,d);
txSig = pskmod(data,alphabet_size,pi/alphabet_size);

% Auxiliary stuff
indices = ones(Samples_per_symbol,1)*(1:S);
code = txSig(indices(:),:)';

% Time span
t = 0:Ts:(N-1)*Ts;

% Carrier signals with arbitrary phase shift
Ampl = 1;
phase = rand(d,1)*2*pi;
carrier = Ampl*exp(1j*(2*pi*fc*t));

% Signal and its bandpass filtered signal
s_unfiltered = exp(1j*phase) * carrier .* code;
s = filter(b,a,s_unfiltered')';

plot(t,[real(s_unfiltered); real(s)])

% Get a slice of s
N = 200;
s = s(:,41:N+40);
t = t(:,41:N+40);

%%

% True direction of arrivals
% theta = rand(1,d)*2*pi;
theta = [-1.2 -0.3 0.5];
mu = -2*pi*fc*Delta*sin(theta) / c; % = -pi * sin(theta)
vandermonde_constants = exp(1j*mu);

A_ULA = repmat(vandermonde_constants,M,1) .^ (repmat((1:M)',1,d)-1);

X = A_ULA * s + (randn(M,N) + 1j*randn(M,N))*Ampl/5;

plot(t,real(X));

[U,Sigma,~] = svd(X);
Singular_values = diag(Sigma);
fprintf '\n\nSingular values: \n'
disp(Singular_values(1:3*d))
disp '    ....'

%% 
% MUSIC

U0 = U(:,d+1:end);

N_theta = 360;
theta_span = linspace(-pi/2,pi/2,N_theta);
vandermonde_constants = exp(-1j*2*pi*fc*Delta*sin(theta_span) / c);
A = repmat(vandermonde_constants,M,1) .^ (repmat((1:M)',1,N_theta)-1);

S_MUSIC = sum(A .* conj(A),1) ./ sum((U0'*A) .* conj(U0'*A),1);
peak = max(S_MUSIC);

figure, plot(theta_span, S_MUSIC), hold on
stem(theta, ones(size(theta))*peak,'.')
% stem(theta, interp1(theta_span, S_MUSIC, theta))

% plot([pi/2 pi/2],[0 peak],'--','Color',[1,1,1]*0.5)
% plot(-[pi/2 pi/2],[0 peak],'--','Color',[1,1,1]*0.5)
plegend '$S_\mathrm{MUSIC}(\theta)$' 'true DoAs'
xlim([-pi/2,pi/2]), grid on

%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX