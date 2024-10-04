% Example 3' (Supplementary Appendix) - Endogenous business cycles.
% Samuelson multiplier-accelerator model with forward-looking expectations  
% and an upper bound G_max on government expenditure.

%Calibration
a = 0.025;
b = 0.70;
d = 1.3;
betta = 0.05;
Tax = 0.01;
thetta = 0.055;
I_SS = 0.20;
G_SS = 0.082;
G_max = 1.035*G_SS;

%Find steady state
Y_SS = (a-b*Tax + I_SS + G_SS)/(1-b);
C_SS = a + b*(Y_SS-Tax);

%Lower bound
X1_min = -G_max;

%Matrices for xstar
F = [zeros(1,11) thetta]; G = 0; H = -(thetta*Y_SS+G_SS);

%Reference regime
B1 = [1 0 0 0; 0 1 0 0; 0 -d 1 0; 1 -1 -1 1];
B2 = [0 0 0 0; 0 0 0 b*betta; 0 -d*betta 0 0; 0 0 0 0];
B3 = [0 0 0 thetta; 0 0 0 b*(1-betta); 0 -d*(1-betta) 0 0; 0 0 0 0];
B4 = [0;0;1;0];
B5 = [-G_SS-thetta*Y_SS; a-b*Tax; I_SS; 0];

%Alternative regime
B1_tild = B1;
B2_tild = B2;
B3_tild = [0 0 0 0; 0 0 0 b*(1-betta); 0 -d*(1-betta) 0 0; 0 0 0 0];
B4_tild = B4;
B5_tild = [X1_min; a-b*Tax; I_SS; 0];



