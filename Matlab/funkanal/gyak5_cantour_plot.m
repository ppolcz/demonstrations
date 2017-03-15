%% 
%  
%  file:   gyak5_cantour_plot.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.03.14. Tuesday, 17:01:56
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%%

n = 6;

lims = cell(1,n);
lims{1} = [1;2];

for i = 2:n
    lims{i} = [ lims{i-1} lims{i-1}+2*3^(i-1) ];
end

celldisp(lims)

figure, hold on
Color = [ 0 , 0.447 , 0.741 ];
for i = 1:n-1
    for j = 1:size(lims{i},2)
        plot(lims{i}(:,j)/3^i,[i;i],'-', 'Color', Color, 'LineWidth', 1);
    end
end
for j = 1:size(lims{n},2)
    plot(lims{n}(:,j)/3^n,[0;0],'-', 'Color', Color, 'LineWidth', 1)
end
axis([0,1,-1,n])

grid on 
grid minor

set(gca,'ytick',0:n)
% set(gca,'xtick',linspace(0,1,10))
% set(gca,'xticklabels', {'0/9' '1/9' '2/9' '3/9' '4/9' '5/9' '6/9' '7/9' '8/9' '9/9'})
set(gca,'xtick',linspace(0,1,4))
set(gca,'xticklabels', {'0/3' '1/3' '2/3' '3/3'})

%%
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX