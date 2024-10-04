%Solutions_insert

X_exog = [];
mstar(mstar==0) = [];

if isempty(mstar) 
    
    disp('No solution found. Check T_guess and N_guess are not too small.')
    
elseif ~isempty(mstar) 

    X_sol = X_sol(:,:,mstar);
    X_exog = X_sol(nvar-nx+1:nvar,:,1);
    X_sol_exc = X_sol_exc(:,:,mstar);   

    solutions =  reshape(permute(X_sol_exc,[1,3,2]),[],size(X_sol_exc,2));
    ind_solutions = ind_sol(mstar,:);

    %Solution paths
    x_fin = unique(solutions,'rows','stable');  
    sol_ind = unique(ind_solutions,'rows','stable');

    %No. of solutions
    k = length(x_fin(:,1))/(nvar-nx);

    if k==1
        disp('Unique solution found')
    else
        disp('Multiple solutions found')
    end

    %Final solutions
    ind_fin = sol_ind; 
    x_fin = [x_fin; X_exog];  %Put exogenous last

    
end
