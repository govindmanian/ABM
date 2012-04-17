% This is a function that calculates the spread of disease
% For each cluster, we partition in-cluster users into infectors and
% resistors
%
% Then, if an infector interacts and infects a resistor, we change
% isInfected at index resistor(j)


function [isInfected] = spread(current, isInfected, infectprob, time, interprob)

interactions(size(current,1),size(current,1)) = 0;

%N.B. no need to check cluster K if K > max(clusters) or K < min(clusters) because no one is
%above or below
for k = min(current):max(current)
    
    index = find(current == k);
    
    %If there are no indices for a cluster k, then it skips to the next
    %iteration
    if isempty(index) == true
        continue
    end
    
    %Make lists of the indices IN THIS CLUSTER that correspond to infectors and resistors
    infector = [];
    resistor = [];
    for i = 1:size(index)
        %%TODO: Can clean this up to reduce the number of lines/operations
        if isInfected(index(i),1) == 1
            infector = [infector ; index(i)];
            %Don't count people that are immune, given by infectprob ~= 0
        elseif infectprob(index(i)) ~= 0 && isInfected(index(i),1) == 0
            resistor = [resistor ; index(i)];
        end
    end
    
    %Use randperm to make sure being at the top of the matrix doesn't
    %mean you get more chances to infect
    
    randomize = randperm(size(infector,1))';
    infector = infector(randomize);
    
    
    for i = 1:size(infector)
        for j = 1:size(resistor)
            
            
            
            %Draw interact from U[0,1]. If it is less than interprob, then the
            %two interact
            
            interact = rand(1);
            
            if interact <= interprob(k)
                
                %Draw p from U[0,1]. Again, if it is less than
                %infectprob then you get spread
                p = rand(1);
                
                if p <= infectprob(index(i))
                    
                    
                    isInfected(resistor(j),1) = 1;
                    isInfected(resistor(j),2) = time;
                    
                    interactions(infector(i), resistor(j)) = 1;
                    
                    %Remove resistor if they are infected so you
                    %don't have double infections
                    
                    continue
                    
                    
                end
            end
        end
    end
end

% filename = [ 'interactions-' num2str(time) '.mat' ];
% save(filename, 'interactions')

end