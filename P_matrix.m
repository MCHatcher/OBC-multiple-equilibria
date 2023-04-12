%Script to determine if M is a P-matrix. %Uses ptest.m written by Michael
%Tsatsomeros (https://www.math.wsu.edu/faculty/tsat/matlab.html). The code can also be used with ptest3.m, by the same author.
%Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). Any errors are my own. Last updated: 12/04/2023.

run Pos_Def.m

if not_P == 0 && is_pd == 0       
    
    if ptest(M)==0  
        not_P = 1;
    end
    
    %if ptest3(M)==0  
    %    not_P = 1;
    %end

end




    