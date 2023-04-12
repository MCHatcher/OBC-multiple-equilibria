%Example 1 from the OBC paper: using the solution algorithm. Based on Example 2 in Holden (2022).
%To study a different example, simply change the parameters and matrices
%Model structures are defined in the 'Insert' files
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc; clear; %close all;

T_guess = 4; % Final date before terminal solution (guess)
T_sim = T_guess + 27; % Simulation length
N_guess = 30;  %No. of guesses 
nvar = 2;  %No. of vars in x
nx = 0;  %No. exogenous vars in x

Verify = NaN(T_sim-1,1);  mstar = zeros(N_guess,1); ind_sol = NaN(N_guess,T_sim-1);
Time = 1:T_sim-1;  X_sol = NaN(nvar,T_sim-1,N_guess);  

% Model and calibration
run Insert_Example_2

% Find terminal solution (Cho and Moreno 2011, JEDC)
run Cho_and_Moreno

%Initial values for simulations
X_init = [0; pi_0];  
X_stack = NaN(length(X_init),1);
e_vec = zeros(size(B4,2),T_sim+1);
e_vec(1,1) = -0.001; e(1,2) = -0.001;  %Shock in period 1

Omeg_t = NaN(size(Omega_bar,1), size(Omega_bar,2), T_sim);
Gama_t = NaN(size(Gama_bar,1), size(Gama_bar,2), T_sim);
Psi_t = NaN(size(Psi_bar,1), size(Psi_bar,2), T_sim);

%Check if M is a P matrix
run M_matrix
run P_matrix

%Guessed structure
ind_stack = randi([0 1],T_guess,N_guess);
ind_stack(:,1) = ones(T_guess,1);
for i=2:T_guess
    ind_stack(:,i) = [zeros(i-1,1); ones(T_guess-(i-1),1)]; 
end
vec_1 = ones(T_sim-T_guess,1);

run PF_insert.m

mstar(mstar==0) = [];
if isempty(mstar) 
    disp('No solution found. Check T_guess and N_guess are not too small.')
end
    
X_sol = X_sol(:,:,mstar);
solutions =  reshape(permute(X_sol,[1,3,2]),[],size(X_sol,2));
ind_solutions = ind_sol(mstar,:);

x_fin = unique(solutions,'rows','stable');
sol_ind = unique(ind_solutions,'rows');

%No. of solutions
k = length(x_fin(:,1,1))/nvar;

if k==1
    disp('Unique solution found')
else
    disp('Warning: Multiple solutions or no solution')
end

for j=1:k
    
figure(1)
subplot(1,2,1), plot([0 Time], [pi_0 x_fin(2+nvar*(j-1),:)],'k'), hold on, xlabel('Time'), title('Inflation \pi')  
subplot(1,2,2), plot(Time, x_fin(1+nvar*(j-1),:),'k'), hold on, xlabel('Time'), title('Interest rate \it{i}')           
    
end
         
    

