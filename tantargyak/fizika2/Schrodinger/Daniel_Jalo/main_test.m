%**********************************************************************%
%                                                                      %
% Implementation of Shooting Method in the resolution of Schrodinger's %
% equation for different potentials (quantum well, double quantum well,%
% finite super-lattices and the effect of an applied electric field.   %
%                                                                      %
% The algorithm will use Newton-Raphson's iteration to converge the    %
% obtained wavefunctions to allowed energy levels.                     %
%                                                                      %
% Written by Daniel Jaló, University of Aveiro                         %
% e-mail: jalo@ua.pt          date: 28/02/2015                         %
%                      last edited: 09/04/2015                         %
%                                                                      %
%**********************************************************************%
clear all, close all

ht = 1; m = 1; % not real constants, in order to prevent rounding errors

L = 1;      % width of the well
S = 10;      % width of the domain
N = 1000;
x = linspace(-S,S,N)';

h = x(2)-x(1);
%V = zeros(N,1);
cond = (x>L/2 | x<-L/2)
%cond = (x>L/2-2 | x<-L/2-2) & (x>L/2+2 | x<-L/2+2 & x>L/2-4 | x<-L/2-4) & (x>L/2+4 | x<-L/2+4) & (x>L/2-0 | x<-L/2-0) & (x>L/2+0 | x<-L/2+0) ...
%     & (x>L/2-6 | x<-L/2-6) & (x>L/2+6 | x<-L/2+6);
V = (cond)*10;

e = ones(N,1);
H = -ht^2/(2*m)*spdiags([e -2*e e],[-1 0 1],N,N)/h^2 ...
    + spdiags(V,0,N,N);


[Psi,E,flag] = eigs(H,5,'sa')
epson = Psi(:,1);
V_sc = (cond)*(max(epson)) - max(epson);
%V_sc = (x>0.5 | x<-0.5)*max(epson) + ~(x>0.5 | x<-0.5)*max(epson)*min(epson);
plot(x,epson,'r',x,V_sc+0.01,'k:')
ylim([1.1*min(epson) 1.1*max(epson)])
