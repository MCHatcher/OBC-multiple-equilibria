%Policy application from the OBC paper (NK model), analysis of the M matrix.
%To study a different example, simply change the parameters and matrices
%Model matrices are defined in the 'Insert' files
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

clc; clear; %close all;

%Size of M matrix
T_guess = 16;

%Parameter values
sigma = 1;
PI_coef = linspace(1.001,4,80);   %PI_coef = linspace(0.001,4,80) %PLT
DY_coef = linspace(0.001,3,80);
Z = ones(length(PI_coef),length(DY_coef));

for ll=1:length(PI_coef)

    for mm=1:length(DY_coef)

        thetta_pi = PI_coef(ll);
        thetta_dy = DY_coef(mm);
            
    % Model and calibration
    run Insert_App_2_loop
    %run Insert_App_2_loop_PLT

    %No. of variables
    nvar = length(B1(:,1));  %No. vars in x

    %Initial values
    e_vec = zeros(1,T_guess+1); 
    X_init = zeros(nvar,1);   %Initial value

    % Find terminal solution
    run Cho_and_Moreno

    % Check if M is a P matrix
    not_P = NaN;
    run M_matrix
    run P_matrix
    
    if not_P == 1
        Z(ll,mm) = -1;
    end

    end
    
end

line(1:length(DY_coef)) = 1;    

[X,Y] = meshgrid(DY_coef,PI_coef);
figure(1)
subplot(1,3,1), contourf(X,Y,Z,1), colormap(hot), title('\sigma = 1'),   %title('\rho_i = 0.4')
xlabel('\theta_{\Delta y}'), ylabel('\theta_\pi'),  xlim([0,inf]),
ylim([1,inf]), hold on, %plot(DY_coef,line,'--k')


