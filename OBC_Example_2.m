%Example 1 from the OBC paper: using the solution algorithm. Based on Example 2 in Holden (2023).
%To study a different example, simply change the parameters, matrices and nx
%Model matrices are defined in the 'Insert' files
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc; clear; %close all;

T_guess = 8; % Final date before terminal solution (guess)
T_guess = max(T_guess,3);
T_sim = T_guess + 27; % Simulation length
nat_num = 300;  %Integer >=1
N_guess = nat_num*T_guess;  %No. of guesses 
T_sim = max(T_sim,T_guess + 30);
vec_1 = ones(T_sim-T_guess,1);  %Vec of ones

%Model and calibration
run Insert_Example_2

%No. of variables
nvar = length(B1(:,1)); %No. vars in x
nx = 0;  %No. exogenous vars in x

%Housekeeping
Time = 1:T_sim-1;

%Find terminal solution
run Cho_and_Moreno

%Initial values for simulations
X_init = [0; pi_0];  
X_stack = NaN(length(X_init),1);
e_vec = zeros(size(B4,2),T_sim+1);

Omeg_t = NaN(size(Omega_bar,1), size(Omega_bar,2), T_sim);
Gama_t = NaN(size(Gama_bar,1), size(Gama_bar,2), T_sim);
Psi_t = NaN(size(Psi_bar,1), size(Psi_bar,2), T_sim);

%Check if M is a P matrix
not_P = NaN;
run M_matrix
run P_matrix

%Guessed structure
rng(1), ind_stack = randi([0 1],T_guess,N_guess);  %Initialize with random guesses
run Guesses_master
%run Guesses_master_FG

run PF_insert.m

run Solutions_insert_App_2.m

run Print.m

for j=1:k
    
figure(1)
subplot(1,2,1), plot([0 Time], [pi_0 x_fin(2+nvar*(j-1),:)],'k'), hold on, xlabel('Time'), title('Inflation \pi')  
subplot(1,2,2), plot(Time, x_fin(1+nvar*(j-1),:),'k'), hold on, xlabel('Time'), title('Interest rate \it{i}')           
    
end
         
    

