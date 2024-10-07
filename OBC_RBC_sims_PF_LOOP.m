%Extra Example (RBC model + investment constraint) in the Supplementary Appendix.
%This code computes and plots the policy functions for Investment and Consumption. 
%To study a different example, simply change the parameters, matrices and nx
%Model matrices are defined in the 'Insert' files
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc; clear; %close all;

T_guess = 20; % Final date before terminal solution (guess)
T_guess = max(T_guess,3);
T_sim = T_guess+1; % Simulation length
T_news = 3;
nat_num = 200;  %Integer >=1
N_guess = nat_num*T_guess;  %No. of guesses 
T_sim = max(T_sim,T_guess + 30);
vec_1 = ones(T_sim-T_guess,1);  %Vec of ones

N_policy = 60; %No. of points for policy function

%Housekeeping
Time = 1:T_sim-1; inv_plot = NaN(N_policy,1); c_plot = inv_plot; 
    
%Model and calibration
run Insert_RBC

%No. of variables
nvar = length(B1(:,1));
nx = 1;  %No. exog vars in x

%Find terminal solution
run Cho_and_Moreno

%Guessed structure
rng(1), ind_stack = randi([0 1],T_guess,N_guess);  %Initialize with random guesses
%run Guesses_master
run Guesses_master_2

%Housekeeping
Omeg_t = NaN(size(Omega_bar,1), size(Omega_bar,2), T_sim);
Gama_t = NaN(size(Gama_bar,1), size(Gama_bar,2), T_sim);
Psi_t = NaN(size(Psi_bar,1), size(Psi_bar,2), T_sim);

%Shocks
e(2:T_news) = 0; %Specified news shocks
e_vec = [0  e(2:T_news) zeros(1,T_sim+1-T_news)];  X_init = zeros(nvar,1);  %Initial conditions
e1_stack = linspace(-0.03,0.02,N_policy);    %Policy function points
    
X_stack = NaN(length(X_init),1);
X_sol = NaN(nvar,T_sim-1,N_guess); X_sol_exc = NaN(nvar-nx,T_sim-1,N_guess);
ind_sol = NaN(N_guess,T_sim-1);

%Check if M is a P matrix
not_P = NaN;
run M_matrix
run P_matrix

for j=1:length(e1_stack)
    
    e(1) = e1_stack(j); 
    e_vec = [e(1)  e(2:T_news) zeros(1,T_sim+1-T_news)];
    
    x_fin = NaN(nvar,T_sim-1);
    mstar = zeros(N_guess,1);
 
    run PF_insert

    run Solutions_insert  

inv_plot(j) = 100*x_fin(1,1);  %Points of policy function
c_plot(j) = 100*x_fin(3,1);    %Points of policy function

end

run Print.m

figure(1)
subplot(1,2,1), plot(100*e1_stack,inv_plot,'k'), ylabel('Percent'), title('Policy function for Investment'), hold on,
xlabel('Shock size')
subplot(1,2,2), plot(100*e1_stack,c_plot,'k'), ylabel('Percent'), title('Policy function for Consumption'), hold on,
xlabel('Shock size')

