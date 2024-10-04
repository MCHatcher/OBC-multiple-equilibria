% Based on Cho and Moreno (2011, Journal of Econ Dynamics and Control)
% Recursive algorithm for computing the unique fixed-structure fundamental
% rational expectations solution that satisfies the no-bubbles condition.
% Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

%Cho and Moreno (2011) method for computing fixed structure solutions
J = 10000;  %no. iterations

%% Warning: DO NOT AMEND. Structures are specified in the main files.

if abs(det(B1)) >  0 
     
    A = B1 \ B2;  B = B1 \ B3;  C = B1 \ B4;  D = B1 \ B5;

%Note R = 0_{m \times m} as shocks in e(t) are mean-zero white noise. Persistent shocks can be included in x(t).
%See Kulish and Pagan (2017, Journal of Applied Econometrics)
    
%Taken from main file
I = eye(length(B1));

%Initial values (run main file with structure)
AT = A; BT = B; CT = C; DT = D;

for i=1:J
        
    AT = (I - A*BT) \  A*AT;
    CT = (I - A*BT) \ C;            %Since R = 0_{ m \times m}
    DT = (I - A*BT) \ (D + A*DT);
    BT = (I - A*BT) \ B; 
    
end

%Check1 = AT 

%Solution matrices
Omega_bar = BT; Gama_bar = CT; Psi_bar = DT;

else   
    disp('Matrix B1 non-invertible or not well defined')
    run Cho_Moreno_alternative
end
