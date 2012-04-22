% This is a function that finds the likelihood of interaction within a
% cluster as a scalar quality
% Take the total number of points in a cluster and find the number of
% interactions
%
% clear all
% clc
% close all
% 
% load interdata %idxfull coordfull numpoints numusers rcrit
% idx = idxfull;
% coord = coordfull;

function [interprob] = interactions(idx, coord, numpoints, numusers, rcrit)

numclusters = max(idx);

possible = zeros(numclusters,1);
actual = zeros(numclusters,1);

for t = 1:numpoints - 2
    
    %Generate times, periodic over users, each user gets picked once
    timemat = [1 + t * numusers : numusers + t * numusers];
    
    tcluster(:,1) = idx(timemat);
    points(:,:) = coord(timemat,:);
    
    %%% Find all coordinates for each cluster, then compute inter-cluster
    %%% pairs based on spread radius rcrit
    
    for k = 1:numclusters
        
        %Get the indicies of cluster k
        index = find(tcluster == k);
        
        %Skips iteration if index is empty
        if isempty(index) == 1
            continue
        end
        
        %Get the points in this cluster.
        candidates = points(index,:);
        m = size(candidates,1);        
        
        
        %See how many interactions could have happened - handshake problem!
        %Sum over all times
        possible(k,1) = (m * (m - 1)) / 2 + possible(k,1);
        %         indicies(k,t) = length(index);       
            
        
        %Compare
        for u = 1:(m - 1)
            for v = (u + 1):m
                
                if isnan(candidates(u,1)) + isnan(candidates(v,1)) == 0
                    
                    if rcrit >= sqrt((candidates(u,1) - candidates(v,1))^2 + (candidates(u,2) - candidates(v,2))^2)
                        actual(k,1) = actual(k,1) + 1;
                    end
                end
            end
        end
    end
    
    
    interprob = actual ./ possible;
    
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%This is some code written to try and improve the efficiency.
%%%It's not running properly, so we'll come back to this later if
%%%need be
%
%         %Sort them based on latitude, ascending
%         candidates = sortrows(candidates);
%
%
%         %Check pairs of users (u, v)
%         %Don't take the last user as u
%
%         for u = 1:size(candidates,1) - 1
%
%             %Initialize lowerbdd so you don't run into trouble when making
%             %assignments
%             lowerbdd = 0;
%
%             %Want to take the next (numusers - u) users and compare it to v
%             %This includes the last one
%
%             %Take advantage of the fact that values are sorted
%             %ascending by the first column and search down.
%             %The loop goes down, so you don't need to search up, because
%             %you've already made the comparison on a previous u
%
%
%             %Start with u + 1, you don't want to compare to yourself
%             for v = u + 1:size(candidates,1)
%
%                 %Move down and find the lower bound.
%
%                 if candidates(v,1) <= candidates(u,1) + rcrit
%                     lowerbdd = v;
%                 else
%                     break
%                 end
%             end
%
%
%             %Now do it again, this time searching over the second column
%             %Start with u + 1 -- you don't want to compare to yourself
%
%             %This is a subset for each user u. Make it a different array so you
%             %don't have to redraw from the main array
%
%             %Skips if no change in lowerbdd
%             if lowerbdd == 0
%                 subsetwasempty(k,t) = 1;
%                 continue
%             end
%
%             subset = candidates(u : lowerbdd,:);
%
%             %Now sort based on the second column
%             subset = sortrows(subset,2);
%
%             [seedi, ~] = find(subset(:,1) == candidates(u,1) & subset(:,2) == candidates(u,2));
%
%             if size(seedi,1) > 1
%                 multiple = multiple + 1
%             end
%
%             seedi = min(seedi);
%
%
%             %%Search up then search down
%
%             upperbdd = seedi;
%             if seedi ~= 1
%                 for v = 1:seedi - 1 %Don't want to compare to yourself
%
%                     if subset(seedi - (v - 1),2) <= candidates(u,2) - rcrit
%                         upperbdd = v;
%                     else
%                         break
%                     end
%
%                 end
%             end
%
%
%             %Reinitilize lowerbdd
%             lowerbdd = seedi;
%
%             if seedi ~= size(subset,1)
%                 for v = seedi + 1:size(subset,1)
%
%                     %Move down and find the lower bound. Make sure you don't go out
%                     %of bounds on the bottom.
%                     if subset(v,2) <= candidates(u,2) + rcrit
%                         lowerbdd = v;
%                     else
%                         webrokesecond = 2;
%                         break
%                     end
%                 end
%             end
%
%             %In band, outside of square, pass to next u
%             %If no change from seedi (current location we are comparing to)
%             %then go to the next u
%             if lowerbdd == seedi && upperbdd == seedi
%                 squarewasempty(k,t) = 1;
%                 continue
%             end
%
%             insquare = subset(upperbdd:lowerbdd, :);
%
%             %             Now you have a small subset of things. Go compare = O
%             for p = 1:size(insquare,1)
%
%                 %Within critical radius
%
%                 if rcrit >= sqrt((candidates(u,1) - insquare(p,1))^2 + (candidates(u,2) - insquare(p,2))^2)
%                     actual(k) = actual(k) + 1;
%                 end
%
%             end
%
%             actual(k) = actual(k) - 1; %subtract for when you compared to yourself
%         end
%     end
%
%
%     interprob = actual ./ possible;