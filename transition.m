% This is a function that finds out how many transitions occured and builds
% a matrix that expresses your movement from one place to another as a
% probability, ie row sums are 1

% Assume the data is in two long columns [lat, long] and stacked user on top of user
% Assume you are not missing timepoints and if you are, it's negligibile
%
% clear all
% close all
% clc
% load newfun


function [transprob, fakecdf] = transition(idx, numpoints, users)


% Initialize matrix of transitions
% Rows are the starting matrix, column values are how many transitions to
% other clusters. Ultimately, standardize so that row sums are 1.
numclusters = max(idx);
trans = zeros(numclusters, numclusters);

for i = 1:users
    
    for t = 1:numpoints - 2
        
        c1 = idx(i + (t - 1) * users);
        c2 = idx(i + (t) * users);
        
        trans(c1, c2) = trans(c1, c2) + 1;
    end
end

totals = sum(trans,2);

% Standardize so row sums are 1
transprob = zeros(numclusters, numclusters);
for row = 1:numclusters
    transprob(row,:) = trans(row,:) / totals(row);
end

% Generate fakecdf
fakecdf = zeros(numclusters,numclusters);
for row = 1:numclusters
    for col = 1:numclusters
        if transprob(row, col) ~= 0
            fakecdf(row, col) = sum(transprob(row,1:col));
        end
    end
end

end