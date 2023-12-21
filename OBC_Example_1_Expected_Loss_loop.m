%OBC Example 1 in the paper: solution 'by hand'. Based on Example 2 from Holden (2022, ReStat).
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc, clear

%Calibration
r = 0.005;
phi = 2;
psi = 0.93;

n_loop = 100;
pi0_stack = linspace(1e-5,0.02,n_loop);

%Loss function
prob = 0.25;
T_sim = 5000;  %Time horizon
betta = 0.99;  %Discount factor
Loss = NaN(n_loop,1); Loss_slack = Loss; Loss_diff = Loss; Zero = Loss;

for i=1:n_loop

    pi_0 = pi0_stack(i);

    %Find stable root
    p = [-1 phi -psi]; coefs = roots(p);
    omeg = min(abs(coefs));  
    omega_check = 1-sqrt(1-psi) - omeg;

    T_sim = 5000;  
    pi = NaN(T_sim,1); pi_bind = pi; int = pi; int_bind = pi; int_star = pi; int_bind_star = pi;
    pi_series = pi; pi_bind_series = pi;
    Time = 0:T_sim; 

    %Period 1
    pi(1) = omeg*pi_0;
    pi_bind(1) = -r/omeg;

    pi_series(1) = pi(1)^2;
    pi_bind_series(1) = pi_bind(1)^2;

    %Periods 2 onwards
    for t=2:T_sim
    
        pi(t) = omeg*pi(t-1);   
        pi_bind(t) = omeg*pi_bind(t-1);

        pi_series(t) = betta^(t-1)*pi(t)^2;
        pi_bind_series(t) = betta^(t-1)*pi_bind(t)^2;
    
    end

Loss(i) = prob*sum(pi_series) + (1-prob)*sum(pi_bind_series);
Loss_slack(i) = sum(pi_series); 
Loss_diff(i) = Loss(i) - Loss_slack(i);
Zero(i) = 0;

end


figure(1)
subplot(1,2,2), plot(pi0_stack,Zero,'--k'), hold on, plot(pi0_stack,Loss_diff,'k') 
xlabel('Initial inflation \pi_0'), ylabel('E_0[L] - L_1'), title('Expected loss due to ZLB'), hold on,
%plot(prob,Line1,'--k'), plot(prob,Line2,'--k')


   