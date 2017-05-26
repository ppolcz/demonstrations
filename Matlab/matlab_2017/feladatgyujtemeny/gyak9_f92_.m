function gyak9_f92_()
%%

t = readtable('country_data.xls','ReadVariableNames',1);

sortrows(t,'Number_of_spoken_languages');
t_sorted = sortrows(t,7);


first_10 = t_sorted(end-9:end,:);
size(first_10)

summary(first_10)

writetable('country_data_reordered.csv', 'type','text','delimiter','|')

%% 


N = 10;

A = rand(N,2);
B = rand(N,3);
C = rand(N,1);

t = table(A,B,C,'VariableNames', {'A_Kutya' 'B' 'C'})
summary(t)


end