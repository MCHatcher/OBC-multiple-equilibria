%Solutions_insert_App_2_loop

mstar(mstar==0) = [];

if isempty(mstar) 
    
        disp('No solution found. Check T_guess and N_guess are not too small.')
        count_no_sol(j) = 1;
        count_unique(j) = 0;
    
elseif ~isempty(mstar) 

        X_sol = X_sol(:,:,mstar);
        X_exog = X_sol(nvar-nx+1:nvar,:,1);  %Order exog last in x vector
        X_sol_exc = X_sol_exc(:,:,mstar); 
        X_star_sol = X_star_sol(mstar,:); 

    %Note: The below is an ad-hoc workaround. Because in the model i(t) = i*(t) in the reference regime (slack), 
    %some of these paths will removed by the 'unique' function. To prevent this we add small positive number to 
    %final simulated point of variable 1 (i.e. i(t)).   
    for ii=1:length(X_sol(1,1,:))
        rng(1), noise = abs(randn)*1e-18;
        orig = X_sol(1,T_sim-1,ii); orig_exc = X_sol_exc(1,T_sim-1,ii); 
        X_sol(1,T_sim-1,ii) = orig + noise/4;
        X_sol_exc(1,T_sim-1,ii) = orig_exc + noise/4;
    end 

    solutions =  reshape(permute(X_sol_exc,[1,3,2]),[],size(X_sol_exc,2));
    ind_solutions = ind_sol(mstar,:);

    %Solution paths
    x_fin = unique(solutions,'rows','stable');  
    sol_ind = unique(ind_solutions,'rows','stable');

    count_no_sol(j) = 0;

    %No. of solutions
    k = length(x_fin(:,1))/(nvar-nx);

    %Solutions for sim j
    X_star_fin = unique(X_star_sol,'rows','stable');
    ind_fin = sol_ind; 
    x_fin = [x_fin; X_exog];  %Put exogenous last

     if k==1
        %disp('Unique solution found')
        count_multi(j) = 0; count_unique(j) = 1;
        count(j) = sum(ind_fin(1,:)==0);
     
     elseif k>=2
        %disp('Warning: Multiple solutions or no solution')
        count_multi(j) = 1; 
            if k==2
                count(j) = sum(ind_fin(2,:)==0);  %Count periods at bound
            else
                disp('Warning: More than two solutions')
            end
     
     end

end




