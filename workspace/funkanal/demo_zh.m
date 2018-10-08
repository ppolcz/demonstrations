%% 
%  
%  file:   demo_zh.m
%  author: Polcz Péter <ppolcz@gmail.com> 
% 
%  Created on Mon May 18 16:59:43 CEST 2015
%

%% operator normak

s = tf('s');

H = 1/(s+1);
display(H)

n = norm(H,2)
[n,fpeak] = norm(H,inf)

bode(H), grid on

H = {
    s
    s/(s+1)
    (s^2+1)/s
    (s^2+s+1)/(s^3+s^2+3*s+2)
    };

for ii = 1:numel(H)
    figure(ii+1),
    bode(H{ii})
end


%% Laplace tartomanyban

syms t s
H = 1/(s+1);
h = ilaplace(H)

step = 0.001;
t_num = 0:step:10;
plot(t_num, subs(h,t,t_num))
double(sum(subs(h,t,t_num)) * step)

%% Fourier analysis

N = 1000;
t = linspace(-pi,pi,N);

t1 = -3*pi/4;
s = zeros(size(t));
s(t < t1) = 1;

f = fit(t',s','fourier2')
n = coeffnames(f)
c = coeffvalues(f)
k = (length(c)-2)/2

(1:k)*2
size((c((1:k)*2)'*ones(1,N)))
Cos = sum((c((1:k)*2)'*ones(1,N)) .* cos((1:k)'*t*w), 1);
Sin = sum((c((1:k)*2 + 1)'*ones(1,N)) .* sin((1:k)'*t*w), 1)

w = c(end);
figure, plot(t, [c(1) + Sin + Cos])
figure, plot(f,t,s)

coeffnames(f)
coeffvalues(f)

% plot(t, s)


%%

N = 1000;
t = linspace(-pi,pi,N);

c = [rand(1,7) 1];
k = (length(c)-2)/2;


Cos = sum((c((1:k)*2)'*ones(1,N)) .* cos((1:k)'*t*w), 1);
Sin = sum((c((1:k)*2 + 1)'*ones(1,N)) .* sin((1:k)'*t*w), 1);
w = c(end);
plot(t, c(1) + Sin + Cos)


%% Legendre polynomials - GS orthogonalization - JONAK TUNIK

syms x real
N = 6;

f = x.^(0:N-1)
p = sym(zeros(1,N));

a = -1;
b = 1;

fnorm = @(f) sqrt(int(f^2,x,a,b));
dotpr = @(f,g) int(f*g,x,a,b);

p(1) = f(1) / fnorm(f(1));
for n = 2:N
    p(n) = f(n);
    for k = 1:n-1
        p(n) = p(n) - dotpr(f(n),p(k))*p(k);
    end
    p(n) = p(n) / fnorm(p(n));
end

pretty(p')
vpa(p',4)
for n = 1:N
    for m = 1:n
        pr = dotpr(p(n),p(m));
        % sym([ pr , n , m ])
        if n == m
            assert(pr == 1)
        else
            assert(pr == 0)
        end
    end
end
%%

% create a CFIT class variable

f = fittype('a*x^2+b*exp(n*x)')

c = cfit(f,1,10.3,-1e2)

%get the polynomial expression as a string array

p = fevalexpr(f);

%export the polynomial and its coefficients to an Excel sheet

% xlswrite('example',{p;c.a;c.b;c.n});

%% Fourier sorfejtese az 
%            
%             |   ___
% ____________|___   ______
% ------------+------------
% -pi -pi/2   0    pi/2   pi

t0 = pi/4;
t1 = pi/2;

a0 = 1/8; 
a = @(k) 1./(k*pi) .* (sin(k*pi/2) - sin(k*pi/4));
b = @(k) 1./(k*pi) .* (cos(k*pi/4) - cos(k*pi/2));

n = 1000;
t = linspace(-pi,pi,n);
k = 1:300;
f = a0 + sum(repmat(a(k)', [1 n]) .* cos(k'*t) + repmat(b(k)', [1 n]) .* sin(k'*t),1);

figure, plot(t,f), grid on, axis equal, axis([-pi, pi, -0.5 1.5])
set(gca,'xtick',linspace(-pi,pi,9))
set(gca,'XTickLabel',{'-p','-3p/4','-p/2','-p/4','0','p/4','p/2','3p/4','p'})
% set(gca,'XTickLabel',{'-\pi','-3\pi/4','-\pi/2','-\pi/4','0','\pi/4','\pi/2','3\pi/4','\pi'})

%%

t = linspace(0,pi,1000);
plot(t,sin(2*t)+cos(2*t)), grid on
set(gca,'xtick',linspace(0,pi,5))
set(gca,'XTickLabel',{'0','p/4','p/2','3p/4','p'})


%% Rational polynomials

num = [1 1 0 1];
den = [1 0 1];

n = 1000;
B = 10;
t = linspace(-B,B,n);
f = polyval(num,t) ./ polyval(den,t);

syms x
r = poly2sym(num,x)/poly2sym(den,x);
dr = diff(r,x);
dr_num = double(subs(dr,x,t));

plot(t,[f;dr_num])

%% Polynomial sigmoid: http://www.flong.com/texts/code/shapers_poly/
%  t: from previous

t1 = t/10*1.9;
y1 =  4/9*t1.^6 - 17/9*t1.^4 + 22/9*t1.^2;
plot(t,y1)