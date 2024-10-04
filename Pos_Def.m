%Check if M matrix is general positive definite --> P-matrix
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). 
%Any errors are my own. Last updated: 03/10/2024.

%Based on Holden (2023, Lemma 1 Part 2)
eig_vals = eig(M + M'); 
length_M = length(M);
is_pd = nnz(eig_vals>0) == length_M; % flag to check if it is PD, nnz - no. of non-zero elements

if is_pd == 1

    not_P = 0;

elseif min(diag(M)) <=0  || det(M) <= 0 

    not_P = 1;

end