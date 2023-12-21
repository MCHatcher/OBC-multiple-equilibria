%PF_insert. Guess and verify part of the algorithm.  Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). 
%Any errors are my own. Last updated: 12/04/2023.

X_stack = NaN(nvar,1);
X_sol = NaN(nvar,T_sim-1,N_guess); X_sol_exc = NaN(nvar-nx,T_sim-1,N_guess);
ind_sol = NaN(N_guess,T_sim-1); 
X_star_sol = NaN(N_guess,T_sim-1); 

Omeg_t = NaN(size(Omega_bar,1), size(Omega_bar,2), T_sim);
Gama_t = NaN(size(Gama_bar,1), size(Gama_bar,2), T_sim);
Psi_t = NaN(size(Psi_bar,1), size(Psi_bar,2), T_sim);

for m=1:N_guess
     
ind = [ind_stack(:,m); vec_1];
Verify = NaN(T_sim-1,1);
X_star_store =  NaN(T_sim-1,1);

%Initial values for recursion
Omeg = Omega_bar; Gama = Gama_bar; Psi = Psi_bar; 
for t=T_guess+1:T_sim
    Omeg_t(:,:,t) = Omega_bar;
    Gama_t(:,:,t) = Gama_bar;
    Psi_t(:,:,t) = Psi_bar;
end

%Computation of matrix recursion
 for t=T_guess:-1:1       
            
    B1t = ind(t)*B1 + (1-ind(t))*B1_tild;
    B2t = ind(t)*B2 + (1-ind(t))*B2_tild;
    B3t = ind(t)*B3 + (1-ind(t))*B3_tild;
    B4t = ind(t)*B4 + (1-ind(t))*B4_tild;
    B5t = ind(t)*B5 + (1-ind(t))*B5_tild; 
    
    if det(B1t - B2t*Omeg) ~= 0
        
    Psi = (B1t - B2t*Omeg) \ (B2t*(Psi + Gama*e_vec(:,t+1)) + B5t); 
    Gama = (B1t - B2t*Omeg) \ B4t; 
    Omeg = (B1t - B2t*Omeg) \ B3t; 
    Dum(m) = 0;
    
    else
        Dum(m) = 1; 
        DD = sprintf('Non-invertibility problem for guess no. %d',m);
        disp(DD)
        Gama =  Gama_bar;
        Psi = Psi_bar;
        Omeg = Omega_bar;
        break
    end

                      
    Omeg_t(:,:,t) = Omeg;
    Gama_t(:,:,t) = Gama;
    Psi_t(:,:,t) = Psi;
    
 end
 
%Simulation results 
X = X_init;

for t=1:T_sim-1 
        
        X_lag = X;
        if Dum(m) == 1
            X = NaN; Verify(t) = NaN;
            break
        end
            
        X = Omeg_t(:,:,t)*X + Gama_t(:,:,t)*e_vec(:,t) + Psi_t(:,:,t);
        X_e = Omeg_t(:,:,t+1)*X + Gama_t(:,:,t+1)*e_vec(:,t+1) + Psi_t(:,:,t+1);  %X(+1) 
        
       %Store for later
        X_stack(:,t) = X;
           
        %Verify or reject guessed solution
        X_star = F*[X; X_e; X_lag] + G*e_vec(:,t) + H;
        X_star_store(t) = X_star;
        
        if X_star >= X1_min && ind(t) == 1  || X_star <= X1_min && ind(t) == 0
            Verify(t) = 1;
        else
            break
        end

        %if X_stack(1,t) == max(X1_min,X_star) does not work well due to numerical precision
        %For accuracy, can use vpa(.)
            
end 

    if sum(Verify) == T_sim-1 && min(X_stack(1,T_guess:T_sim-1)) > X1_min  
         X_sol(:,:,m) = X_stack(:,:);
         X_sol_exc(:,:,m) = X_stack(1:nvar-nx,:);
         mstar(m) = m;
         ind_sol(m,:) = ind(1:T_sim-1)';
         X_star_sol(m,:) = X_star_store(1:T_sim-1);
    end
         
end


   


