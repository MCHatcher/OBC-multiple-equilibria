%Guesses_master, written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.

V_0 = tril(ones(T_guess));   %Spells starting from date 1. Note: V_0(:,1) --> slack in all periods.
V_mat = []; Message_1 = []; Message_2 = [];

run Guesses_single,  V_1 = V_mat;  V_mat = V_1;  %Single spells at the bound
run Guesses_double, V_2 = [V_1 V_mat];  V_mat = V_2;   %Uncomment as necessary
%%n_loop_l = [1:2]; run Guesses_triple_loop, V_3 = [V_2 V_mat];  V_mat = V_3;   %Uncomment as necessary

V_mat = unique(V_mat.', 'rows').';
if isempty(V_mat)
    ind_stack(:,1:T_guess) = V_0;
elseif  size(V_mat,2) >= N_guess-T_guess
    ind_stack = [V_0 V_mat(:,1:N_guess-T_guess)];
    Message_1 = 1; d0 = size([V_0 V_mat],2);
else
    ind_stack = [V_0 V_mat ind_stack(:,size(V_mat,2)+T_guess+1:end)];
    Message_2 = 1; d0 = size([V_0 V_mat],2); 
end

