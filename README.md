# OBC-multiple-equilibria
This repository provides documents and codes for simulating multiple equilibria in otherwise-linear perfect foresight models with occasionally-binding constraints. The algorithm is an extension of Guerrieri and Iacoviello (2015,JME) and we utilise some results from Holden (2023,ReStat). A description of the codes and user instructions are provided below. It is convenient to view the file using e.g. MS Word.

NOTE: The bounded variable is assumed to be ordered first in the vector of variables x(t) (see paper) and exogenous variables are assumed to be ordered last in the vector x(t), i.e. the last nx rows.

------------
MAIN CODES
------------
Cho_and_Moreno.m -- Computes the fixed-structure fundamental rational expectations solution that satisfies the no-bubbles condition (if such a solution exists). This code is used to compute the terminal solution which applies in perpetuity after date T and converges to a steady-state away from the bound. (Other rational expectations algorithms could be used instead, provided the solution matrices are in the same format.)

Cho_Moreno_alternative.m -- Alternative algorthm for computing the terminal solution. Triggered automatically if an invertibility condition needed om Cho_and_Moreno.m is not met. 

Guesses_single.m -- Code which enumerates single spells at the bound starting at for a given T_guess. Note that we consider sequences that end in 1 (i.e. last row entry is set at 1) for convenience.

Guesses_double.m -- Code which enumerates double spells at the bound (given by zeros) for a given T_guess. Note that we consider sequences that end in 1 (i.e. last row entry is set at 1) for convenience.

Guesses_triple_loop.m -- Code which enumerates triple spells at the bound (given by zeros), for a given T_guess, using a loop (e.g. n_loop_l = [2 5]) where l indexes the length of the third spell at the bound. Note that we consider sequences that end in 1 (i.e. last row entry is set at 1) for convenience.

Guesses_master.m -- Based on the Guesses_....m files commented in by the user, this code generates a stacked matrix of guesses to be used as potential structures (sequence of regimes). If the number of guesses generated falls short of the N_guess specified by the user, then the excess guesses (columns) are random guesses of 0s and 1s (set Message_2=1); if the number of guesess generated exceeds N_guess, the excess columns are ignored (set Message_1=1). In both cases, the user is informed of the result; see the file Print.m below.   

Guesses_master_2.m -- Same as Guesses_master.m, but has more of Guesses_....m files 'commented in' (for convenience). 

M_matrix.m -- Computes the M matrix of impulse responses (see Holden,2023) for a model with structure defined in the Insert_....m files. The resulting matrix can then be used in P_matrix.m to determine whether the M matrix has the P-matrix property.

PF_insert.m -- Guess-verify part of the algorithm. A 'break' command near the end (around line 100) is used to prevent additional guesses being made if M is a P-matrix and a solution has been found. 

Pos_Def.m -- Checks if the M-matrix is general positive definite. If so, is_pd = 1 and M is a P-matrix (Holden 2023, Lemma 1 Part 2), so we set not_P=0. In this case, P-matrix below does not need to use ptest or ptest3.

P_matrix.m -- Script to determine if M is a P-matrix. Uses ptest.m and ptest3.m written by Michael Tsatsomeros (see the MATLAB depot at https://www.math.wsu.edu/faculty/tsat/matlab.html). ptest3 is currently used because this is faster. If M is a P-matrix, then not_P = 0. If M is not a P-matrix, then not_P=1.

ptest.m and ptest3.m -- Functions written by Michael Tsatsomeros (see the MATLAB depot at https://www.math.wsu.edu/faculty/tsat/matlab.html) that determine whether a given square matrix is a P-matrix. 

Select_solution.m -- Uses Remark 1 in the paper to select a solution (when there are mutliple solutions). In the code, k represents the number of solutions.

Solutions_insert.m -- Determines the number of solutions and presents them in a cleaner form. If exogenous variables are present, they are reported in the solutions matrix only once and are listed last (Line 34).

Print.m -- Tells the user whether or not M is a P-matrix and whether the number of guesses generated by Guesses_master.m (or Guesses_master_PF.m) falls short of, or exceeds, the number of guesses specified by the user. 

--------------------
CODES FOR EXAMPLES
--------------------
Insert_App_1.m -- Specifies the calibration and matrices of the different regimes (slack and bind) in the Simple Asset Pricing Model in Iacoviello and Guerrieri (2015,JME). This file is used in the OBC_App_1_...m files (see below) and some results are reported in Example 1' (Supplementary Appendix to the paper). 

Insert_App_2.m -- Specifies the calibration and matrices of the different regimes (slack and bind) in the Policy Application in the paper (Section 4). Case of inflation targeting interest rate rule, potentially with interest rate smoothing.

Insert_App_2_PLT.m -- Same as Insert_App_2.m but for the case of a price-level targeting interest rate rule. An additional variable enters, namely the log price level.

Insert_App_2_FG.m -- Same as Insert_App_2.m but for the case of forward guidance. Dimension of matrix B4 differs (n x 2 not n x 1) because of forward guidance news shocks in the monetary policy rule. 

Insert_App_2_loop.m -- Same as Insert_App_2.m but with some parameters commented out for analysis of M matrix at different parameter values. The parameter combinations are set in the OBC_App_2_M_matrix file (see below).

Insert_App_2_loop_PLT.m -- Same as Insert_App_2_loop.m but for the case of the price-level targeting rule.

Insert_Example_2.m -- Specifies the calibration and matrices of the different regimes (slack and bind) in the Fisherian model (Section 2.4, Example 1 and Example 2 in the paper).

Insert_RBC.m -- Specifies the calibration and matrices of the different regimes (slack and bind) in the Real Business Cycle model in Iacoviello and Guerrieri (2015,JME). This file is used in the OBC_RBC_sims...m files (see below) and some results are reported in Example 2' (Supplementary Appendix to the paper). 

Insert_Samuelson.m -- Specifies the calibration and matrices of the different regimes (slack and bind) in the Endogenous Business Cycle model in Example 3' (Supplementary Appendix to the paper). This file is used in the OBC_App_3_sims_PF.m file which simulates the perfect forsight path(s) for given initial conditions.

OBC_App_1_sims_PF.m -- Simulates the perfect foresight paths in the Simple Asset Pricing model (Example 1', Supplementary Appendix). Only one solution is found and M is found to be a P-matrix.

OBC_App_1_sims_PF_loop.m -- Plots the policy function in the Simple Asset Pricing model (Example 1', Supplementary Appendix). Note there is one policy function (M was found to be positive definite, hence a P-matrix). 

OBC_App_2_M_matrix.m -- Plots the regions (parameter combinations) for which M is (white) and is not (black) a P-matrix in the Policy Application in Section 4 of the paper. 

OBC_App_2_sims_PF.m -- Simulates the perfect foresight paths in the Policy Application (New Keynesian model) for the case of inflation targeting or price-level targeting rules with or without interest rate smoothing.

OBC_App_2_sims_PF_Loss.m -- Uses OBC_App_2_sims_PF.m to compute welfare loss under Solution 1 (good) and Solution 2 (bad) and the expected loss in the Policy Application (New Keynesian model).

OBC_App_2_sims_PF_FG.m -- Simulates the perfect foresight paths in the Policy Application (New Keynesian model) for the case of forward guidance for which the vector of news shocks is 2 x 1.

OBC_App_2_sims_PF_FG_Loss.m -- Uses OBC_App_2_sims_PF_FG.m to compute welfare loss under Solution 1 (good) and Solution 2 (bad) and the expected loss in the Policy Application (New Keynesian model).

OBC_App_2_sims_PF_FG_loop.m -- Runs a loop using OBC_App_2_sims_PF_FG.m and counts how many cases out of 800 have multiple solutions and the length of spells at the bound (bad solution); see Table 1 of the paper.

OBC_App_3_sims_PF -- Simulates the perfect foresight paths in the Endogenous Business Cycle model (Example 3' in the Supplementary Appendix).

OBC_Example_1.m -- Simulates the perfect foresight paths in the Fisherian model (Section 2.4, Example 1 and Example 2 in the paper). 

OBC_Example_1_Expected_Loss.m -- Uses OBC_Example_1.m to compute the losses under Solution 1 (good) and Solution 2 (bad) in the Fisherian model (Section 2.4, Example 1 and Example 2 in the paper). The expected loss is then computed for many values of p_1, the probability of Solution 1, and plotted (see left panel of Figure 2), which appears in Example 1 of the paper.

OBC_Example_1_Expected_Loss_loop.m -- Similar to OBC_Example_1_Expected_Loss.m, but the expected loss E[L]-L_1 in the Fisherian model is computed for many initial inflation rates. This code is used to produce the right panel of Figure 2, which appears in Example 1 of the paper.

OBC_Example_2.m -- Simulates the perfect foresight paths in the Fisherian model (Section 2.4, Example 1 and Example 2 in the paper) using our Algorithm, rather than the 'by hand' approach in OBC_Example_1.m. 

OBC_Example_2_stoch_sims.m -- Simulates the stochastic simulation paths in Figure 3 (Fisherian model), which appear in Example 2 of the paper.

OBC_Example_2_stoch_sims_2.m -- Similar to OBC_Example_2_stoch_sims.m, but gives an example where the 'flat priors' rule is used to assign probabilities (see Section 3.3 of the paper).

OBC_RBC_sims_PF.m -- Simulates the perfect foresight paths in the Real Business Cycle model (Example 2' in the Supplementary Appendix). Only one solution is found and M is found to be a P-matrix.  

OBC_RBC_sims_PF_LOOP.m -- Uses OBC_RBC_sims_PF.m to compute the policy functions at many different shock sizes.

Solutions_insert_App_2.m -- Version of Solution_insert.m adapted to the New Keynesian model (Policy Application). Because we use the unique(.) function, and i(t) = i*(t) when the contraint is slack, i*(t) will be removed. T prevent this we add small amount 'noise' to the last simulated point to distinguish the two series. 

Solutions_insert_App_2_loop -- Similar to Solutions_insert_App_2.m, but is used in the forward guidance loop in the OBC_App_2_sims_PF_FG_loop.m file (see above). 

-------------
MAIN INPUTS
-------------
T_guess -- Guess on the date T from which the terminal solution applies. A subsequent line of code sets T_guess = max(T_guess,3) for convenience when forming the guesses matrix (see below).

T_sim -- Simulation length for perfect foresight paths. A subsequent line of code sets T_sim = max(T_sim,T_guess + 30), i.e. T_guess + 30 is a lower bound because we would like to check whether the solution is away from the bound for all t>T. Using much larger values for T_sim will be appropriate if the latter is in doubt. 

T_news -- Last date at which news shocks are non-zero.

nat_num, N_guess -- A line of code sets N_guess = nat_num*T_guess, where nat_num should be a positive integer. Multiplying by T_guess can make the interpretation of the 'guesses matrix' simpler, but is not essential. For example, if nat_num = 1, the guess matrix will be populated with all single spells at the bound consistent with T_guess. We consider sequences that end in 1 (i.e. last row entry is set at 1) for convenience. 

nvar = length(B1(:,1)) -- Determines the number of variables in the vector x(t) (see paper).

nx -- Number of exogenous variables, must be set by the user. An example is a autoregressive variable subject to news shocks, e.g. productivity in the Real Business Cycle model example.

n_loop_l -- Vectors which specifies lengths of the final spell at bound to be considered when generating guesses using the code Guesses_triple_loop.m. 

X_init -- Vector of initial values x(0) for perfect foresight simulations. 

e_vec -- Matrix of news shocks of dimension m x 1 set by the user, where m is the number of distinct shocks.

--------------
MAIN OBJECTS
--------------
V_0 = tril(ones(T_guess)) gives slack case in Col. 1 and all single spells starting at date 1 in the remaining columns (see Guesses_master.m and Guesses_master_2.m). 

Omega_bar, Gama_bar, Psi_bar -- Solution matrices of the fixed-structure terminal solution.

Omeg_t, Gama_t, Psi_t -- 3-D arrays that store the time-varying matrices under each solution at each t.

ind_stack -- Matrices of all guessed sequences of structures.

ind_sol -- Matrix to store the verified guesses on the indicator variable.

mstar -- Vector to store the index of those guesses which are solutions.

Verify -- Note that Verify(t) = 1 only the guess at date t is verfied, so a guessed sequence of regimes is verified only if sum(Verify) = T_sim-1 (see PF_insert.m, Line 93). 

X_sol -- Matrix for storing the solutions x(t) for t=1:T_sim-1, including any exogenous variables.

X_sol_exc -- Matrix for storing the solutions x(t) for t=1:T_sim-1, excluding any exogenous variables.

X_star_sol -- -- Matrix for storing the path of shadow variable for each verified sequence of structures.

-------------
MAIN OUTPUTS
-------------
k -- Number of solutions found by the algorithm. If M is not a P-matrix (not_P=1), it is advisable to increase N_guess to see if multiple solutions are found. 

mstar -- Lists those guess numbers which correspond to solutions.

ind_fin -- Matrix storing all sequences of the indicator variable that are consistent with solutions (i.e. all unique verified guesses on the indicator).

x_fin -- Matrix storing all solutions in order by columns, i.e. x(t,sol_1) (first n-nx rows), x(t,sol_2) (next n-nx rows), ...,x(t,sol_k) (kth n-nx rows, followed by paths of nx exogenous vars, final nx rows).  

not_P -- Equal to 1 if M is not a P-matrix and equal to 0 if M is a P-matrix.





