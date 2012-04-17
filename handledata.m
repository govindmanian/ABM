% coord = function handledata(past)
 
load past

data = past(:,2:3,:);

coord = [];
for k = 2:size(past,3)   
    
    coord = [coord ; past(:,2:3,k)];
    
end