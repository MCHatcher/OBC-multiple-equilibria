%Policy Application from the OBC paper (NK model), perfect forsight paths.
%To study a different example, simply change 'Insert' files and nx
%Model matrices are defined in the 'Insert' files
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc; clear; %close all;

T_guess = 20; % Final date before terminal solution (guess)
T_guess = max(T_guess,3);
T_sim = T_guess + 20; % Simulation length
T_news = 1;
nat_num = 400;  %Should be >=1
N_guess = nat_num*T_guess;  %No. of guesses 
T_sim = max(T_sim,T_guess + 30);
vec_1 = ones(T_sim-T_guess,1);  %Vec of ones

%Shocks
zero = zeros(1,T_sim+1);

%Model and calibration
run Insert_Samuelson

%No. of variables
nvar = length(B1(:,1)); 
nx = 0; %  %No. exogenous variables in x

%Find terminal solution
run Cho_and_Moreno

Omeg_t = NaN(size(Omega_bar,1), size(Omega_bar,2), T_sim);
Gama_t = NaN(size(Gama_bar,1), size(Gama_bar,2), T_sim);
Psi_t = NaN(size(Psi_bar,1), size(Psi_bar,2), T_sim);

%Guessed structure
rng(1), ind_stack = randi([0 1],T_guess,N_guess);  %Initialize with random guesses
%run Guesses_master
run Guesses_master_2

%Check if M is a P matrix
e(1) = -0.125; e(2:T_news) = 0; %Specified news shocks
e_vec = [e(1) e(2:T_news) zeros(1,T_sim+1-T_news)]; 
X_init = [G_SS; C_SS; I_SS; Y_SS];   %Initial values

not_P = NaN;
run M_matrix
run P_matrix
    
mstar = zeros(N_guess,1);

run PF_insert.m

run Solutions_insert.m

run Print.m

figure(1)
T_plot = 41; %Time horizon in plot
T_sim2 = (T_sim<=T_plot)*T_sim + (T_sim>T_plot)*T_plot; 
Time = 1:T_sim2-1;  %Counter for time

%Plot solutions
for j=1:k

subplot(2,3,1), plot(Time,x_fin(2+nvar*(j-1),1:T_sim2-1)/C_SS,'k','LineWidth',1),  xlabel('Time'), title('Consumption'), xlim([1 inf]), hold on 
subplot(2,3,2), plot(Time,x_fin(3+nvar*(j-1),1:T_sim2-1)/I_SS,'k','LineWidth',1),  xlabel('Time'), title('Investment'), xlim([1 inf]), hold on
subplot(2,3,3), plot(Time,(-1*x_fin(1+nvar*(j-1),1:T_sim2-1))/G_SS,'k','LineWidth',1), xlabel('Time'), title('Govt. expenditure'), xlim([1 inf]), hold on,
subplot(2,3,4), plot(Time,(x_fin(4+nvar*(j-1),1:T_sim2-1))/Y_SS,'k','LineWidth',1), xlabel('Time'), title('Output'), xlim([1 inf]), hold on,


end

ylim([-inf inf])
