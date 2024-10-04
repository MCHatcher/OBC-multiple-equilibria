% Guesses_single, written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.
% Single spells at the bound, date 2 onwards. Spell length controlled by index. Start date is p0. 

%%T_guess = 10;
V_mat = [];

for p0 = 2:T_guess-1
    A_mat = ones(T_guess);

    for index=1:T_guess-p0 
        A_mat(p0:p0+index-1,index) = 0;
    end

    V_mat = [V_mat A_mat];
    s0=sum(V_mat,1); V_mat = V_mat(:,s0 < T_guess);  %Remove columns of all ones

end


