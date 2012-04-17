close all
clear all
clc

% This function handles everything
% Training set data runs through the analysis
% Analysis results are passed to simulation
% Simulation passes back the history for this particular cluster
% RMSR is calculated and saved

%%AN AREA FOR EXPASION IS TO USE SOMETHING LIKE HIERARCHICAL CLUSTERING AND
%%GO NUTS WITH CHECKING WHICH IS THE BEST. MAY NOT WORK -- O(n^3)?
%%For now, this just uses one (geographic) combination of clusters for each
%%number of clusters

load past

%Set spread radius
%%% TODO: Have a way of converting meters to GPS
% 0.0001 is about 10m
% http://en.wikipedia.org/wiki/Decimal_degrees
rcrit = 0.0001;

numusers = size(past,1);

guess = 20;
uncertainty = 0;

minimum = guess - uncertainty;
maximum = guess + uncertainty;

simultlength = size(past,3);
% infectduration = ;

cleanpast = baddata(past,simultlength,numusers);

disp('reshape data')
coord = [];
for k = 2:size(cleanpast,3)
    coord = [coord ; cleanpast(:,2:3,k)];
end


for numclusters = minimum:maximum
    
    %CALL ANALYSIS
    %pass training data and number of clusters
    %return interprob, transprob, start locations
    %TODO are the starting infected people a bdy condition? Probably not,
    %there is a way to set its
    
    [interprob, fakecdf, begin] = analysis(coord, numclusters, numusers, simultlength, rcrit);
    
    %CALL SIMULATION
    %pass interprob, fakecdf, start locations, numusers (which you can get
    %from start locations
    %return history -- num infections over time
    
    [history] = simulation(interprob, fakecdf, begin);
    
    
    %CALL ERROR FUNCTION
    %pass history and testing set
    %return error
    %save validation(error, num clusters)
    
%     rmsr(numclusters) = (trace((trhistory - testing)' *(trhistory - testing)) / numel(testing)).^(1/2);
    
    
end