%% Teljes függvényvizsgálat

syms x real

f = exp(x)/(x-1)
df = simplify(diff(f))
ddf = simplify(diff(df))
fplot(f,[-2,5]), grid on