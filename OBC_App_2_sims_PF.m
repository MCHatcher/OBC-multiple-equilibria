%Application 2 from the OBC paper (NK model), find perfect forsight paths.
%To study a different example, simply change 'Insert' files and nvar,nx
%Model structures are defined in the 'Insert' files
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc; clear; %close all;

T_guess = 50; % Final date before terminal solution (guess)
T_sim = T_guess + 1; % Simulation length
T_news = 1;
N_guess = 100;  %No. of guesses 
%nvar = 4; %No. vars in x   %IT case 
nvar = 5;  %No. vars in x   %PLT case
nx = 0; %  %No. exogenous variables in x

%Housekeeping
Time = 1:T_sim-1; 

%Shocks
zero = zeros(1,T_sim+1); mstar = zeros(N_guess,1);

% Model and calibration
%run Insert_App_2
run Insert_App_2_PLT

% Find terminal solution (Cho and Moreno 2011, JEDC)
run Cho_and_Moreno

Omeg_t = NaN(size(Omega_bar,1), size(Omega_bar,2), T_sim);
Gama_t = NaN(size(Gama_bar,1), size(Gama_bar,2), T_sim);
Psi_t = NaN(size(Psi_bar,1), size(Psi_bar,2), T_sim);

%Guessed structure
rng(1)
ind_stack = randi([0 1],T_guess,N_guess);
ind_stack(:,1) = ones(T_guess,1); 
for i=2:T_guess
    ind_stack(:,i) = [zeros(i-1,1); ones(T_guess-(i-1),1)]; 
end
ind_stack(:,5) = ones(T_guess,1); ind_stack(1,5)=0;  ind_stack(16,5)=0; 
vec_1 = ones(T_sim-T_guess,1);

%Check if M is a P matrix
e(1) = 0.01; e(2:T_news) = 0; %Specified news shocks
e_vec = [e(1) e(2:T_news) zeros(1,T_sim+1-T_news)]; 
X_init = zeros(nvar,1);   %Initial values
%run M_matrix
%run P_matrix
    
mstar = zeros(N_guess,1);

run PF_insert.m

mstar(mstar==0) = [];

if isempty(mstar) 
    
    disp('No solution found. Check T_guess and N_guess are not too small.')
    
elseif ~isempty(mstar) 

X_sol = X_sol(:,:,mstar);
X_exog = X_sol(nvar-nx+1:nvar,:,1);
X_sol_exc = X_sol_exc(:,:,mstar);    

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

%No. of solutions
k = length(x_fin(:,1))/nvar;

     if k==1
        disp('Unique solution found')
    else
        disp('Warning: Multiple solutions or no solution')
     end
    
end

figure(1)
for j=1:k

subplot(1,3,1), plot(Time,x_fin(4+nvar*(j-1),1:T_sim-1),'--g'),  xlabel('Time'), title('Inflation'), xlim([1 inf]), hold on 
subplot(1,3,2), plot(Time,x_fin(3+nvar*(j-1),1:T_sim-1),'--g'),  xlabel('Time'), title('Output gap'), xlim([1 inf]), hold on
subplot(1,3,3), plot(Time,100*(x_fin(1+nvar*(j-1),1:T_sim-1)-X1_min),'--g'), xlabel('Time'), title('Interest rate (%)'), xlim([1 inf]), hold on,

end

ylim([-inf inf])
