%Policy App. from the OBC paper (NK model), find perfect forsight paths.
%Case of forward guidance modelled via `news shocks': welfare analysis
%To study a different example, simply change 'Insert' files and nx
%Model matrices are defined in the 'Insert' files
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc; clear; %close all;

T_guess = 20; % Final date before terminal solution (guess)
T_guess = max(T_guess,3);
T_sim = 1001; % Simulation length: long sim for welfare
T_news = 6;   %Date of last non-zero news shock
nat_num = 300;  %Integer >=1
N_guess = nat_num*T_guess;  %No. of guesses 
T_sim = max(T_sim,T_guess + 30);
vec_1 = ones(T_sim-T_guess,1);  %Vec of ones

%Shocks
zero = zeros(2,T_sim+1); 

%Model and calibration
run Insert_App_2_FG

%No. of variables
nvar = length(B1(:,1));
nx = 0;  %No. exogenous variables in x

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
e = zero(1,:); e_FG = zero(1,:);
e(1) = 0.01;  %Specified news shocks
e_FG(1) = 0; e_FG(1,2:T_news) = - 0.01 - 0.005;  %Forward guidance shocks
e_vec = [e(1:T_news) zeros(1,T_sim+1-T_news); e_FG(1:T_news) zeros(1,T_sim+1-T_news)]; 

X_init = zeros(nvar,1);   %Initial values
not_P = NaN;
%run M_matrix
%run P_matrix

run PF_insert.m

run Solutions_insert_App_2.m

run Print.m

%Welfare analysis
Lambda = 0.1;
pi = NaN(T_sim-1,k); gap = pi; Loss = NaN(k,1);
Time = 1:T_sim-1;
betta_vec = betta.^(Time-1);

for j=1:k
    pi(1:T_sim-1,j) = x_fin(4+nvar*(j-1),1:T_sim-1);
    gap(1:T_sim-1,j) = x_fin(3+nvar*(j-1),1:T_sim-1);
    Loss(j) = betta_vec*( pi(1:T_sim-1,j).^2 + Lambda*gap(1:T_sim-1,j).^2 ); 
end
 
L1_IT = 1.20573380932029e-05; %Update if change lambda from 0.1

%%L1_IT = 1.75247587204238e-05;  %Lambda = 0.2;
%%L_1_IT = 7.13665952870414e-06;  %Lambda = 0.01;

Ratio = Loss/L1_IT

prob_1 = 0:0.01:1;

if k==2
    Loss_e = prob_1*Ratio(1) + (1-prob_1)*Ratio(2);
elseif k==1
    Loss_e = (prob_1+1-prob_1)*Ratio(1);
end

hold on, subplot(1,2,1), semilogy(prob_1,Loss_e,'k','LineWidth',1), xlabel('p_1 (Prob. of Solution 1)')
hold on, subplot(1,2,2), plot(prob_1,Loss_e,'k','LineWidth',1), ylim([0 80]), xlim([0.997 1]), xlabel('p_1 (Prob. of Solution 1)')



