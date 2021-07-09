%%
%  File: LMI_tricks_Covariance_missing.m
%  Directory: 2_demonstrations/egyeb/Matlab_tricks
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2021. July 09. (2021a)
%

fn = pcz_mfilename;
cd(fn.dir)

save('GP_Exact_MM_hiba_pelda_1','S','Var_GP','Cov_xGP')

[nx,nd] = size(Cov_xGP);

Cross_Cov_GP = sdpvar(nd); 

Cross_Cov_GP = Cross_Cov_GP - diag(diag(Cross_Cov_GP));

sym(Cross_Cov_GP);

Sigma = [ 
    S         Cov_xGP
    Cov_xGP.' diag(Var_GP)
    ];

Sigma_corrected = [ 
    S         Cov_xGP
    Cov_xGP.' diag(Var_GP) + Cross_Cov_GP
    ];

CONS = Sigma_corrected >= 0;

optimize(CONS)
check(CONS)

Sigma_corrected = double(Sigma_corrected);

display(Sigma,'Variance matrix with assumed uncorrelated GP distributions')
display(eig(Sigma)','Eigenvalues')

display(Sigma_corrected,'Variance matrix with estimated cross covariance values')
display(eig(Sigma_corrected)','Eigenvalues')

