%Policy application from the OBC paper (NK model), find perfect forsight paths.
%Case of forward guidance modelled via `news shocks'
%To study a different example, simply change 'Insert' files and nx
%Model matrices are defined in the 'Insert' files
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc; clear; %close all;

T_guess = 20; % Final date before terminal solution (guess)
T_guess = max(T_guess,3);
T_sim = T_guess + 10; % Simulation length
T_news = 6;   %Set at 1 for no FG
nat_num = 350;  %Integer >=1
N_guess = nat_num*T_guess;  %No. of guesses 
T_sim = max(T_sim,T_guess + 30);
vec_1 = ones(T_sim-T_guess,1);  %Vec of ones

%Shocks
zero = zeros(2,T_sim+1); 

% Model and calibration
%run Insert_App_2
run Insert_App_2_FG
%run Insert_App_2_PLT

%No. of variables
nvar = length(B1(:,1));
nx = 0;  %No. exogenous variables in x

% Find terminal solution
run Cho_and_Moreno

Omeg_t = NaN(size(Omega_bar,1), size(Omega_bar,2), T_sim);
Gama_t = NaN(size(Gama_bar,1), size(Gama_bar,2), T_sim);
Psi_t = NaN(size(Psi_bar,1), size(Psi_bar,2), T_sim);

%Guessed structure
rng(1), ind_stack = randi([0 1],T_guess,N_guess);  %Initialize with random guesses
%run Guesses_master
run Guesses_master_2

%Shocks
e = zero(1,:); e_FG = zero(1,:);
e(1) = 0.01;  %Specified news shocks
e_FG(1) = 0; e_FG(1,2:T_news) = - 0.01 - 0.005;  %Forward guidance shocks
e_vec = [e(1:T_news) zeros(1,T_sim+1-T_news); e_FG(1:T_news) zeros(1,T_sim+1-T_news)]; 

%Check if M is a P matrix
X_init = zeros(nvar,1);   %Initial values
not_P = NaN;
run M_matrix
run P_matrix

run PF_insert.m

run Solutions_insert_App_2.m

run Print.m

%Plot simulated series
T_plot = 21; %Time horizon in plot
T_sim2 = (T_sim<=T_plot)*T_sim + (T_sim>T_plot)*T_plot; 
Time = 1:T_sim2-1;  %Counter for time

figure(1)

for j=1:k

    if j==1

subplot(2,3,1), plot(Time,x_fin(4+nvar*(j-1),1:T_sim2-1),'k','LineWidth',1),  xlabel('Time'), title('Inflation'), xlim([1 inf]), hold on 
subplot(2,3,2), plot(Time,x_fin(3+nvar*(j-1),1:T_sim2-1),'k','LineWidth',1),  xlabel('Time'), title('Output gap'), xlim([1 inf]), hold on
subplot(2,3,3), plot(Time,100*(x_fin(1+nvar*(j-1),1:T_sim2-1)-X1_min),'k','LineWidth',1), xlabel('Time'), title('Interest rate (%)'), xlim([1 inf]), hold on,
 
    else
subplot(2,3,4), plot(Time,x_fin(4+nvar*(j-1),1:T_sim2-1),'k','LineWidth',1),  xlabel('Time'), title('Inflation'), xlim([1 inf]), hold on 
subplot(2,3,5), plot(Time,x_fin(3+nvar*(j-1),1:T_sim2-1),'k','LineWidth',1),  xlabel('Time'), title('Output gap'), xlim([1 inf]), hold on
subplot(2,3,6), plot(Time,100*(x_fin(1+nvar*(j-1),1:T_sim2-1)-X1_min),'k','LineWidth',1), xlabel('Time'), title('Interest rate (%)'), xlim([1 inf]), hold on,

    end

end

ylim([-inf inf])
