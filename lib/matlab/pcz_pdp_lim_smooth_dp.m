function [t,p,dp] = pcz_pdp_lim_smooth_dp(T, dt, p_lim, dp_lim, varargin)
%% pcz_pdp_lim_smooth_v2
%  
%  File: pcz_pdp_lim_smooth_v2.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2019. November 09. (2019a)
%

TMP_bzqpLWoBcwMvZxPDPVtb = pcz_dispFunctionName;

%%

opts.maxnrit = 10;
opts.wsize = 101;
opts = parsepropval(opts,varargin{:});

% ha wsize = 2*k --> wsize = 2*k+1
% ha wsize = 2*k+1 --> wsize = 2*k+1
opts.wsize = opts.wsize + mod(opts.wsize+1,2);

np = size(p_lim,1);

% fig1 = figure;
% fig2 = figure;

%%

N_cell = cell(np,1);
T_cell = cell(np,1);
t_cell = cell(np,1);
p_cell = cell(np,1);
dp_cell = cell(np,1);

for i = 1:np
    %%
    szorzo = 1;
    
    for proba = 1:opts.maxnrit
        %% [0] Meghatarozom, hogy milyen hosszu jelet generaljak
        % 
        % Ennyivel hosszabb idointervallumon generalom jelet. Igy a vegen ossze
        % lehet majd nyomni ugy, hogy az osszenyomott jel tspan-je [t0 t1] legyen
        % (legalabb). Az utolso tag: (opts.wsize - 1) / 10 egy heurisztika. A
        % simitastol is fugg ugyanis, hogy mennyire kicsi lesz a derivalt jel
        % maximuma.

        Time_multiplier = szorzo * min(abs(dp_lim(i,:))) * (opts.wsize - 1) / 5;
        T_ = T * Time_multiplier;

        N = round(T_ / dt);

        % Generating convolutional kernel
        w = hamming(opts.wsize);
        w = w / sum(w);

        %% [1] RANDOM GENERATOR

        % Eloszor dp-t generaljuk le (es simitjuk)
        dp = conv(randn(1,N + opts.wsize), w, 'valid');

        %% [2] Eltoljuk y iranyba dp-t, hogy min/max arany jo legyen
        % 
        % Adott a,b, u.h. a+b = adott
        % 
        % Keresem c-t u.h. 
        % 
        %   a'     a - c
        %  ---- = ------- = p  --->  a - c = p b - p c
        %   b'     b - c           (p-1) c = p b - a
        % 
        % Tehat:
        % 
        %      a - p b
        %  c = -------
        %       p - 1
        % 

        % Jelenlegi min/max (dp):
        a = min(dp);
        b = max(dp);

        % Elvart min/max arany:
        p = dp_lim(i,1)/dp_lim(i,2);

        % Eltolas mertekenek kiszamitasa a fenti keplet alapjan
        c = ( a - p*b ) / ( p - 1 );

        % Itt tortenik az y-eltolas
        dp = dp + c;

        % Kiszamoljuk p-t (integralunk)
        p = cumsum(dp) * dt;

        %% [3] Skalazzuk p-t, hogy kitoltse p_lim-et

        % Ehhez kell min/max:
        minp = min(p);
        maxp = max(p);

        % Skalazo tenyezo:
        scale = (p_lim(i,2) - p_lim(i,1))/(maxp - minp);

        % Skalazzuk es y iranyba eltoljuk p-t
        p = (p - minp) * scale + p_lim(i,1);

        % Skalazzuk a derivaltjat is
        dp = dp * scale;

        %% [4] Ugy hatarozzuk meg az idoskalat, hogy dp kitoltse dp_lim-et
        % 
        % Alapja:
        % 
        %  d/dt( f(at) ) = [ df/dt ]_{t = at} * a
        % 

        a = min(dp_lim(i,2) / max(dp), T_/T);

        T_ = T_ / a;

        N = numel(p);

        t = linspace(0,T_,N);
        dp = dp * a;

        ROSSZASAG = T_*max(dp)/(T*dp_lim(i,2));
        if 0.5 < ROSSZASAG && ROSSZASAG < 2
            break
        end

        szorzo = 1/ROSSZASAG;

    end % for
    
    dp_comp = diff(p(:,[1,1:end]),1,2)/(T_/N);
        
    T_cell{i} = T_;
    N_cell{i} = N;
    t_cell{i} = t';
    p_cell{i} = p';
    dp_cell{i} = dp';
    
    %{

    figure(fig1)
    ax(1) = subplot(2*np,1,i); plot(t,p), title(sprintf('p%d',i)), axis tight
    ax(2) = subplot(2*np,1,np+i); plot(t,[ dp ; dp_comp ]), title 'dp, dpComp', axis tight   
    linkaxes(ax,'x')

    %}
end % for

[ ~ , index ] = min([ T_cell{:} ]);

t = t_cell{index};

p_cell = cellfun(@(tt,pp) {interp1(tt,pp,t)}, t_cell, p_cell);
dp_cell = cellfun(@(tt,dpp) {interp1(tt,dpp,t)}, t_cell, dp_cell);

p = horzcat(p_cell{:});
dp = horzcat(dp_cell{:});

pcz_dispFunctionEnd(TMP_bzqpLWoBcwMvZxPDPVtb);

%{

T_ = t(end);
N = numel(t);
dp_comp = diff(p(:,[1,1:end]),1,2)/(T_/N);
figure(fig2);
subplot(311), plot(t,p), title p
subplot(312), plot(t,dp), title dp
subplot(313), plot(t,dp_comp), title dpComp

%}

end % function
