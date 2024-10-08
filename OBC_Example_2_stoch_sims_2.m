%Fisherian model: `stochastic sims' using the algorithm. Model based on Example 2 in Holden (2023).
%Case of stochastic simulation, similar to Example 2 of the paper (Hatcher, 2024) 
%In this version, we illustrate the 'flat priors' approach to selecting a solution (Line 98).
%To study a different example, simply change the parameters, matrices and nx
%Model matrices are defined in the 'Insert' files
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc; clear; %close all;

T_guess = 8; % Final date before terminal solution (guess)
T_guess = max(T_guess,3);
T_sim = T_guess + 17; % Simulation length
nat_num = 50;  %Integer >=1
N_guess = nat_num*T_guess;  %No. of guesses 
T_sim = max(T_sim,T_guess + 30);
vec_1 = ones(T_sim-T_guess,1);  %Vec of ones

%Model and calibration
run Insert_Example_2

%No. of variables
nvar = length(B1(:,1)); %No. vars in x
nx = 0;  %No. exogenous vars in x

%For plots
Time = 1:20; T_plot = 20;
N_sims = 5;  %No. of simulations 

%Housekeeping
X_sol = NaN(nvar,T_sim-1,N_guess); kstar_stack = NaN(N_sims,T_sim-1);
x_t1 = NaN(nvar,T_sim); ind_t1 = NaN(1,T_sim); X_stack = NaN(nvar,T_sim-1);
no_solutions = NaN(1,T_sim-1); no_uniq_solutions = no_solutions;
excess_solutions = no_solutions; ind_sol = NaN(N_guess,T_sim-1);

%Find terminal solution
run Cho_and_Moreno 

%Initial values and matrices
X_init = [0; pi_0];
e(1) = -0.001; e(2) = -0.001;  %A in periods 1 and 2
e_vec = [e(1) e(2) zeros(1,T_sim-1)];

Omeg_t = NaN(size(Omega_bar,1), size(Omega_bar,2), T_sim);
Gama_t = NaN(size(Gama_bar,1), size(Gama_bar,2), T_sim);
Psi_t = NaN(size(Psi_bar,1), size(Psi_bar,2), T_sim);

%Check if M is a P matrix
run M_matrix
run P_matrix

%Guessed structure
rng(1), ind_stack = randi([0 1],T_guess,N_guess);  %Initialize with random guesses
run Guesses_master 
%run Guesses_master_2

%-----------------------------
%Loop for random simulations
%-----------------------------

for i=1:N_sims

rng(19+i)  %rng(19+i) 

    for t1=1:T_sim-1
    
        mstar = zeros(N_guess,1);

    if t1==1
        X_init = [0; pi_0]; 
        e(1) = -0.001; e(2) = -0.001;  %Shock in period 1 
        e_vec = [e(1) e(2) zeros(1,T_sim-1)];
    elseif t1>1 
        X_init = x_t1(:,t1-1); 
        e(1) = sigma_e*randn; e(2) = sigma_e*randn;  %Shock in period 1  
        e_vec = [e(1) e(2) zeros(1,T_sim-1)];
    end

    run PF_insert.m

    mstar(mstar==0) = [];
    if isempty(mstar) 
            disp('No solution found. Check T_guess and N_guess are not too small.')
    end  

X_sol = X_sol(:,:,mstar);
solutions =  reshape(permute(X_sol,[1,3,2]),[],size(X_sol,2));
ind_solutions = ind_sol(mstar,:);

x_fin = unique(solutions,'rows','stable');
sol_ind = unique(ind_solutions,'rows','stable');

%No. of solutions
k = length(x_fin(:,1,1))/nvar;

    if k == 1
        kstar = 1; 
        x_t1(:,t1) = x_fin(1:nvar,t1);
        ind_t1(1,t1) = sol_ind(1,t1);  
    else 
        prob = ones(k,1)/k;  %Agnostic -- flat priors
        run Select_solution.m   %Resolve indeterminacy       
    end

    kstar_stack(i,t1) = kstar;
    x_t1(:,t1) = x_fin((kstar-1)*nvar+1:kstar*nvar,1);
    ind_t1(1,t1) = sol_ind(kstar,1);  

    no_solutions(t1) = length(mstar);
    no_uniq_solutions(t1) = k;

    end

subplot(2,2,1), plot([0 Time],[pi_0 x_t1(2,1:T_plot)],'k'),  xlabel('Time'), title('Inflation \pi'), hold on, 
subplot(2,2,2), plot(Time,x_t1(1,1:T_plot),'k'),  xlabel('Time'), title('Nominal interest rate \it{i}'), hold on

end
   
run Print.m


