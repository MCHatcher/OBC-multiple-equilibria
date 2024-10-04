%Computing the M martix of impulse responses. For reference, see Holden (2023, Sec 2.4 and Online Appendix, Sec D). 
%Code written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own. Last updated: 03/10/2024.

not_P = NaN;  %Initialization
Gama_hat = (B1 - B2*Omega_bar) \ eye(length(X_init));
X_init_adj = zeros(length(X_init),1);

if det(B1-B2-B3) == 0
    disp('Assumption 1 not satisfied')
end
X_bar = (B1-B2-B3) \ B5;

e_tild = NaN(length(X_init),T_guess+1); e_tild1 = e_tild;

for j=1:T_guess
      
Psi = Psi_bar-Psi_bar; Psi_1 = Psi; 
v = zeros(length(X_init),T_guess+1); 
v(1,j) = 1;  

    for t=1:T_guess+1

        %e_vec(:,t) = zeros(length(e_vec),1);
        e_tild(:,t) = B4*e_vec(:,t);
        e_tild1(:,t) = B4*e_vec(:,t) + v(:,t); 
    
    end

    for t=T_guess:-1:1
    
        Psi = (B1 - B2*Omega_bar) \ (B2*(Psi + Gama_hat*e_tild(:,t+1)));
        Psi_1 = (B1 - B2*Omega_bar) \ (B2*(Psi_1 + Gama_hat*e_tild1(:,t+1)));
        Psi0_t(:,t) = Psi; 
        Psi01_t(:,t) = Psi_1;
    
    end
    
    x_irf(:,1) = Omega_bar*X_init_adj + Gama_hat*e_tild(:,1) + Psi0_t(:,1);
    x_irf1(:,1) = Omega_bar*X_init_adj + Gama_hat*e_tild1(:,1) + Psi01_t(:,1);
    
    for t=2:T_guess
        
        x_irf(:,t) = Omega_bar*x_irf(:,t-1) + Gama_hat*e_tild(:,t) + Psi0_t(:,t);
        x_irf1(:,t) = Omega_bar*x_irf1(:,t-1) + Gama_hat*e_tild1(:,t) + Psi01_t(:,t);
        
    end
    
    M(:,j) = x_irf1(1,:)' - x_irf(1,:)';
    
end


    
    