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

load timepointlocations

%Start at 4467 -- have 50 users from here one out
%Truncate old data
userids = [1:49 69]';
past = timePntLocs(userids,:,4467:end);
wasInfected = infctStatus(userids,:,4467:end);

%They're massive, get rid of em
clear timePntLocs
clear infctStatus

%Set spread radius
%%% TODO: Have a way of converting meters to GPS
% 0.0001 is about 10m
% http://en.wikipedia.org/wiki/Decimal_degrees
rcrit = 0.0001;

numusers = size(past,1);

mitigate = 0;


guess = 20;
uncertainty = 5;
minimum = guess - uncertainty;
maximum = guess + uncertainty;

rmsr(1:maximum,1) = inf;

simultlength = size(past,3);

[cleanpast, removed] = baddata(past,simultlength,numusers);

disp('reshape data')
coord = [];
for k = 2:size(cleanpast,3)
    coord = [coord ; cleanpast(:,:,k)];
end

coordfull(:,1) = coord(:,2);
coordfull(:,2) = coord(:,1);

%Get the non-NaN values
I = ~isnan(coord);
I = I(:,1);
coord = coord(I,:);

for numclusters = minimum:maximum
    numclusters
    
    %CALL ANALYSIS
    %pass training data and number of clusters
    %return interprob, transprob, start locations
    %TODO are the starting infected people a bdy condition? Probably not,
    %there is a way to set its
    
    [interprob, fakecdf, begin] = analysis(coord, numclusters, numusers, simultlength, rcrit, I, coordfull);
    
    filename = ['simdata' num2str(numclusters)];
    save(filename, 'interprob', 'fakecdf', 'begin');
    
    %CALL SIMULATION
    %pass interprob, fakecdf, start locations, numusers (which you can get
    %from start locations
    %return history -- num infections over time
    
    %     mitigate = 1; %Quarantine
    [history] = simulation(interprob, fakecdf, begin, mitigate);
    
    
    %CALL ERROR FUNCTION
    %pass history and testing set
    %return error
    %save validation(error, num clusters)
    
    %Truncate
    wasInfected = squeeze(wasInfected);
    historyfull = history;
    
    if size(history,2) > size(wasInfected,2)
        history = history(:, 1:size(wasInfected,2));
    else
        wasInfected = wasInfected(:, 1:size(history,2));
    end
    
    
    rmsr(numclusters, 1) = (trace((sum(history) - sum(wasInfected))' *(sum(history) - sum(wasInfected))) / numel(wasInfected)).^(1/2);
    
    if rmsr(numclusters) < min(rmsr)
        optClusters = numclusters;
        save simdata interprob fakecdf begin
    end
    
end