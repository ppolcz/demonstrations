%% statisztika
%  
%  File: statisztika.m
%  Directory: 2_demonstrations/workspace/statistics
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2019. March 18.
%

%% Normal eloszlas

x = linspace(-3,3,1000);

f = normpdf(x);
F = normcdf(x);

figure, hold on, grid on
plot(x,[f ; F])


%% Student T eloszlas

x = linspace(-3,3,1000);

t = tpdf(x,10);
T = tcdf(x,10);

figure, hold on, grid on
plot(x,[t ; T])


%% Chi negyzet eloszlas

x = linspace(0,20,1000);

DF = 8;

chi2 = chi2pdf(x,DF);
Chi2 = chi2cdf(x,DF);

figure, hold on, grid on
plot(x,[chi2 ; Chi2])

%% 
% 
% fpdf
% cpdf