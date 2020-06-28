%% LFR_tricks
%  
%  File: LFR_tricks.m
%  Directory: 2_demonstrations/egyeb/Matlab_tricks
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2020. April 18. (2019b)
%

G_reset(1)

%%

nu = 3;
ny = 2;
r = [1 2 3];
m1 = 6;

p = sym('p',[numel(r),1]);
p_lim = repmat([-1,1],size(p));

F = magic(max(nu,ny)+m1);
[F11,F12,F21,F22] = pcz_split_matrix(F,[ny,m1],[nu,m1],'RowWise',1);

Delta_cell = cellfun(@(r,p) {eye(r) * p}, num2cell(r(:)), num2cell(p(:)));
Delta = blkdiag(Delta_cell{:});

A = plfr([F11,F12;F21,F22],Delta,p_lim);


Delta_plfr = plfr(zeros(m1),eye(m1),eye(m1),zeros(m1),Delta,p_lim);


% TEST 1
I_DeltaF22_check = eye(m1) - Delta_plfr*F22;
I_DeltaF22_test = plfr(eye(m1),-eye(m1),F22,zeros(m1),Delta,p_lim);
pcz_lfrzero_report(I_DeltaF22_test - I_DeltaF22_check,'Test 1: I - Delta F22')

% TEST 2
inv_I_DeltaF22_check = eye(m1)/(eye(m1) - Delta_plfr*F22);
inv_I_DeltaF22_test = plfr(eye(m1),eye(m1),F22,F22,Delta,p_lim);
pcz_lfrzero_report(inv_I_DeltaF22_test - inv_I_DeltaF22_check,'Test 2: inv(I - Delta F22)')

% TEST 3
I_F22Delta_check = eye(m1) - F22*Delta_plfr;
I_F22Delta_test = plfr(eye(m1),-F22,eye(m1),zeros(m1),Delta,p_lim);
pcz_lfrzero_report(I_F22Delta_test - I_F22Delta_check,'Test 3: I - F22 Delta')

% TEST 4
inv_I_F22Delta_check = eye(m1)/(eye(m1) - F22*Delta_plfr);
inv_I_F22Delta_test = plfr(eye(m1),F22,eye(m1),F22,Delta,p_lim);
pcz_lfrzero_report(inv_I_F22Delta_test - inv_I_F22Delta_check,'Test 4: inv(I - F22 Delta)')

% TEST 5
pi = p(2);
Hi = double(diff(Delta,pi));
diA_check = plfr(diff(A.lfrtbx_obj,char(pi)));
diA_test = plfr(...
    F12*Hi*F21,...
    [ F12 , F12*Hi*F22 ],...
    [ F22*Hi*F21 ; F21 ],...
    [ F22 , F22*Hi*F22 ; zeros(m1) , F22 ],...
    blkdiag(Delta,Delta),p_lim);
pcz_lfrzero_report(diA_test - diA_check,'Test 5: diff(A,pi)')

%% Monomials
% 2020.06.25. (június 25, csütörtök), 14:52

pcz_generateSymStateVector(3,'p')
r = [ 3 4 2 ];

Deltai = cellfun(@(i) { p(i) * eye(r(i)) }, num2cell(1:p_n)); 
Delta = blkdiag(Deltai{:});

m = sum(r);
[B,D,A,C] = pcz_split_matrix(eye(m+1), [1 m], [m 1], 'RowWise', false);

display(Delta*D,'Delta*D')
display(eye(m) - Delta*D, 'I - Delta*D')
display(inv(eye(m) - Delta*D), 'inv(I - Delta*D)')
display(Delta*C, 'Delta*C')
display((eye(m) - Delta*D) \ Delta*C, 'inv(I - Delta*D) * Delta*C')
display(B / (eye(m) - Delta*D) * Delta*C, 'B * inv(I - Delta*D) * Delta*C')
