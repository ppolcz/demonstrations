%% Script gyak5_BIBO
%  
%  file:   gyak5_BIBO.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.03.16. Thursday, 18:59:45
%
%%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% System operator norm

s = tf('s');
H = (4 + s) / (2 + s + s^2)
[Hinf,peak_freq] = norm(H,Inf)

T = 12;
freqspan = [0.1 100];
[h,t] = impulse(H,T);
h_norm1 = trapz(t,abs(h))

figure('Position', [ 430 247 1218 355 ], 'Color', [1 1 1]), subplot(121)
bopts = bodeoptions;
bopts.MagUnits = 'abs';
bopts.PhaseUnits = 'rad';
bopts.XLim = freqspan;
plot(freqspan, [1 1]*Hinf,'r:', 'LineWidth', 1.5), hold on
plot([1 1]*peak_freq, [-10 10], 'r:', 'LineWidth', 1.5)
bodeplot(H,bopts);
ptitle(sprintf('$%s = %g$ (peak gain marked by red dotted line)','\\mathcal{H}_\\infty', Hinf))
grid on

subplot(122), hold on
plot(t,h)
plot(t([1,end]),[1 1]*dcgain(s*H),':','Color',[1 1 1]*0.5, 'LineWidth',2),
xlim([0,T])
ptitle(sprintf('$%s = %g$', '\\int_0^\\infty |h(t)| {\\rm d} t', h_norm1))
grid on


%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX