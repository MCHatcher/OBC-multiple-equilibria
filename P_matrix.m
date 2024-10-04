%Script to determine if M is a P-matrix. %Uses ptest.m and ptest3.m written by Michael Tsatsomeros 
%(see the MATLAB depot at https://www.math.wsu.edu/faculty/tsat/matlab.html). 
%This script is written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own. Last updated: 12/04/2023.

run Pos_Def.m

if not_P ~=1 && is_pd == 0   

    %ptest_val = ptest(M);
    ptest_val = ptest3(M);  %faster version
    
    if ptest_val==0  
        not_P = 1;
    else
        not_P = 0;
    end

end




    