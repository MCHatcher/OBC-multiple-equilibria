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

Guesses_triple_loop.m -- Allows uses to run a loop (for l=1:n_loop, where n_loop is user specified) and where l indexes the length of the third spell. Note that we consider sequences that end in 1 (i.e. last row entry is set at 1) for convenience.

Guesses_master.m -- Based on the Guesses_....m files commented in by the user, this code generates a stacked matrix of guesses to be used as potential structures (sequence of regimes). Note that if the number of guesses generated this way falls short of the N_guess specified by the user, then the excess guesses (columns) are random guesses of 0s and 1s. 

Guesses_master_FG.m -- Same as Guesses_master.m, but is convenient to have a file with more of Guesses_....m files 'commented in'. 

Insert_App_1.m -- Specified the matrices of the different regimes (slack and bind) in the Simple Asset Pricing Model in Iacoviello and Guerrieri (2015,JME). This is used in the OBC_App_1_...m files (see below) and some results are reported in Example 1' (Supplementary Appendix to the paper). 



OTHER INFO
