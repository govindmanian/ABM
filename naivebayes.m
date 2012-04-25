% function [predictInfected] = naivebayes(numusers, numfeatures, simultlength, wasInfected, idxfull)

clear all
close all
clc

load timepointlocations
load hvdemodata

%Start at 4467 -- have 50 users from here one out
%Truncate old data
userids = [1:46]';
past = timePntLocs(userids,:,4467:end);
wasInfected = infctStatus(userids,:,4467:end);
numusers = size(past,1);
simultlength = size(past,3);

idx = idxfull;
Y = squeeze(wasInfected);
Y = sum(Y,2);
index = find(Y > 0);
Y(index) = 1;

numclusters = max(idxfull);

%They're massive, get rid of em
clear timePntLocs
clear infctStatus
clear idxfull
clear past

numfeatures = 5;


%Naive Bayes Classifier
%Put features in rows and instances in columns
%Being infected = 1
%Classifier rule: look at the top five clusters were people were infected

infectloc = zeros(numclusters,1);

for t = 1:100
    t
    
    for i = 1:numusers
        
        if t == 1
            delta = wasInfected(i, t);
            
            if delta == 1
                k = idx(i);
                if k ~=0
                    infectloc(k) = infectloc(k) + 1;
                end
            end
            
        else
            
            delta = wasInfected(i, t) - wasInfected(i, t - 1);
            if delta == 1
                k = idx(numusers * (t - 1) + i);
                if k ~= 0
                    infectloc(k) = infectloc(k) + 1;
                end
            end
            
        end
    end
    
    %Get the top n clusters in terms of number of interactions
    [~,index] = sort(infectloc,'descend');
    index = index(1:numfeatures);
    X = zeros(numfeatures,size(wasInfected,1));
    
    for i = 1:numfeatures
        users = find(idx == index(i));
        users = mod(mod(users(1:1000),simultlength),numusers) + 1;
        X(:,users) = 1;
    end
end

newfeat = randi(2,5,46) - 1;

posterior = [];
prior = [];

%pmf
pmf = sum(Y) / size(Y,1);
pmf_c = sum(1 - Y) / size(Y,1);

%Calculate prior
prior_i = X * Y / sum(Y);

for p = 1:size(newfeat,2)
    
    x = newfeat(:,p);
    
    newprior = prod(prior_i .^x .* (1 - prior_i).^(1 - x));
    prior = [prior newprior];
    
    %Posterior
    newpost = (prior * pmf) / (pmf + pmf_c);
    posterior = [posterior newpost];
    
end


for i = 1:size(wasInfected,1)
    %Train on the classification value after you have a feature set
    if posterior(i) > .5
        predictInfected(i) = 1;
    end
end

