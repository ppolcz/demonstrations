function [szurt_tabla, racs_X, racs_Y, magassag_atlag, abra] = zh2_f11_sol()
adatok=readtable('UAVflight1.csv','ReadVariableNames',true);
joindexek = adatok.Lat >=47 & adatok.Lat <=48 & adatok.Lng >=19 & adatok.Lng<=20 & adatok.Alt>=140 & adatok.Alt<=200;
szurt_tabla = adatok(joindexek,:);
[X,Y] =  meshgrid(linspace(min(szurt_tabla.Lat), max(szurt_tabla.Lat), 200),linspace(min(szurt_tabla.Lng), max(szurt_tabla.Lng), 200));
racs_X = X;
racs_Y = Y;
magassag_atlag = mean(szurt_tabla.Alt);
domborzat=readtable('domborzat.csv');
Z=table2array(domborzat);
abra = figure;
%Abraval kapcsolatos parancsok ez utan kovetkezzenek
surf(X,Y,Z);
hold on
pirosak = szurt_tabla.Alt>=magassag_atlag;
kekek = szurt_tabla.Alt<magassag_atlag;
plot3(szurt_tabla.Lat(pirosak),szurt_tabla.Lng(pirosak),szurt_tabla.Alt(pirosak),'.r');
plot3(szurt_tabla.Lat(kekek),szurt_tabla.Lng(kekek),szurt_tabla.Alt(kekek),'.b');
title('repültem')
xlabel('Lat')
ylabel('Lon')
zlabel('Alt')
xlim([min(szurt_tabla.Lat), max(szurt_tabla.Lat)])
ylim([min(szurt_tabla.Lng), max(szurt_tabla.Lng)])
zlim([min(min(Z)), max(szurt_tabla.Alt)])
print('uav','-dpng','-r300')
end