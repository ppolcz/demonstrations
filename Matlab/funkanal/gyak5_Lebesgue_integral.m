%% Script gyak5_Lebesgue_integral
%  
%  file:   gyak5_Lebesgue_integral.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.03.16. Thursday, 12:15:03
%
%%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%%

xspan = [0,5];

resolution = 5000;
w_size = 121 * resolution / 1000;
w = hann(w_size);
w = w / sum(w);
f = conv(abs(randn(1,resolution+2*w_size)), w,'same') * 20;
f = f(w_size+1:resolution+w_size);
f = f - min(f) + rand;
x = linspace(xspan(1),xspan(2),resolution);

%%

figure
for n = 2:12
    step_tiks = linspace(0,n,2^n+1)';
    step = step_tiks(:,ones(1,resolution));
    
    ff = f(ones(1,2^n+1),:);
    kul = step-ff;
    kul_prev = kul(:,1:end-1);
    kul_next = kul(:,2:end);
    kul_dot = max(kul_prev .* kul_next < 0,[],1);
    
    choose = -n/2^n <= kul & kul < 0;
    hatarok = x(max(kul_prev .* kul_next < 0,[],1));
    
    s = sum(choose .* step,1);
    s(kul(end,:) < -n/2^n) = n;
    
    axismin = 0;
    axismax = floor(max(f)+1);
    
    Color_aux = [1 1 1]*0.8;
    
    hold off
    plot(x,f, 'LineWidth', 1.5), hold on
    S = plot(x,s, 'LineWidth', 1.5);
    if n < 7
        plot(x,step, 'Color', Color_aux)
        plot([hatarok ; hatarok],repmat([axismin;axismax],size(hatarok)), 'Color', Color_aux)
    else
        grid on
    end
    plot(xspan,-[1 1]*n/2^n,'k')
    patch([x(1) x x(end)], [0 s 0], S.Color, 'FaceAlpha', 0.1)
    axis([xspan axismin axismax])
    
    ptitle(sprintf('$n = %g$, $%s s ~%s m = %g$, $%s f ~%s m = %g$', ...
        n, '\\int', '{\\rm d}', trapz(x,s), '\\int', '{\\rm d}', trapz(x,f)))
    snapnow
    % waitforbuttonpress
end

%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX