%Policy App. from the OBC paper (NK model), multiplcity analysis.
%Case of forward guidance modelled via `news shocks'
%To study a different example, simply change 'Insert' files and nvar,nx
%Model structures are defined in the 'Insert' files
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc; clear; %close all;

%Number of loops over initial conditions
nloop = 800;  %No. of sims, random init conditions
count = NaN(nloop,1); count_multi = count; count_no_sol = count; 
count_unique = zeros(nloop,1); count0 = 0; count1 = 0; count2 = 0; count3 = 0; count4 = 0;

T_guess = 50; % Final date before terminal solution (guess)
T_sim = T_guess + 1; % Simulation length
T_news = 8;
N_guess = 40;  %No. of guesses 

%Shocks
zero = zeros(2,T_sim+1); mstar = zeros(N_guess,1);

% Model and calibration
%run Insert_App_2
%run Insert_App_2_PLT
run Insert_App_2_FG

%No. of variables
nvar = length(B1(:,1));
nx = 0; %  %No. exogenous variables in x

% Find terminal solution (Cho and Moreno 2011, JEDC)
run Cho_and_Moreno

Omeg_t = NaN(size(Omega_bar,1), size(Omega_bar,2), T_sim);
Gama_t = NaN(size(Gama_bar,1), size(Gama_bar,2), T_sim);
Psi_t = NaN(size(Psi_bar,1), size(Psi_bar,2), T_sim);

%Guessed structure
rng(1)
%ind_stack = randi([0 1],T_guess,N_guess);
ind_stack(:,1) = ones(T_guess,1); 
for i=2:T_guess
    ind_stack(:,i) = [zeros(i-1,1); ones(T_guess-(i-1),1)]; 
end
ind_stack(:,5) = ones(T_guess,1); ind_stack(1,5)=0;  ind_stack(16,5)=0; 
vec_1 = ones(T_sim-T_guess,1);

for j=1:nloop

rng(j)

e = zero(1,:); e_FG = zero(1,:);
e(1) = 0.01;  %Specified news shocks
e_FG(1) = 0; e_FG(1,2:T_news) = - 0.01 - 0.01*rand(1,T_news-1);  %Forward guidance shocks
e_vec = [e(1:T_news) zeros(1,T_sim+1-T_news); e_FG(1:T_news) zeros(1,T_sim+1-T_news)]; 
X_init = zeros(nvar,1);   %Initial values
    
mstar = zeros(N_guess,1);

run PF_insert.m

mstar(mstar==0) = [];

if isempty(mstar) 
    
    disp('No solution found. Check T_guess and N_guess are not too small.')
    count_no_sol(j) = 1;
    count_unique(j) = 0;
    
elseif ~isempty(mstar) 

X_sol = X_sol(:,:,mstar);
X_exog = X_sol(nvar-nx+1:nvar,:,1);
X_sol_exc = X_sol_exc(:,:,mstar); 
X_star_sol = X_star_sol(mstar,:); 

%Note: The below is an ad-hoc workaround. Because in the above model i(t) = i*(t) in the reference regime, 
%ones of these paths will removed by the 'unique' function. To prevent this we add small positive number to 
%final simulated point of variable 1 (i.e. i(t)).   
for ii=1:length(X_sol(1,1,:))
    orig = X_sol(1,T_sim-1,ii); orig_exc = X_sol_exc(1,T_sim-1,ii); 
    X_sol(1,T_sim-1,ii) = orig + (1+abs(rand)/100)*1e-15;
    X_sol_exc(1,T_sim-1,ii) = orig_exc + (1+abs(rand)/100)*1e-15;
end 

solutions =  reshape(permute(X_sol_exc,[1,3,2]),[],size(X_sol_exc,2));
ind_solutions = ind_sol(mstar,:);

%Solution paths
x_fin = unique(solutions,'rows','stable');
x_fin = [x_fin; X_exog];
sol_ind = unique(ind_solutions,'rows','stable');
ind_fin = sol_ind(1,:); 
X_star_fin = unique(X_star_sol,'rows','stable');

count_no_sol(j) = 0;

%No. of solutions
k = length(x_fin(:,1))/nvar;

     if k==1
        %disp('Unique solution found')
        count_multi(j) = 0;
        count_unique(j) = 1;
     elseif k==2
        %disp('Warning: Multiple solutions or no solution')
        count_multi(j) = 1;   
        count(j) = sum(X_star_fin(2,:) <= X1_min);
     end

end

end

count = rmmissing(count);  %Count only when there is a solution

freq0 = 100*sum(count==0)/nloop; freq1 = 100*sum(count==1)/nloop;
freq2 = 100*sum(count==2)/nloop; freq3 = 100*sum(count==3)/nloop;
freq4 = 100*sum(count==4)/nloop; freq5plus = 100*sum(count>4)/nloop;

Max_time = max(count)
Min_time = min(count)
Av_time = mean(count)

Multiple = 100*sum(count_multi)/nloop
Unique = 100*sum(count_unique)/nloop
No_solution = 100*sum(count_no_sol)/nloop

