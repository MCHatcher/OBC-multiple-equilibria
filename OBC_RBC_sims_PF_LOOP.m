%Extra application (RBC model + investment constraint) in the Supplementary Appendix.
%This code computes and plots the policy functions for Investment and
%Consumption. To study a different example, simply change the parameters and matrices
%Model structures are defined in the 'Insert' files
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc; clear; %close all;

T_guess = 20; % Final date before terminal solution (guess)
T_sim = T_guess+1; % Simulation length
T_news = 3;
N_guess = 20;  %No. of guesses 
nvar = 7;  %No. vars in x
nx = 1;  %No. exog vars in x
N_policy = 100; %No. of points for policy function

%Housekeeping
Time = 1:T_sim-1; inv_plot = NaN(N_policy,1); c_plot = inv_plot;

%Guessed structure
rng(1)
ind_stack = randi([0 1],T_guess,N_guess);
ind_stack(:,1) = ones(T_guess,1); 
for i=2:T_guess
    ind_stack(:,i) = [zeros(i-1,1); ones(T_guess-(i-1),1)]; 
end
vec_1 = ones(T_sim-T_guess,1);
    
% Model and calibration
run Insert_RBC

% Find terminal solution (Cho and Moreno 2011, JEDC)
run Cho_and_Moreno

%Shocks
X_init = zeros(nvar,1);

Omeg_t = NaN(size(Omega_bar,1), size(Omega_bar,2), T_sim);
Gama_t = NaN(size(Gama_bar,1), size(Gama_bar,2), T_sim);
Psi_t = NaN(size(Psi_bar,1), size(Psi_bar,2), T_sim);
    
X_stack = NaN(length(X_init),1);
X_sol = NaN(nvar,T_sim-1,N_guess); X_sol_exc = NaN(nvar-nx,T_sim-1,N_guess);
ind_sol = NaN(N_guess,T_sim-1);

%Shocks
e(2:T_news) = 0; %Specified news shocks
e1_stack = linspace(-0.03,0.02,N_policy);

for j=1:length(e1_stack)
    
    e(1) = e1_stack(j); 
    e_vec = [e(1)  e(2:T_news) zeros(1,T_sim+1-T_news)];
    
    x_fin = NaN(nvar,T_sim-1);
    mstar = zeros(N_guess,1);
 
    run PF_insert

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
        %disp('Unique solution found')
    else
        disp('Warning: Multiple solutions or no solution')
     end
    
end  

inv_plot(j) = 100*x_fin(1,1);
c_plot(j) = 100*x_fin(3,1);

end

%figure(1)
subplot(1,2,1), plot(100*e1_stack,inv_plot,'k'), ylabel('Percent'), title('Policy function for Investment'), hold on,
xlabel('Shock size')
subplot(1,2,2), plot(100*e1_stack,c_plot,'k'), ylabel('Percent'), title('Policy function for Consumption'), hold on,
xlabel('Shock size')

