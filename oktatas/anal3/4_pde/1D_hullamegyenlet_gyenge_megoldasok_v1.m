%% Hullámegyenlet végtelen hosszú rúdban
% Analitikus gyenge megoldások
%
%  file:   hullamegyenlet_gyenge_megoldasok_v1.m
%  author: Peter Polcz <ppolcz@gmail.com>
%
%  Created on 2017. August 25.
%
% A kezdetiértékprobléma a következő
%
% $$
% \left\{\begin{aligned}
% &u''_{xx} = c^2 u''_{tt} \\
% &u(x,0) = f(x) \\
% &u'_t(x,0) = g(x)
% \end{aligned}\right.
% $$
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_IUCoYbqYsqgVhrUzFEKb = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c;
persist.backup();
%clear persist

%% Példa gyenge megoldásra, $g(x) = 0$
% $$f(x) = \left\{\begin{aligned} 0, ~~ \text{ha } x < 0 \\ 1, ~~
% \text{ha } x \ge 0 \end{aligned}\right., ~~~~~ g(x) = 0$$
%
% Az egyenlet analitikus megoldása
%
% $$
%     u(x,t) = \frac{f(x + ct) + f(x - ct)}{2} =
%     u(x,t) = \begin{dcases}
%         0 & x \in (-\infty,-ct),~ \text{ vagyis } \begin{dcases}
%             x + ct < 0 \\
%             x - ct < 0
%         \end{dcases} \\
%         \frac{1}{2} & x \in [-ct, ct), ~\text{ vagyis } \begin{dcases}
%             x + ct \ge 0 \\
%             x - ct < 0
%         \end{dcases} \\
%         1 & x \in [ct, \infty), ~\text{ vagyis } \begin{dcases}
%             x + ct \ge 0 \\
%             x - ct \ge 0
%         \end{dcases}
%     \end{dcases}
% $$


c = 4;
f = @(x) pif(x < 0, 0, 1);

u = @(x,t) 2\( f(x + c*t) + f(x - c*t) );

x = linspace(-30,30,1000);

g = max(abs(f(x)));

figure('Position', [ 226 566 1624 408 ], 'Color', [1 1 1])
tspan = [0 2 4];
for t = tspan
    plot(x,u(x,t))
    text(c*t, 1.1, sprintf('t = %g', t), persist.font.latex18{:})
    ylim([-0.2,1.2])
    if (t ~= tspan(end)), snapnow; end
end
ylim([-0.2,1.2])

%% Gauss függvény kezdeti feltétellel, $g(x) = 0$
% $$f(x) = \left\{\begin{aligned} 0, ~~ \text{ha } x < 0 \\ 1, ~~
% \text{ha } x \ge 0 \end{aligned}\right., ~~~~~ g(x) = 0$$

c = 4;
f = @(x) exp(-x.^2 / 2);


u = @(x,t) 2\( f(x + c*t) + f(x - c*t) );

x = linspace(-30,30,400);

figure('Position', [ 226 566 1624 408 ], 'Color', [1 1 1]), hold on
ylim([-0.2,1.2])
for t = [0 1 2 3 4]
    plot(x,u(x,t))
    text(c*t, pif(t == 0, 1.1, 0.6), sprintf('t = %g', t), persist.font.latex18c{:})
    % snapnow
end

%% Kezdeti sebesség adott: $g(x) = sin(x)$, $f(x) = 0$

g = @sin;
c = 4;

%%%
% Az egyenlet analitikus megoldása
%
% $$u(x,t) = \frac{1}{2c} \int_0^{x+ct} g(s) \,\mathrm{d}s + \frac{1}{2c} \int_0^{x-ct} g(s) \,\mathrm{d}s$$
%
% Ezt a következőképpen számolhatjuk ki *egy adott* $x$, és $t$ pontban:
%
%   integral(g, 0, x+c*t) + ...
%
% Hogyan lehetne egyszerre több $x$ pontban is kiértékelni?
% Legyen $G'(x) = g(x)$ primitív függvény.
% Tudvalevő, hogy az |ode45| meg tud oldani $\dot{x}(t) = F(t,x(t))$,
% azaz $G'(x) = F(x,G(x)) = g(x)$ típusú egyenleteket,
% méghozzá, ezen egyszerű esetben az |ode45| a következőt fogja
% számolni:
%
% $$ I_{[x_0,x]} = \int_{x_0}^x g(s) ~\mathrm{d} s $$
%
% ezért
%
% $$ G(x) = \int_0^{x} g(s) ~\mathrm{d} s = I_{[x_0,x]} - \int_{x_0}^{0} g(s) ~\mathrm{d} s$$
%
% A második tag nem tartalmazza a határozatlan (vektor értékű) $x$-et,
% ezért ez könnyen számolható így: |integral(g, x0, 0)|.

%%%
% <html><h3>Kezdeti sebességfeladat megoldása adott $t$ időpillanatra</h3></html>
%
% Fentiek alapján kiszámítjuk $u(x,t)$-t. A szimulálás tartománya
% legyen $x \in [-30,30]$. Az egyszerűség kedvéért egyelőre csak egy
% adott $t$ érték mellett számolunk.
xspan = linspace(-30,30,1000);
t = 5.4;

%%%
% A bonyolultabb ($x$-től függő) $I_{[x_0 + ct,x+ct]}$ integrál kiszámítása:
[~,Ixpct] = ode45(@(x,G) g(x), xspan + c*t, 0);

%%%
% $I_{[x_0 + ct,0]}$-vel való korrigálás után megkapom:
%
% $$G(x + ct) = \int_0^{x + ct} g(s) \,\mathrm{d}s \text{ -t}$$
Gxpct = Ixpct - integral(g,xspan(1)+c*t,0);

%%%
% A bonyolultabb ($x$-től függő) $I_{[x_0-ct,x-ct]}$ integrál kiszámítása:
[~,Ixmct] = ode45(@(x,G) g(x), xspan - c*t, 0);

%%%
% $I_{[x_0 - ct,0]}$-vel való korrigálás után megkapom:
%
% $$G(x - ct) = \int_0^{x - ct} g(s) \,\mathrm{d}s \text{ -t}$$
Gxmct = Ixmct - integral(g,xspan(1)-c*t,0);

%%%
% Végül $u(x,t) = \frac{1}{2c} \Big(G(x + ct) - G(x - ct)\Big)$
u = (2*c)\( Gxpct - Gxmct );

figure, plot(xspan', [ Gxpct Gxmct u])

%%
% <html><h3>Szimuláció</h3></html>

fig = figure('Position', [ 676 791 556 188 ], 'Color', [1 1 1], 'Visible','off');
tspan = 0:0.1:10;
clear frames
for i = 1:numel(tspan)
    t = tspan(i);
    [~,Ixpct] = ode45(@(x,G) g(x), xspan + c*t, 0);
    [~,Ixmct] = ode45(@(x,G) g(x), xspan - c*t, 0);
    u = (2*c)\( Ixmct - integral(g,xspan(1)-c*t,0) - Ixpct + integral(g,xspan(1)+c*t,0) );
    
    plot(xspan', u)
    ylim([-0.3,0.3])
    drawnow
    
    if t == 0.3
        persist.pub_vid_poster('1D_hullamegyenlet_sin_kezdeti_sebesseggel')
    end
    
    frames(i) = getframe(fig);
end
delete(fig)
persist.pub_vid_write(frames)

%% Kezdeti sebesség adott, de nem deriválható, $f(x) = 0$
% $$g(x) = \left\{\begin{aligned} 0, ~~ \text{ha } x < 0 \\ 1, ~~
% \text{ha } x \ge 0 \end{aligned}\right., ~~~~~ g(x) = 0$$

g = @(x) pif(x < 0, 0, 1);
c = 4;

xspan = linspace(-30,30,1000);
tspan = 0:0.1:5;
clear frames

fig = figure('Position', [ 676 791 556 188 ], 'Color', [1 1 1], 'Visible','on');
for i = 1:numel(tspan)
    t = tspan(i);
    [~,Ixpct] = ode45(@(x,G) g(x), xspan + c*t, 0);
    [~,Ixmct] = ode45(@(x,G) g(x), xspan - c*t, 0);
    u = (2*c)\( Ixmct - integral(g,xspan(1)-c*t,0) - Ixpct + integral(g,xspan(1)+c*t,0) );
    
    plot(xspan', u)
    title(sprintf('t = %g', t), persist.font.latex18{:})
    ylim([-5,1])
    drawnow
    pause(0.1)
    
    if t == 2
        persist.pub_vid_poster('1D_hullamegyenlet_sin_kezdeti_sebesseggel')
    end
    
    if t == 3
        persist.pub_vid_poster('1D_hullamegyenlet_sin_kezdeti_sebesseggel')
    end
    
    frames(i) = getframe(fig);
end
delete(fig)
persist.pub_vid_write(frames)

%%
% End of the script.
pcz_dispFunctionEnd(TMP_IUCoYbqYsqgVhrUzFEKb);
clear TMP_IUCoYbqYsqgVhrUzFEKb