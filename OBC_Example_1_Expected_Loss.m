%OBC Example 1 in the paper: solution 'by hand'. Based on Example 2 from Holden (2022, ReStat).
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc, clear

%Calibration
r = 0.005;
phi = 2;
psi = 0.93;
pi_0 = 0.005;

%Find stable root
p = [-1 phi -psi]; coefs = roots(p);
omeg = min(abs(coefs));  
omega_check = 1-sqrt(1-psi) - omeg;

%Loss function
T_sim = 5000;  %Time horizon
betta = 0.99;  %Discount factor

pi = NaN(T_sim,1); pi_bind = pi; int = pi; int_bind = pi; int_star = pi; int_bind_star = pi;
pi_series = pi; pi_bind_series = pi;
Time = 0:T_sim; 

%Period 1
pi(1) = omeg*pi_0;
pi_bind(1) = -r/omeg;

int(1) = r + phi*pi(1) - psi*pi_0;
int_bind(1) = 0;

int_star(1) = int(1);
int_bind_star(1) = r + phi*pi_bind(1) - psi*pi_0;

pi_series(1) = pi(1)^2;
pi_bind_series(1) = pi_bind(1)^2;

%Periods 2 onwards
for t=2:T_sim
    
    pi(t) = omeg*pi(t-1);
    int(t) = r + phi*pi(t) - psi*pi(t-1);
    
    pi_bind(t) = omeg*pi_bind(t-1);
    int_bind(t) = r + phi*pi_bind(t) - psi*pi_bind(t-1);
    
    int_star(t) = int(t);
    int_bind_star(t) = int_bind(t);

    pi_series(t) = betta^(t-1)*pi(t)^2;
    pi_bind_series(t) = betta^(t-1)*pi_bind(t)^2;
    
end

n_prob = 100;
prob = linspace(0,1,n_prob); 
Loss = NaN(n_prob,1);

for i=1:n_prob

    Loss(i) = prob(i)*sum(pi_series) + (1-prob(i))*sum(pi_bind_series); 
    %Line1(i) = omeg^2*pi_0^2/(1-betta*omeg^2);
    %Line2(i) = (r/omeg)^2/(1-betta*omeg^2);

end

figure(1)
subplot(1,2,1), plot(prob,Loss,'k'), xlabel('Pr(Solution 1): p_1'),ylabel('E_0[L]'), hold on,
title('Expected loss')
%plot(prob,Line1,'--k'), plot(prob,Line2,'--k')


   