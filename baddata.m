% Remove data points that are not in the Purdue campus
% Bottom left 40.417123,-86.933656
% Top left 40.446065,-86.933913
% Bottom right 40.416992,-86.899924
% Top right 40.445379,-86.897993

function [past, removed] = baddata(past,simultlength,numusers)

removed = 0;

past = past(:,2:3,:);

for i = 1:simultlength
    
    for j = 1:numusers
        
        if past(j,1,i) >= 40.5 || past(j,1,i) <= 40.41
            past(j,:,i) = NaN;
            removed = removed + 1;
        end
        
        if past(j,2,i) >= -86.8 || past(j,2,i) <= -86.93
            past(j,:,i) = NaN;
            removed = removed + 1;
        end
    end
end