%% 
%  
%  file:   multidimensional_dot_product.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.11.17. Thursday, 13:05:49
%
%%

A(:,:,1) = [
    1 2 3
    4 5 6
    ];

A(:,:,2) = [
    1 2 3
    4 5 6
    ];

B = [
    1
    2
    ];

dot(A,A,3)

tic
dot(A,repmat(permute(B,[2 3 1]),[size(A,1),size(A,2),1]),3)
toc

tic
AA = permute(A,[1 3 2]);
for i = 1:size(AA,3)
    AA(:,:,i)*B
end
toc

%%

n = 100;
m = 110;
l = 120;

A = rand(n,m,l);
B = rand(l,1);

tic
D1 = dot(A,repmat(permute(B,[2 3 1]),[size(A,1),size(A,2),1]),3);
toc

tic
AA = permute(A,[1 3 2]);
for i = 1:size(AA,3)
    D2i = AA(:,:,i)*B;
end
toc