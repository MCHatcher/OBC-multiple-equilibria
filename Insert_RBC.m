% Extra Application (Supplementary Appendix) - RBC model with a contraint
% on investment. The calibration here follows the baseline exercise in
% Iacoviello and Guerrieri (2015, Section 4).

%Calibration
A_SS = 1;
betta = 0.96;
deltta = 0.10;
phi = 0.975;
sigma = 2;
alfa = 0.33;

%Shock
rho = 0.90;

%Find steady state
denom = 1-betta*(1-deltta);
K_SS = (A_SS*alfa*betta/denom)^(1/(1-alfa));
I_SS = deltta*K_SS;
Y_SS = A_SS*K_SS^alfa;
R_SS = alfa*Y_SS/K_SS + 1-deltta;
C_SS = Y_SS - I_SS;

X1_min = phi-1;

%Matrices for xstar
F = [0 1/deltta 0 -1 0 0 0 zeros(1,7) 0 -(1-deltta)/deltta zeros(1,5)]; G = 0; H = 0;

%Reference regime
B1 = [1 -1/deltta zeros(1,5); 0 1 C_SS/K_SS 0 -Y_SS/K_SS 0 0; 0 0 1 zeros(1,4); 0 0 0 1 0 0 0; zeros(1,4) 1 0 -1; zeros(1,5) 1 -alfa*(Y_SS/K_SS)/R_SS; zeros(1,6) 1];
B2 = [zeros(2,7); 0 0 1 0 0 -1/sigma 0; zeros(4,7)];
B3 = [0 -(1-deltta)/deltta zeros(1,5); 0 (1-deltta) zeros(1,5); zeros(2,7); 0 alfa zeros(1,5); 0 -alfa*(1-alfa)*(Y_SS/K_SS)/R_SS zeros(1,5); zeros(1,6) rho];
B4 = [zeros(6,1); 1];
B5 = zeros(7,1);

%Alternative regime
B1_tild = [1 zeros(1,6); -deltta 1 zeros(1,5); 0 K_SS/C_SS 1 0 -Y_SS/C_SS 0 0; 0 0 sigma C_SS^sigma 0 0 0; zeros(1,4) 1 0 -1; zeros(1,5) 1 -alfa*(Y_SS/K_SS)/R_SS; zeros(1,6) 1];
B2_tild = [zeros(3,7); 0 0 sigma (1-deltta)*C_SS^sigma/R_SS 0 -1 0; zeros(3,7)];
B3_tild = [zeros(1,7); 0 (1-deltta) zeros(1,5); 0 (1-deltta)*K_SS/C_SS zeros(1,5); zeros(1,7); 0 alfa zeros(1,5); 0 -alfa*(1-alfa)*(Y_SS/K_SS)/R_SS zeros(1,5); zeros(1,6) rho];
B4_tild = B4;
B5_tild = [X1_min; zeros(6,1)];



