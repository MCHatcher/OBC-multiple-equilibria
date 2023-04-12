function [r] = ptest3(M)

% Written by Michael Tsatsomeros
% (https://www.math.wsu.edu/faculty/tsat/matlab.html)
% Return r=1 if ‘M’ is a P-matrix, r=0 otherwise.

n = length(M);
if ~(M(1,1)>0), r = 0;
elseif n==1, r = 1;   
else
   b = M(2:n,2:n);
   d = M(2:n,1)/M(1,1);
   c = b - d*M(1,2:n);  
   r = ptest3(b) & ptest3(c);
end

