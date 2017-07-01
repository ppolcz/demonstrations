%%

t = readtable('UAVflight1.csv','ReadVariableNames',true)
summary(t)

t(t.Lat < 47 | 48 < t.Lat,:) = []
t(t.Lng < 19 | 20 < t.Lng,:) = []
t(t.Alt < 140 | t.Alt > 200,:) = []

%t.Alt(t.Alt < 145) = 145;

[racs_X, racs_Y] = meshgrid( ...
    linspace(min(t.Lat),max(t.Lat),200), ...
    linspace(min(t.Lng),max(t.Lng),200) );

d = readtable('domborzat.csv','ReadVariableNames',true);


fig = figure; hold on
surf(racs_X,racs_Y,d{:,:})

ma = mean(t.Alt)

roppx = t.Lat;
roppy = t.Lng;
roppz = t.Alt;

plot3(roppx(ma < roppz),roppy(ma < roppz),roppz(ma < roppz),'.r')
plot3(roppx(ma >= roppz),roppy(ma >= roppz),roppz(ma >= roppz),'.b')
view([20,30])



print('uav-r1800.png','-dpng','-r1800')
