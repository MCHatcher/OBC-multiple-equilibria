# OBC-multiple-equilibria
This repository provides documents and codes for simulating multiple equilibria in otherwise-linear rational expectations with occasionally-binding constraints, under the assumption of perfect foresight. The algorithm is an extension of Guerrieri and Iacoviello (2015,JME) and we utilise some results from Holden (2023,ReStat). A description of the codes and user instructions are provided below.

CODES

Cho_and_Moreno.m -- computes the fixed-structure fundamental rational expectations solution that satisfies the no-bubbles condition (if such a solution exists). This code is used to compute the terminal solution which applies in perpetuity after date T and converges to a steady-state away from the bound.

Cho_Moreno_alternative.m -- alternative algorthm for computing the terminal solution. Triggered automatically if an invertibility condition needed om Cho_and_Moreno.m is not met.

Guesses_double.m -- Code which 
