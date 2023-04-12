%Application 1 from the OBC paper
%To study a different example, simply change the parameters and matrices
%Model structures are defined in the 'Insert' files
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc; clear; %close all;

T_guess = 5; % Final date before terminal solution (guess)
T_sim = T_guess + 1; % Simulation length
N_guess = 30;  %No. of guesses 
T_news = 5;

nvar = 3;  %No. vars in x
nx = 1; %  %No. exogenous variables in x
N_policy = 60; %No. of points for policy function

%Housekeeping
no_solutions =  NaN(1,T_sim-1); ind_sol = NaN(N_guess,T_sim-1);
Time = 1:T_sim-1; r_plot = NaN(N_policy,1); q_plot = r_plot;

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
for i=2:T_guess+1
ind_stack(:,i) = [zeros(i-1,1); ones(T_guess-(i-1),1)]; 
end
vec_1 = ones(T_sim-T_guess,1);

%Shocks
e(2:T_news) = -0.02; %Specified news shocks
e1_stack = linspace(-0.2,0.2,N_policy);

for j=1:length(e1_stack)
    
    e(1) = e1_stack(j); 
    e_vec = [e(1) e(2:T_news) zeros(1,T_sim+1-T_news)]; X_init = zeros(nvar,1);   %Initial values
    
    x_fin = NaN(nvar,T_sim-1);
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
        %disp('Unique solution found')
    else
        disp('Warning: Multiple solutions or no solution')
     end
    
end

no_solutions(j) = k;

r_plot(j) = 100*(x_fin(1,1)-X1_min);
q_plot(j) = 100*x_fin(2,1);

end

subplot(2,1,1), plot(e1_stack,r_plot,'k'), ylabel('Percent'), title('Policy function for Interest Rate - Level'), hold on, 
axis([-inf inf -inf inf])
subplot(2,1,2), plot(e1_stack,q_plot,'k'), ylabel('Percent'), title('Policy function for Asset Price - Percent Dev. from Steady State'), hold on, 
axis([-inf inf -inf inf]), xlabel('Shock size')

   


