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
tiplikoz = w/3;

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
        h-tiplikoz h+h_tonk/2 h+h_tonk/2 h-tiplikoz ...
        h-tiplikoz h-h_tonk/2 h-h_tonk/2 
    ],'-','Color',pcz_get_plot_colors([],2));



fig2 = figure(2);

% ----------------------------------------------------------------------- %
ax1 = kulso_fg_deszka(142,'fal',m,w);
ax1.YTick = sort([ 0:10:90 l_h([2,osztas+1])-2*tiplikoz ]);

ly15(m-2*tiplikoz)
ly6(m-2*tiplikoz)

label(m-2*tiplikoz,'illesztocsavar')

ly15(l_h(2)-2*tiplikoz)
ly6(l_h(2)-2*tiplikoz)

label(l_h(2)-2*tiplikoz,'illesztocsavar')

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
    kly6jb(h-tiplikoz);
    
    if h == l_h(2) || h == l_h(osztas+1)
        kly6jill(h-2*tiplikoz);
        kly15j(h-2*tiplikoz);
        kly6(h-2*tiplikoz);
        tonk_bal(h-2*tiplikoz);
        
        ax2.YTick = unique(sort([ ax2.YTick h-2*tiplikoz ]));
        ax2.YTick = unique(sort([ ax2.YTick h-2*tiplikoz+w_tonk ]));
        ax2.YTick = unique(sort([ ax2.YTick h-2*tiplikoz-w_tonk ]));
    else
        kly6jb(h-2*tiplikoz);
        ax2.YTick = unique(sort([ ax2.YTick h h-tiplikoz h-2*tiplikoz ]));
    end
    
end

ax2.XTick = unique(sort([ ax2.XTick -h_illj -h_illj+tonk_xoffset+w_tonk/2 ]));

h = l_h(2);
dl = imdistline;
dl.setPosition([-10 h-w ; -10 h-w+tiplikoz+h_tonk/2]);


% ----------------------------------------------------------------------- %
ax3 = kulso_fg_deszka(144,'belso',m,w);
ax3.YTick( ax3.YTick == 70 | ax3.YTick == 50 ) = [];

for h = l_h(2:end)
    krszt(h);
    ly6(h-tiplikoz);
    ly6(h-2*tiplikoz);
    
    label(h-tiplikoz,'tipli')
    if (h ~= l_h(2)) && (h ~= l_h(end))
        label(h-2*tiplikoz,'tipli')
    else
        label(h-2*tiplikoz,'illesztocsavar')
    end

    ax3.YTick = unique(sort([ ax3.YTick h h-tiplikoz h-2*tiplikoz h-3*tiplikoz ]));
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
labelx(l_h(end-1)-tiplikoz,num2str(w-tiplikoz),-12)
labelx(l_h(end-1)-2*tiplikoz,num2str(w-2*tiplikoz),-12)
labelx(l_h(end-1)-3*tiplikoz,num2str(w-3*tiplikoz),-12)


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
felalap = round(befogo*tan(alpha/2),1);

yy = 10 + [ 0 0:11 11 ] * felalap;
xx = [ repmat([ 0 dsz ],[1 numel(yy)/2])];
plot(xx,yy);

for y = yy
    label(y,sprintf('Ekek: %d',y-10))
end
% ax4.YTick = unique(sort([ ax4.YTick yy ]));


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

tiplik = sort([ l_h(2:end)-tiplikoz l_h(3:end-1)-2*tiplikoz ]);
tiplik_str = strjoin(cellfun(@(n) {sprintf('%g',n)}, num2cell(tiplik)),', ');

illesztocsavar = l_h([2 end])-2*tiplikoz;
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