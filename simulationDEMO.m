clear all
close all
clc
load simdata
mitigate = 0;

tic

numusers = size(begin,1);

current = begin;

% infectprob is called once and instantiates the different infectious
% levels
% A value equal to 0 is functionally equivalent to immunity

infectprob = normrnd(0.9,0.01,numusers,1);
infectlength = abs(round(normrnd(2, 1, numusers, 1) * 24 * 60));


%Make it ten percent of people get infected
isInfected(:,1) = rand(numusers,1);
for i = 1:size(isInfected(:,1),1)
    if isInfected(i,1) > 0.9
        isInfected(i,1) = 1;
    else
        isInfected(i,1) = 0;
    end
end

if sum(isInfected) == 0
    disp('No one is infected')
    return
end

isInfected(:,2) = 0;

%Trial length in days * hours * minutes
theend = 14 * 24 * 60;

%Keep a running log of who infected who
interactions = zeros(numusers,numusers);

save interactions-1 interactions

history(:, 1) = isInfected(:,1);

for time = 2:theend
    time
    
    %Find out who is infected
    %N.B. this does not use resistance as of now
    [isInfected, infectprob] = spread(current, isInfected, infectprob, time, interprob, mitigate);    
    
    %Keeps a running log of who is infected at each time
    history(:, time) = isInfected(:,1);
    sum(history(:,time))
    
    
%     if sum(history(:,time)) - sum(history(:,time - 1)) > 0
%        sum(history(:,time))
%        pause
%     end
        
    
    if sum(history(:,time)) == 0
        disp('No one is infected')
        break
    end
    
    %See if anyone's infection is over and they are now immune
    [infectprob, isInfected] = immunity(time, infectlength, infectprob, isInfected);
    
    %Update locations
    current = getnewloc(current, fakecdf);
    
end

plot(sum(history))
title('Number of Infected Users over time')
ylabel('Number of infections')
xlabel('Time steps')

toc