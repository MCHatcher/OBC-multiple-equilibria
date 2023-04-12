% Application 1 - Asset pricing model in Iacoviello and Guerrieri (2015,JME)

%Calibration
betta = 0.99;
rho = 0.5; rho_u = 0.5;
X1_min = -(1/betta-1); %Lower bound (must be less than q_bar = 0)
sigma = 5;
phi = 0.2;

%Matrices for xstar
F = [0 phi 0 0 0 0 0 0 0]; G = 0; H = 0;

%Reference regime
B1 = [1 -phi 0; sigma 1 -1; 0 0 1];
B2 = [0 0 0; 0 betta*(1-rho) 0; 0 0 0];
B3 = [0 0 0; 0 rho 0; 0 0 rho_u];
B4 = [0;0;1];
B5 = [0;0;0];

%Alternative regime
B1_tild = [1 0 0; sigma 1 -1; 0 0 1];
B2_tild = B2;
B3_tild = B3;
B4_tild = B4;
B5_tild = [X1_min; 0; 0];



