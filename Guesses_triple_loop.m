% Guesses_triple_l, written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.
% Triple spells at the bound ending with a 3-spell. Start date p0, length spell 1 is z0-1; length spell 2 is z1-1; spell 3, length l.
% Note that n_loop_l is set in a separate loop file in Guesses_master_FG (needs to be commented in).

%%T_guess = 10;
V_mat = []; 

for l=n_loop_l    

    %Loop over length of final spell

    for p0 = 1:T_guess-5

        for z0 = 1:T_guess-5

            for z1 = 1:T_guess-3-(p0+z0) 

                for gap = 1:T_guess-2-(p0+z0+z1)-(l-1)

                    A_mat = ones(T_guess);

                    for index=1:T_guess-(p0+z0+z1+gap)-3
                        A_mat(p0:p0+z0-1,index) = 0;
                        A_mat(p0+z0+index:p0+z0+z1-1+index,index) = 0;
                        A_mat(p0+z0+z1+gap+index:p0+z0+z1+gap+index+l-1,index) = 0;
                    end

                    V_mat = [V_mat A_mat];
                    s0=sum(V_mat,1); V_mat = V_mat(:,s0 < T_guess);  %Remove columns of all ones

                end


            end

        end

    end

end




