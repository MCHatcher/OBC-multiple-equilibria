%Policy application from the OBC paper (NK model), multiplcity analysis.
%Case of forward guidance modelled via `news shocks'
%To study a different example, simply change 'Insert' files and nx
%Model matrices are defined in the 'Insert' files
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc; clear; %close all;

%Number of loops over initial conditions
nloop = 800;  %No. of PF paths, each with randomly chosen init conditions
count = NaN(nloop,1); count_multi = count; count_no_sol = count; 
count_unique = zeros(nloop,1); 

T_guess = 16;  %Final date before terminal solution (guess)
T_guess = max(T_guess,3);
T_sim = T_guess + 20;  %Simulation length
T_news = 6;     %Date of last non-zero news shock
nat_num = 250;  %Integer >=1
N_guess = nat_num*T_guess;  %No. of guesses 
T_sim = max(T_sim,T_guess + 30);
vec_1 = ones(T_sim-T_guess,1);  %Vec of ones

%Shocks
zero = zeros(2,T_sim+1); mstar = zeros(N_guess,1);

%Model and calibration
%run Insert_App_2
%run Insert_App_2_PLT
run Insert_App_2_FG

%No. of variables
nvar = length(B1(:,1));
nx = 0; %  %No. exogenous variables in x
not_P = NaN;

%Find terminal solution
run Cho_and_Moreno

Omeg_t = NaN(size(Omega_bar,1), size(Omega_bar,2), T_sim);
Gama_t = NaN(size(Gama_bar,1), size(Gama_bar,2), T_sim);
Psi_t = NaN(size(Psi_bar,1), size(Psi_bar,2), T_sim);

%Guessed structure
rng(1), ind_stack = randi([0 1],T_guess,N_guess);  %Initialize with random guesses
%run Guesses_master
run Guesses_master_2

for j=1:nloop

    rng(j)
    e = zero(1,:); e_FG = zero(1,:);
    e(1) = 0.01;  %Specified news shocks
    e_FG(1) = 0; e_FG(1,2:T_news) = - 0.01 - 0.01*rand(1,T_news-1);  %Forward guidance shocks
    e_vec = [e(1:T_news) zeros(1,T_sim+1-T_news); e_FG(1:T_news) zeros(1,T_sim+1-T_news)]; 
    X_init = zeros(nvar,1);   %Initial values

    run PF_insert.m

    run Solutions_insert_App_2_loop.m

end

count = rmmissing(count);  %Count only when there is a solution

freq0 = 100*sum(count==0)/nloop; freq1 = 100*sum(count==1)/nloop;
freq2 = 100*sum(count==2)/nloop; freq3 = 100*sum(count==3)/nloop;
freq4 = 100*sum(count==4)/nloop; freq5plus = 100*sum(count>4)/nloop;

count = count(count>0);
Max_time = max(count), Min_time = min(count)
Mean_time = mean(count), Mode_time = mode(count)

Multiple = 100*sum(count_multi)/nloop
Unique = 100*sum(count_unique)/nloop
No_solution = 100*sum(count_no_sol)/nloop

run Print.m

