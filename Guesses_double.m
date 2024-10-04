% Guesses_double, written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own.
% Double spells at the bound. Start date p0, length spell 1 is z0-1, length spell 2 is z1-1. 

%%T_guess = 10;
V_mat = [];

for p0 = 1:T_guess-3

    for z0 = 1:T_guess-3

        for z1 = 1:T_guess-1-(p0+z0) 

            A_mat = ones(T_guess);
        
            for index=1:T_guess-(p0 + z0 + z1)

                A_mat(p0:p0+z0-1,index) = 0;
                A_mat(p0+z0+index:p0+z0+z1-1+index,index) = 0;

            end

        V_mat = [V_mat A_mat];
        s0=sum(V_mat,1); V_mat = V_mat(:,s0 < T_guess);  %Remove columns of all ones

        end

    end

end




