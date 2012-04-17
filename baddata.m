function past = baddata(past,simultlength,numusers)

for i = 1:simultlength
    
    for j = 1:numusers
        
        if past(j,2,i) >= 40.5 || past(j,2,i) <= 40.2
            past(j,2:3,i) = NaN;
        end
        
        if past(j,3,i) >= -87.5 || past(j,3,i) <= -90
            past(j,2:3,i) = NaN;
        end
    end
end

%Just remove the ones that are not in the Purdue campus. Check google maps