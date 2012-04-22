function [interprob, fakecdf, begin] =  analysis(coord,numclusters,numusers,numpoints,rcrit,I,coordfull)

% clear all
% close all
% clc
% load coord
% coordfull = coord;
% rcrit = 0.0001;
% numclusters = 20;
% load past
% numusers = size(past,1);
% numpoints = size(past,3);
% clear past
% % Get the non-NaN values
% I = ~isnan(coord);
% I = I(:,1);
% coord = coord(I,:);

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

disp('do kmeans')
[idx, clusters, ~, ~] = kmeans(coord, numclusters, 'EmptyAction', 'singleton');

if sum(sum(isnan(clusters)))~=0
    disp('NAN CLUSTER')
end

%Transition probabilities are really tricky if you don't have period data
%to take advantage of, so repopulate all the bad data points with 0's for
%the clusters and then ignore the 0th cluster in transition.m
idxfull = zeros(size(coord,1),1);
count = 1;
for i = 1:size(I,1)
    if I(i) ~= 0
        idxfull(i) = idx(count);
        count = count + 1;
    end    
end

%Find transition probabilities
% function transprob = transition(idx, numpoints, users)
disp('find transition probabilities')

[~, fakecdf] = transition(idxfull, numpoints, numusers);

save interdata idxfull coordfull numpoints numusers rcrit clusters

%Find interaction probabilities
% function [interprob] = interactions(idx, coord, numpoints, numusers, rcrit)
disp('find interprob')
interprob = interactions(idxfull, coordfull, numpoints, numusers, rcrit);

%Find out what clusters the first time-points are in

begin = idxfull(1:numusers,1);


%Do the visualization!
% function hullviz(idx, coord, clusters)
%%TODO: AXES COULD BE WRONG
disp('visualize')
hullviz(idxfull, coordfull, clusters)


% save analysis coord clusters idx D numpoints numusers rcrit fakecdf interprob

toc

end