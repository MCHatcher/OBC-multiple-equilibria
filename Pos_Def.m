%Check if M matrix is general positive definite --> P-matrix
%Check if simple necessary conditions for a P-matrix are violated
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). 
%Any errors are my own. Last updated: 12/04/2023.

%Based on Holden (2022, Lemma 1 Part 2)
eig_vals = eig(M + M'); 
length_M = length(M);
is_pd = nnz(eig_vals>0) == length_M; % flag to check if it is PD 

if is_pd == 0

    if det(M) <= 0 || min(diag(M)) <=0 
        not_P = 1;

    else  

n_skip = max(round(length_M/10),1);
max_iter = max(length(M)-1,1);

for iter = 1:n_skip:max_iter

det_M = det(M(1:iter,1:iter));

        if det_M <= 0
            not_P = 1;
            break
        end

end

    end

end

