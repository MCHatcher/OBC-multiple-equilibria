%Application 1 from the OBC paper
%To study a different example, simply change the parameters and matrices
%Model structures are defined in the 'Insert' files
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc; clear; %close all;

T_guess = 1000; % Final date before terminal solution (guess)
T_sim = T_guess + 17; % Simulation length
T_news = 5;
N_guess = 80;  %No. of guesses 
nvar = 3;  %No. vars in x
nx = 1;  %No. exogenous variables in x

%Housekeeping
Time = 1:T_sim-1; 

%Shocks
zero = zeros(1,T_sim+1); mstar = zeros(N_guess,1);

% Model and calibration
run Insert_App_1

% Find terminal solution (Cho and Moreno 2011, JEDC)
run Cho_and_Moreno

Omeg_t = NaN(size(Omega_bar,1), size(Omega_bar,2), T_sim);
Gama_t = NaN(size(Gama_bar,1), size(Gama_bar,2), T_sim);
Psi_t = NaN(size(Psi_bar,1), size(Psi_bar,2), T_sim);

%Guessed structure
rng(1)
ind_stack = randi([0 1],T_guess,N_guess);
ind_stack(:,1) = ones(T_guess,1); 
for i=2:T_guess
    ind_stack(:,i) = [zeros(i-1,1); ones(T_guess-(i-1),1)]; 
end
vec_1 = ones(T_sim-T_guess,1);

%Check if M is a P matrix
e(1) = -0.1; e(2:T_news) = -0.02; %Specified news shocks
e_vec = [e(1) e(2:T_news) zeros(1,T_sim+1-T_news)]; X_init = zeros(nvar,1);   %Initial values
run M_matrix
run P_matrix
    
mstar = zeros(N_guess,1);

run PF_insert.m

mstar(mstar==0) = [];

if isempty(mstar) 
    
    disp('No solution found. Check T_guess and N_guess are not too small.')
    
elseif ~isempty(mstar) 

X_sol_exc = X_sol_exc(:,:,mstar);    
solutions =  reshape(permute(X_sol_exc,[1,3,2]),[],size(X_sol_exc,2));
ind_solutions = ind_sol(mstar,:);
X_sol = X_sol(:,:,mstar);
X_exog = X_sol(nvar-nx+1:nvar,:,1);  

%Solution paths
x_fin = unique(solutions,'rows','stable');
x_fin = [x_fin; X_exog];
sol_ind = unique(ind_solutions,'rows','stable');
ind_fin = sol_ind(1,:); 

%No. of solutions
k = length(x_fin(:,1))/nvar;

     if k==1
        disp('Unique solution found')
    else
        disp('Warning: Multiple solutions or no solution')
     end
    
end

%figure(1)

subplot(1,2,1), plot(Time,100*x_fin(2,1:T_sim-1),'--k'),  xlabel('Time'), title('Asset price'), hold on,
subplot(1,2,2), plot(Time,100*(x_fin(1,1:T_sim-1)-X1_min),'--k'),  xlabel('Time'), title('Interest rate'), hold on, 


   


