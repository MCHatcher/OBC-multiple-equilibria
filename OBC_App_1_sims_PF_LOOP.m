%Example 1' from the OBC paper (Asset Pricing Model, Supp Appendix)
%To study a different example, simply change the parameters and matrices
%Model matrices are defined in the 'Insert' files
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc; clear; %close all;

T_guess = 20;  %Final date before terminal solution (guess)
T_guess = max(T_guess,4);
T_sim = T_guess + 17;  %Simulation length
T_news = 5;   %Date of last non-zero news shock
nat_num = 300;    %Integer >=1
N_guess = nat_num*T_guess;  %No. of guesses 
T_sim = max(T_sim,T_guess + 30);
vec_1 = ones(T_sim-T_guess,1);  %Vec of ones

N_policy = 60;  %No. of points for policy function

%Housekeeping
no_solutions =  NaN(1,T_sim-1); not_P = NaN;
Time = 1:T_sim-1; r_plot = NaN(N_policy,1); q_plot = r_plot;

% Model and calibration
run Insert_App_1

%No. of variables
nvar = length(B1(:,1));
nx = 1; %  %No. exogenous variables in x

%Find terminal solution
run Cho_and_Moreno

Omeg_t = NaN(size(Omega_bar,1), size(Omega_bar,2), T_sim);
Gama_t = NaN(size(Gama_bar,1), size(Gama_bar,2), T_sim);
Psi_t = NaN(size(Psi_bar,1), size(Psi_bar,2), T_sim);

%Guessed structure
rng(1), ind_stack = randi([0 1],T_guess,N_guess);  %Initialize with random guesses
run Guesses_master   
%run Guesses_master_2

%Shocks
e(2:T_news) = 0; %Specified news shocks
e1_stack = linspace(-0.2,0.2,N_policy);
e_vec = [zeros(1,T_sim+1)]; X_init = zeros(nvar,1);   %Initial values

%Check if M is a P matrix
run M_matrix
run P_matrix

for j=1:length(e1_stack)
    
    e(1) = e1_stack(j); 
    e_vec = [e(1) e(2:T_news) zeros(1,T_sim+1-T_news)];  %X_init = zeros(nvar,1);   %Initial value
    
    x_fin = NaN(nvar,T_sim-1); %To store points of policy function

run PF_insert.m

run Solutions_insert.m

no_solutions(j) = k;

r_plot(j) = 100*(x_fin(1,1)-X1_min);
q_plot(j) = 100*x_fin(2,1);

end

run Print.m

%Plot results
if ~isempty(mstar)

    figure(1)
    subplot(2,1,1), plot(e1_stack,r_plot,'k'), ylabel('Percent'), title('Policy function for Interest Rate - Level'), hold on, 
    axis([-inf inf -inf inf])
    subplot(2,1,2), plot(e1_stack,q_plot,'k'), ylabel('Percent'), title('Policy function for Asset Price - Percent Dev. from Steady State'), hold on, 
    axis([-inf inf -inf inf]), xlabel('Shock size')

end

   


