%Fisherian model: ZLB-truncated Taylor rule + Fisher equation (Example 2 from Holden,2022, REStat)

%Calibration
r = 0.01;
phi = 2;
psi = 0.93;
pi_0 = 0.02;
X1_min = 0; %Lower bound

%Find stable root
p = [-1 phi -psi];
coefs = roots(p);
omeg = min(abs(coefs));
omega_check = 1-sqrt(1-psi) - omeg;

%For `stochastic sims' case
sigma_e = 0.00005;  %small shocks, sigma = 0.00005;

%Matrices for xstar
F = [0 phi 0 0 0 -psi]; G = 1; H = r;

%Reference regime
B1 = [1 -phi; 1 0];
B2 = [0 0; 0 1];
B3 = [0 -psi; 0 0];
B4 = [1; 0];
B5 = [r; r];

%Alternative regime
B1_tild = [1 0; 1 0];
B2_tild = B2;
B3_tild = zeros(2,2);
B4_tild = zeros(2,1);
B5_tild = [X1_min; r];



