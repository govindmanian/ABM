function [interprob, fakecdf, begin] =  analysis(coord,numclusters,numusers,numpoints,rcrit)

tic

% This program calls all the other functions for data analysis
% First take care of creating or cleaning data
% Then perform k-means clustering
% Then find transition probabilities between clusters
% Finally find interaction probabilities


%%% We don't have any data, so create some from Vince's data
%%% TODO This will have to change when you get real data
% numusers = 70;
% disp('create data')
% [coord, numpoints] = createdata(numusers);


%%%Run k-means on it and see what happens
%%%TODO: Cross validation over a few k's -- basically, look at data, get
%%%some a priori feeling, and then add clusters. May have to do some 'init'
%%%magic to make sure it puts clusters where we want and the additional
%%%clusters aren't "stolen" by high-density areas

% numclusters = 20;
disp('do kmeans')
[idx, clusters, ~, ~] = kmeans(coord, numclusters);

%Find transition probabilities
% function transprob = transition(idx, numpoints, users)
disp('find transition probabilities')
[~, fakecdf] = transition(idx, numpoints, numusers);

save interactdata idx coord numpoints numusers rcrit
return

%Find interaction probabilities
% function [interprob] = interactions(idx, coord, numpoints, numusers, rcrit)
disp('find interprob')
interprob = interactions(idx, coord, numpoints, numusers, rcrit);

%Find out what clusters the first time-points are in

begin = idx(1:numusers,1);


%Do the visualization!
% function hullviz(idx, coord, clusters)
%%TODO: AXES COULD BE WRONG
disp('visualize')
hullviz(idx, coord, clusters)
%%

% save analysis coord clusters idx D numpoints numusers rcrit fakecdf interprob

toc

end