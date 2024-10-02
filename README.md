# OBC-multiple-equilibria
This repository provides documents and codes for simulating multiple equilibria in otherwise-linear rational expectations with occasionally-binding constraints, under the assumption of perfect foresight. The algorithm is an extension of Guerrieri and Iacoviello (2015,JME) and we utilise some results from Holden (2023,ReStat). A description of the codes and user instructions are provided below.

CODES

Cho_and_Moreno.m -- Computes the fixed-structure fundamental rational expectations solution that satisfies the no-bubbles condition (if such a solution exists). This code is used to compute the terminal solution which applies in perpetuity after date T and converges to a steady-state away from the bound. (Other rational expectations algorithms could be used instead, provided the solution matrices are in the same format.)

Cho_Moreno_alternative.m -- Alternative algorthm for computing the terminal solution. Triggered automatically if an invertibility condition needed om Cho_and_Moreno.m is not met. 

Guesses_single.m -- Code which enumerates single spells at the bound (given by zeros) for a given T_guess. Note that we consider sequences that end in 1 (i.e. last row entry is set at 1) for convenience.

Guesses_double.m -- Code which enumerates double spells at the bound (given by zeros) for a given T_guess. Note that we consider sequences that end in 1 (i.e. last row entry is set at 1) for convenience.

Guesses_triple_1.m -- Code which enumerates triple spells at the bound (given by zeros), for a given T_guess, with the third spell lasting 1 period. Note that we consider sequences that end in 1 (i.e. last row entry is set at 1) for convenience.

Guesses_triple_2.m -- Code which enumerates triple spells at the bound (given by zeros), for a given T_guess, with the third spell lasting 2 periods. Note that we consider sequences that end in 1 (i.e. last row entry is set at 1) for convenience.

Guesses_triple_3.m -- Code which enumerates triple spells at the bound (given by zeros), for a given T_guess, with the third spell lasting 3 periods. Note that we consider sequences that end in 1 (i.e. last row entry is set at 1) for convenience.

Guesses_triple_loop.m -- Allows uses to run a loop (for l=1:n_loop, or set l = [2 5 etc.] for particular cases) and where l indexes the length of the third spell. Note that we consider sequences that end in 1 (i.e. last row entry is set at 1) for convenience.

Guesses_master.m -- Based on the Guesses_....m files commented in by the user, this code generates a stacked matrix of guesses to be used as potential structures (sequence of regimes). If the number of guesses generated falls short of the N_guess specified by the user, then the excess guesses (columns) are random guesses of 0s and 1s (set Message_2=1); if the number of guesess generated exceeds N_guess, the excess columns are ignored (set Message_1=1). In both cases, the user is informed of the result; see the file Print.m below.   

Guesses_master_FG.m -- Same as Guesses_master.m, but is convenient to have a file with more of Guesses_....m files 'commented in'. 

Insert_App_1.m -- Specifies the calibration and matrices of the different regimes (slack and bind) in the Simple Asset Pricing Model in Iacoviello and Guerrieri (2015,JME). This file is used in the OBC_App_1_...m files (see below) and some results are reported in Example 1' (Supplementary Appendix to the paper). 

Insert_App_2.m -- Specifies the calibration and matrices of the different regimes (slack and bind) in the Policy Application in the paper (Section 4). Case of inflation targeting interest rate rule, potentially with interest rate smoothing.

Insert_App_2_PLT.m -- Same as Insert_App_2.m but for the case of a price-level targeting interest rate rule. An additional variable enters, namely the log price level.

Insert_App_2_FG.m -- Same as Insert_App_2.m but for the case of forward guidance. Dimension of matrix B4 differs (n x 2 not n x 1) because of forward guidance news shocks in the monetary policy rule. 

Insert_App_2_loop.m -- Same as Insert_App_2.m but with some parameters commented out for analysis of M matrix at different parameter values. The parameter combinations are set in the OBC_App_2_M_matrix file (see below).

Insert_App_2_loop_PLT.m -- Same as Insert_App_2_loop.m but for the case of the price-level targeting rule.

Insert_Example_2.m -- Specifies the calibration and matrices of the different regimes (slack and bind) in the Fisherian model (Section 2.4, Example 1 and Example 2 in the paper).

Insert_RBC.m -- Specifies the calibration and matrices of the different regimes (slack and bind) in the Real Business Cycle model in Iacoviello and Guerrieri (2015,JME). This file is used in the OBC_RBC_sims...m files (see below) and some results are reported in Example 2' (Supplementary Appendix to the paper). 

Insert_Samuelson.m -- Specifies the calibration and matrices of the different regimes (slack and bind) in the Endogenous Business Cycle model in Example 3' (Supplementary Appendix to the paper). This file is used in the OBC_App_3_sims_PF.m file which simulates the perfect forsight path(s) for given initial conditions.

M_matrix.m -- Computes the M matrix of impulse responses (see Holden,2023) for a model with structure defined in the Insert_....m files. The resulting matrix can then be used in P_matrix.m to determine whether the M matrix has the P-matrix property.

OBC_App_1_sims_PF.m -- Simulates the perfect foresight paths in the Simple Asset Pricing model (Example 1', Supplementary Appendix). Only one solution is found 

OBC_App_1_sims_PF_loop.m -- Plots the policy function in the Simple Asset Pricing model (Example 1', Supplementary Appendix).




OTHER INFO
