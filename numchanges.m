clear all
close all
clc

load past

changes = zeros(size(past,1),1);

for i = 2:size(past,3)
    
    for j = 1:size(past,1)
        
        if past(j,1,i) ~= past(j,1,i - 1)
            
            changes(j) = changes(j) + 1;
        end
        
        if past(j,1, i - 1) == 0
           begin(j,1) = i;
        end
    end   
end

for k = 1:max(begin)
    
    numgreater(k) = size(find(begin<k),1);
end