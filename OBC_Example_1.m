%OBC Example 1 in the paper: solution 'by hand'. Based on Example 2 from Holden (2022, ReStat).
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc, clear

%Calibration
r = 0.005;
phi = 2;
psi = 0.93;
pi_0 = 0.02;

%Find stable root
p = [-1 phi -psi]; coefs = roots(p);
omeg = min(abs(coefs));  
omega_check = 1-sqrt(1-psi) - omeg;

T_sim = 8;  
pi = NaN(T_sim,1); pi_bind = pi; int = pi; int_bind = pi; int_star = pi; int_bind_star = pi;
Time = 0:T_sim; 

%Period 1
pi(1) = omeg*pi_0;
pi_bind(1) = -r/omeg;

int(1) = r + phi*pi(1) - psi*pi_0;
int_bind(1) = 0;

int_star(1) = int(1);
int_bind_star(1) = r + phi*pi_bind(1) - psi*pi_0;

%Periods 2 onwards
for t=2:T_sim
    
    pi(t) = omeg*pi(t-1);
    int(t) = r + phi*pi(t) - psi*pi(t-1);
    
    pi_bind(t) = omeg*pi_bind(t-1);
    int_bind(t) = r + phi*pi_bind(t) - psi*pi_bind(t-1);
    
    int_star(t) = int(t);
    int_bind_star(t) = int_bind(t);
    
end

%For plotting from date 0
pi = [pi_0; pi]; pi_bind = [pi_0; pi_bind];
int = [NaN; int]; int_bind = [NaN; int_bind];
int_star = [NaN; int_star]; int_bind_star = [NaN; int_bind_star];

%figure(1)
subplot(1,2,1), plot(Time, pi,'k','LineWidth',1.5), hold on, plot(Time,pi_bind,'Color',[0.5 0.5 0.5],'LineWidth',1.5), xlabel('Time'), title('Inflation \pi')
subplot(1,2,2), plot(Time, int,'k','LineWidth',1.5), hold on, plot(Time,int_bind,'Color',[0.5 0.5 0.5],'LineWidth',1.5), title('Nominal interest rate \it{i}'),
hold on, plot(Time,int_star,'x','MarkerSize',5, 'MarkerEdgeColor','black'), plot(Time,int_bind_star,'x','MarkerSize',5, 'MarkerEdgeColor','green'), 
xlabel('Time')



   