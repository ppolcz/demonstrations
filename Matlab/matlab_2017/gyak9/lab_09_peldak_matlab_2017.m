%% Tablazat

% Igy kell letrehozni egy tablazatot
% t = table(v1,v2,v3,'VariableNames',{'o1','o2','o3'})

ft = readtable('foldrajzi.xls','ReadVariableNames',true);
summary(ft)
%writetable(ft,'foldrajzi.xlsx','WriteVariableNames',true)
writetable(ft,'foldrajzi.csv','WriteVariableNames',true, 'FileType','text','Delimiter',';')

%% Abrak mentese kepkent
f1=figure;
surf(peaks)
title('Peaks felulet','FontSize',22)
xlabel('x','FontSize',20)
ylabel('y','FontSize',20)
zlabel('z','FontSize',20)
colorbar
set(gca,'FontSize',20)
print(f1,'-dpng','-zbuffer','-r300','surf1.png')


%% array2table

M = rand(5)
array2table(M)

%% cell2table

M = rand(5);
M = num2cell(M);
cell2table(M)

%% struct2table

s(1).a = 1;
s(1).b = 2;
s(2).a = 3;
s(2).b = 4;

t = struct2table(s)

%%

height(t)
width(t)

partial_ft = ft(3:4,:);
partial_ft{1,1} = {'HU'};
ismember(partial_ft,ft)