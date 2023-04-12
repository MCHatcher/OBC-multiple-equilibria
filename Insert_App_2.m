% Application 2 - New Keynesian model in Brendon et al. (2013). Parameters
% here are based on the example in Holden (2022, Supp Appendix, Section E).

%Calibration
betta = 0.99;
X1_min = betta-1; 
sigma = 1;
kappa = (1-0.85)*(1-0.85*betta)*(2+sigma)/0.85;
rho_i = 0;
thetta_pi = 1.5;
thetta_y = 0;
thetta_dy = 1.6;

%Matrices for xstar
F = [0 1 zeros(1,10)]; G = 0; H = 0;

%F = [0 0 (1-rho_i)*(thetta_y+thetta_dy) (1-rho_i)*thetta_pi 0 0 0 0 0 rho_i -(1-rho_i)*thetta_dy 0]; G = 0; H = 0;

%Reference regime
B1 = [1  -1  0  0; 0 1 -(1-rho_i)*(thetta_y+thetta_dy) -(1-rho_i)*thetta_pi; 1/sigma 0 1 0; 0 0 -kappa 1];
B2 = [zeros(2,4); 0 0 1 1/sigma; 0 0 0 betta];
B3 = [0 0 0 0; 0 rho_i -(1-rho_i)*thetta_dy 0; zeros(2,4)];
B4 = [0;0;1;0];
B5 = [0;0;0;0];

%Alternative regime
B1_tild = [1  0  0  0; 0 1 -(1-rho_i)*(thetta_y+thetta_dy) -(1-rho_i)*thetta_pi; 1/sigma 0 1 0; 0 0 -kappa 1];
B2_tild = B2;
B3_tild = B3;
B4_tild = B4;
B5_tild = [X1_min; 0; 0; 0];



