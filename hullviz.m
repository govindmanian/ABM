% clear all
% close all
% clc;
% load newfun

function hullviz(idx, coord, clusters)

numclusters = size(clusters,1);

%Initialize now so you can call it in a conditional statement later
hullmat = [];
vecmat = [];


%%%First find the convexhull so you can draw it

for k = 1:numclusters
    %Clear to avoid mismatch later
    points = [];
    
    index = find(idx == k);
    
    points(:,1) = coord(index,1);
    points(:,2) = coord(index,2);
    
    %     iterative loop naming thing
    %     eval(['hull' num2str(k) '= convhull(points(:,1), points(:,2));']);
    
    %%Have to do add a bunch of NaN's because you can't append a column of
    %%different size.
    hull = convhull(points(:,1), points(:,2));
    
    
    %Creates a giant matrix of hulls. Useful for debugging. Not much else,
    %probably.
    %     if k ~= 1 && size(hullmat,1) < size(hull,1)
    %         hullmat((size(hullmat,1) + 1):size(hull,1), :) = NaN;
    %         hullmat = [hullmat hull];
    %     end
    %     if k ~= 1 && size(hullmat,1) > size(hull,1)
    %         hulltemp((size(hull,1) + 1):size(hullmat,1), :) = NaN;
    %         hullmat = [hullmat hulltemp];
    %     end
    
    %Have to reinitialize because of size problems
    vec = [];
    vec(:,1) = points(hull,1);
    vec(:,2) = points(hull,2);
    
    %%Now aggregate
    
    if k ~= 1 && size(vecmat,1) < size(vec,1)
        vecmat((size(vecmat,1) + 1):size(vec,1), :) = NaN;
    end
    if k ~= 1 && size(vecmat,1) > size(vec,1)
        vec((size(vec,1) + 1):size(vecmat,1), :) = NaN;
    end
    
    vecmat = [vecmat vec];
    
end


%%%PLOT


bg = imread('purduemap.png');

% axes for image
min_y = 40.41678;
min_x = -86.930501;
max_y = 40.438766;
max_x = -86.905546;


% disp image
figure;
imagesc([min_x max_x], [min_y max_y], flipdim(bg,1));
hold on;

% Plot the GPS locations and clusters

plot(coord(:,1),coord(:,2),'.')
hold on
%%% TODO label the clusters
plot(clusters(:,1),clusters(:,2),'r*')
title(['GPS location data and ' , num2str(numclusters) , ' clusters'])
xlabel('lat')
ylabel('long')
hold on

% Plot the outside of each cluster

k = 1;
index = ~isnan(vecmat(:,k:k+1));
vectemp = vecmat(1:sum(sum(index,1))/2,k:k+1);

plot(vectemp(:,k),vectemp(:, k+1),'g','linewidth',2)
hold on

% Already did the first cluster
for k = 2:numclusters
    
    index = ~isnan(vecmat(:,2*k - 1:2*k));
    vectemp = vecmat(1:sum(sum(index,1))/2,2*k - 1:2*k);
    
    plot(vectemp(:,1),vectemp(:,2),'g','linewidth',2)
    hold on
end

% flip
set(gca,'ydir','normal');

%TODO Plot transition probabilities, interaction probabilities, etc

end