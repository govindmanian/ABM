% This function makes people immune if their infection has run its course
% It's very tiny!

function [infectprob, isInfected] = immunity(time, infectlength, infectprob, isInfected)

for user = 1:size(infectprob,1)
    
    %isInfected(:,2) is the start time of the infection
    if infectlength(user) + isInfected(user,2) < time
        infectprob(user) = 0;
        isInfected(user,:) = 0;
    end
end