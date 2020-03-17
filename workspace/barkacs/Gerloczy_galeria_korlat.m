%% Gerloczy_galeria_korlat
%  
%  File: Gerloczy_galeria_korlat.m
%  Directory: 2_demonstrations/workspace/barkacs
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2019. December 25. (2019b)
%

%% Korlat let szelso fuggoleges oldal: fal, galleria, belso nezet
 
% Minden cm-ben van megadva

global m w sz koz m1

% Lecek elmeleti hossza, szelessege:
m = 90;                % 2 szelso
w = 4.8;               % vastagsag
sz = 154.8;            % 2 hosszanti lec
koz = (sz - w) / 2;    % 8 hosszanti kis lec
m1 = m - w;            % kozepso fuggoleges

% Deszka elmeleti hossza, szelessege, vastagsaga:
dsz = 15;    % szelessege
dv = 2.5;    % vastagsaga

% Vagdosnivalo deszka hossza
dh = 65;

% Sarokvas kedvezo lyuka milyen tavol van a saroktol
sarokvas_lyuk_pos = 3.2;

% Milyen kozonkent legyenek a tiplik a 8 hosszanti lec vegein
tiplik_hosszanti = [ 1.6 3.2 w ];

% Osszehuzo anya 9mm-es atmeroju reszenek hossza
h_anya = 1.2;

% Tipli hossza
h_tipli = 3; 

% Metrikus csavarok fejenek melysege
h_csfej = 0.3;

% Illesztocsavarok hossza
h_ill = 10;

% Illesztocsavarok hossza a 8 hosszanti kis lecek vegein
h_illj = h_ill - w;

% Tonkanya elmeleti meretei
h_tonk = 2;   % hossz (melyseg)
w_tonk = 1;   % szelesseg

% Legalabb mennyire logjon tul a metrikus csavar a tonkanyaban
tonk_xoffset = 0.7;

% Sarokvascsavarok helye letrol
sarokvascsavar = [ 25 83 ];

% Fa/femmenetes csavarok (elmeleti) helye - ez valtozhat
fafemmenetes = [ 3.7 43.7 75.7 ];

% Keresztlecek felso pozicioja
osztas = 5;
l_h = linspace(0,m,osztas+1);
szakasz_ = m / osztas;
szakasz = szakasz_ - round(w);



krszt = @(h) plot([0 w w 0 0],[h h h-w h-w h],'-','Color',[1 1 1]*0.5,'LineWidth',2);
krsztb = @(h) plot(2*[0 w w 0]-2*w,[h h h-w h-w],'-','Color',[1 1 1]*0.5,'LineWidth',2);

ly6 = @(h) draw_circle(w/2,h,0.3,{'Color',pcz_get_plot_colors([],4)});
ly10 = @(h) draw_circle(w/2,h,0.5,{'Color',pcz_get_plot_colors([],1)});
ly15 = @(h) draw_circle(w/2,h,0.75,{'Color',pcz_get_plot_colors([],2)});

ly6x = @(h,x) draw_circle(x,h,0.3,{'Color',pcz_get_plot_colors([],4)});
ly10x = @(h,x) draw_circle(x,h,0.5,{'Color',pcz_get_plot_colors([],1)});

kly6 = @(h) plot([0 w w 0],[h-0.3 h-0.3 h+0.3 h+0.3],'-','Color',pcz_get_plot_colors([],4));
kly6b = @(h) plot([0 1 1 0]*h_tipli/2,[h-0.3 h-0.3 h+0.3 h+0.3],'-','Color',pcz_get_plot_colors([],4));
kly6jb = @(h) plot([-1 1 1 -1 -1]*h_tipli/2,[h-0.3 h-0.3 h+0.3 h+0.3 h-0.3],'-','Color',pcz_get_plot_colors([],4));
kly6j = @(h) plot(w-[0 1 1 0]*h_tipli/2,[h-0.3 h-0.3 h+0.3 h+0.3],'-','Color',pcz_get_plot_colors([],4));

kly6jill = @(h) plot(-[0 1 1 0]*h_illj,[h-0.3 h-0.3 h+0.3 h+0.3],'-','Color',pcz_get_plot_colors([],4));

kly10b = @(h) plot([0 h_anya h_anya 0],[h-0.5 h-0.5 h+0.5 h+0.5],'-','Color',pcz_get_plot_colors([],1));
kly10j = @(h) plot(w-[0 h_anya h_anya 0],[h-0.5 h-0.5 h+0.5 h+0.5],'-','Color',pcz_get_plot_colors([],1));

kly15b = @(h) plot([0 h_csfej h_csfej 0],[h-0.75 h-0.75 h+0.75 h+0.75],'-','Color',pcz_get_plot_colors([],1));
kly15j = @(h) plot(w-[0 h_csfej h_csfej 0],[h-0.75 h-0.75 h+0.75 h+0.75],'-','Color',pcz_get_plot_colors([],1));

label = @(h,msg) text(0,h,[ msg ' $\rightarrow$ ' ],'HorizontalAlignment','right','Interpreter','latex');
labelx = @(h,msg,x) text(x,h,[ msg ' $\rightarrow$ ' ],'HorizontalAlignment','right','Interpreter','latex');

tonk_bal = @(h) plot(...
    [
        -h_illj+tonk_xoffset -h_illj+tonk_xoffset ...
        -h_illj+tonk_xoffset+w_tonk -h_illj+tonk_xoffset+w_tonk ...
        -h_illj+tonk_xoffset -h_illj+tonk_xoffset ...
        -h_illj+tonk_xoffset+w_tonk
    ],[
        h-(w-tiplik_hosszanti(2)) h+h_tonk/2 h+h_tonk/2 h-(w-tiplik_hosszanti(2)) ...
        h-(w-tiplik_hosszanti(2)) h-h_tonk/2 h-h_tonk/2 
    ],'-','Color',pcz_get_plot_colors([],2));



fig2 = figure(2);

% ----------------------------------------------------------------------- %
ax1 = kulso_fg_deszka(142,'fal',m,w);
ax1.YTick = sort([ 0:10:90 l_h([2,osztas+1])-tiplik_hosszanti(2) ]);

ly15(m-tiplik_hosszanti(2))
ly6(m-tiplik_hosszanti(2))

label(m-tiplik_hosszanti(2),'illesztocsavar')

ly15(l_h(2)-tiplik_hosszanti(2))
ly6(l_h(2)-tiplik_hosszanti(2))

label(l_h(2)-tiplik_hosszanti(2),'illesztocsavar')

for h = fafemmenetes
    ly6(h);
    ax1.YTick = unique(sort([ ax1.YTick h ]));
    label(h,'fafemmenetes')
end

for h = sarokvascsavar
    kly10b(h)
    kly6(h)
    ax1.YTick = sort([ ax1.YTick h ]);
    label(h,'sarokvascsavar')
end

% ----------------------------------------------------------------------- %
ax2 = kulso_fg_deszka(143,'kulso',m,w);
ax2.YTick( ax2.YTick == 70 | ax2.YTick == 50 ) = [];

for h = sarokvascsavar
    ly10x(h,w-sarokvas_lyuk_pos)
    ly6x(h,w-sarokvas_lyuk_pos)
    ax2.YTick = sort([ ax2.YTick h ]);
    label(h,'sarokvascsavar')
end
ax2.XTick = [ 0 w-sarokvas_lyuk_pos w ];

for h = fafemmenetes
    kly6(h)
    kly10b(h)
    ax2.YTick = unique(sort([ ax2.YTick h ]));
    label(h,'fafemmenetes')
end

for h = l_h(2:end)
    krsztb(h);
    kly6jb(h-tiplik_hosszanti(1));
    
    if h == l_h(2) || h == l_h(osztas+1)
        kly6jill(h-tiplik_hosszanti(2));
        kly15j(h-tiplik_hosszanti(2));
        kly6(h-tiplik_hosszanti(2));
        tonk_bal(h-tiplik_hosszanti(2));
        
        ax2.YTick = unique(sort([ ax2.YTick h-tiplik_hosszanti(2) ]));
        ax2.YTick = unique(sort([ ax2.YTick h-tiplik_hosszanti(2)+w_tonk ]));
        ax2.YTick = unique(sort([ ax2.YTick h-tiplik_hosszanti(2)-w_tonk ]));
    else
        kly6jb(h-tiplik_hosszanti(2));
        ax2.YTick = unique(sort([ ax2.YTick h h-tiplik_hosszanti(1) h-tiplik_hosszanti(2) ]));
    end
    
end

ax2.XTick = unique(sort([ ax2.XTick -h_illj -h_illj+tonk_xoffset+w_tonk/2 ]));

h = l_h(2);
dl = imdistline;
dl.setPosition([-10 h-w ; -10 h-w+tiplik_hosszanti(1)+h_tonk/2]);


% ----------------------------------------------------------------------- %
ax3 = kulso_fg_deszka(144,'belso',m,w);
ax3.YTick( ax3.YTick == 70 | ax3.YTick == 50 ) = [];

for h = l_h(2:end)
    krszt(h);
    ly6(h-tiplik_hosszanti(1));
    ly6(h-tiplik_hosszanti(2));
    
    label(h-tiplik_hosszanti(1),'tipli')
    if (h ~= l_h(2)) && (h ~= l_h(end))
        label(h-tiplik_hosszanti(2),'tipli')
    else
        label(h-tiplik_hosszanti(2),'illesztocsavar')
    end

    ax3.YTick = unique(sort([ ax3.YTick h h-tiplik_hosszanti(1) h-tiplik_hosszanti(2) h-tiplik_hosszanti(3) ]));
end

for h = fafemmenetes
    ly10(h)
    ly6(h)
    ax3.YTick = unique(sort([ ax3.YTick h ]));
    label(h,'fafemmenetes')
end

for h = sarokvascsavar
    kly6(h)
    kly10j(h)
    ax3.YTick = unique(sort([ ax3.YTick h ]));
    label(h,'sarokvascsavar')
end

dl2 = imdistline;
dl2.setPosition([-10 l_h(end-1)-w ; -10 l_h(end-2)]);

labelx(l_h(end-1),num2str(w),-12)
labelx(l_h(end-1)-tiplik_hosszanti(1),num2str(w-tiplik_hosszanti(1)),-12)
labelx(l_h(end-1)-tiplik_hosszanti(2),num2str(w-tiplik_hosszanti(2)),-12)
labelx(l_h(end-1)-tiplik_hosszanti(3),num2str(w-tiplik_hosszanti(3)),-12)


% ----------------------------------------------------------------------- %
ax4 = kulso_fg_deszka(141,'konzol',m,dsz);
ax4.YTick = [];
ax4.XLim = [-15 dsz];

h_haromszogek = [0:dv:2*dv 40:dv:47 72:dv:78 m-dv];
for h = h_haromszogek
    draw_rect(0,h,dsz,h+dv,{'Color',[1 1 1]/2});
    ax4.YTick = unique(sort([ ax4.YTick h h+dv ]));
end

for h = fafemmenetes
    ly6x(h,6)
    label(h,'fafemmenetes')
end

alpha = deg2rad(15);

befogo = 15;
atfogo = befogo/cos(alpha/2);
alap = 2*befogo*tan(alpha/2);
felalap = round(alap/2,1);

yy = 10 + [ 0 0:11 11 ] * felalap;
xx = [ repmat([ 0 dsz ],[1 numel(yy)/2])];
plot(xx,yy);

for y = yy
    label(y,sprintf('Ekek: %d',y-10))
end
% ax4.YTick = unique(sort([ ax4.YTick yy ]));


%% Konzol vizszintes metszet

figure(6), hold off, plot(0,0), hold on

tessauer_sz = 0.8;
tessauer = 1.3; % 1.6, 1.7, 2.5
butorcsav = [ 70 70 60 40 ] / 10;

butorcsav_rogz = 80 / 10;

kormos = 0.9;

illesztesek = round(2*[ 0.93 0.87 0.7 0.1 ]*dsz)/2;

% Ahol a korlat illeszkedik
korlillesztes = 3 + w/2;

C = cos(alpha);
S = sin(alpha);

% Falra rogzitett oldal
plot([0 -dsz -dsz 0 0], [0 0 dv dv 0])

% Amire a korlat lesz rogzitve
plot([0 -dsz*C -dsz*C+dv*S dv*S 0],...
    [0 -dsz*S -dsz*S-dv*C -dv*C 0])

for i = 1:numel(illesztesek)
    
    a = illesztesek(i);
    da = tessauer_sz / 2;
    
    b = a * C;
    
    M = 6 / 10;
        
    % Tessauer anya helye
    plot([
        -da*C 
        -da*C-tessauer*S
        +da*C-tessauer*S
        +da*C 
        ]-a,...
        [
        -da*S 
        -da*S+tessauer*C
        da*S+tessauer*C
        da*S 
        ], 'Color', pcz_get_plot_colors([],7), 'LineWidth',2)
    
    h = butorcsav(i);
    
    % Csavar torzse
    plot([
        -M/2*C
        -M/2*C-h*S
        M/2*C-h*S
        M/2*C
        ]-b*C+dv*S,...
        [
        -M/2*S
        -M/2*S+h*C
        M/2*S+h*C
        M/2*S
        ]-b*S-dv*C, 'Color', pcz_get_plot_colors([],1), 'LineWidth',1)
end

plot([
    -w/2*C
    -w/2*C+w*S
    w/2*C+w*S
    w/2*C
    -w/2*C
    ]-korlillesztes*C+dv*S,...
    [
    -w/2*S
    -w/2*S-w*C
    w/2*S-w*C
    w/2*S
    -w/2*S
    ]-korlillesztes*S-dv*C, 'Color', pcz_get_plot_colors([],2), 'LineWidth',1)

h = butorcsav_rogz;
plot([
    -M/2*C
    -M/2*C-h*S
    M/2*C-h*S
    M/2*C
    ]-korlillesztes*C+dv*S+w*S,...
    [
    -M/2*S
    -M/2*S+h*C
    M/2*S+h*C
    M/2*S
    ]-korlillesztes*S-dv*C-w*C, 'Color', pcz_get_plot_colors([],1), 'LineWidth',1)

% Kormos anya helye
plot([
    -da*C 
    -da*C+kormos*S
    ]-korlillesztes*C,...
    [
    -da*S 
    -da*S-kormos*C
    ]-korlillesztes*S,...
    'Color', pcz_get_plot_colors([],5), 'LineWidth',2)
plot([
    +da*C+kormos*S
    +da*C 
    ]-korlillesztes*C,...
    [
    da*S-kormos*C
    da*S 
    ]-korlillesztes*S,...
    'Color', pcz_get_plot_colors([],5), 'LineWidth',2)
plot([
    -da*C 
    -da*C-tessauer*S
    +da*C-tessauer*S
    +da*C 
    ]-korlillesztes*C,...
    [
    -da*S 
    -da*S+tessauer*C
    da*S+tessauer*C
    da*S 
    ]-korlillesztes*S, 'Color', pcz_get_plot_colors([],7), 'LineWidth',2)


axis equal

%% KORLAT LATKEP

figure(3), hold off, plot(0,0), hold on
title('Korlat maga, latvanyterv')
args = {'LineWidth', 2, 'Color', [0 0 0]};
draw_rect(0,0,w,m,args)
draw_rect(w+sz,0,2*w+sz,m,args)
draw_rect(w+koz,0,2*w+koz,m-w,args)

draw_rect(w,m-w,w+sz,m,args)
draw_rect(w,l_h(2)-w,w+sz,l_h(2),args)

for h = l_h(3:end-1)
    draw_rect(w,h-w,w+koz,h,args)
    draw_rect(2*w+koz,h-w,2*w+2*koz,h,args)
end

axis tight, axis equal

% m w sz koz m1

%% SORREND

tiplik = sort([ l_h(2:end)-tiplik_hosszanti(1) l_h(3:end-1)-tiplik_hosszanti(2) ]);
tiplik_str = strjoin(cellfun(@(n) {sprintf('%g',n)}, num2cell(tiplik)),', ');

illesztocsavar = l_h([2 end])-tiplik_hosszanti(2);
illesztocsavar_str = strjoin(cellfun(@(n) {sprintf('%g',n)}, num2cell(illesztocsavar)),', ');

fafemmenetes_str = strjoin(cellfun(@(n) {sprintf('%g',n)}, num2cell(fafemmenetes)),', ');

sarokvascsavar_str = strjoin(cellfun(@(n) {sprintf('%g',n)}, num2cell(sarokvascsavar)),', ');

c = {
    { '\n-------------\nSORREND: \n' }
    { 'BELSO oldalon tiplik, %s [cm] magassagban (%gx%g [mm])' tiplik_str 6 h_tipli*5} 
    { 'BELSO oldalon fafemmenetes, %s [cm] magassagban (%gx%g [mm])' fafemmenetes_str 9 h_anya*10}
    { 'BELSO oldalon fafemmenetes, %s [cm] magassagban (%g [mm]) atfurni' fafemmenetes_str 6}
    { '' }
    { 'FAL oldalon illesztocsavar, %s [cm] magassagban (%gx%g [mm])' illesztocsavar_str 15 h_csfej*10 }
    { 'FAL oldalon illesztocsavar, %s [cm] magassagban (%g [mm]) atfurni' illesztocsavar_str 6 }
    { '' }
    { 'KULSO oldalon sarokvascsavar, %s [cm] magassagban (%gx%g [mm])' sarokvascsavar_str 9 h_anya*10 }
    { 'KULSO oldalon sarokvascsavar, %s [cm] magassagban (%g [mm]) atfurni' sarokvascsavar_str 6 }
    };

for i = 1:numel(c)
    msg = c{i};
    fprintf(msg{:})
    disp(' ')
end

%%


function ax = kulso_fg_deszka(splot,cim,m,w)

    p = PersistStandalone;
    
    ax = subplot(splot);
    hold off
    draw_rect(0,0,w,m,{'LineWidth', 2, 'Color', [0 0 0]})
    hold on, axis equal, grid on
    set(ax,'xlim', [-4*w,1.5*w], 'ylim', [0 m], 'color', 'none', 'YAxisLocation', 'right', 'XAxisLocation', 'bottom')
    title(ax,cim)
    % ax.YMinorGrid = 'on';
    ax.XTick = [0 w/2 w];
    ax.XTickLabelRotation = 90;
    
    p.latexify_axis(8)
end