% This is a function that updates the location
% It takes a "fake cdf" and then compares this to a random number to see
% what cluster each user moves to. You can think of this as taking the line
% 0 to 1 and partitioning it into k (nonzero) intervals. Then each cluster with
% nonzero probability gets a piece according to its probility. We generate
% a random number from U[0,1] and map it to each one of these pieces in the
% obvious way.


function current = getnewloc(current, fakecdf)

newloc = zeros(size(current,1), 1);

for i = 1:size(current,1)
    num = rand(1);
    indices = find(fakecdf(current(i),:) > num);
    newloc(i) = min(indices);
end

current = newloc;

end