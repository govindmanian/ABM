clc
close all
clear all

tic

maxtime = 7426;

for i = 1:maxtime
    i
    
    filename = ['interactions-' num2str(i) '.mat'];
    load(filename)
    
    alltime(:,:,i) = interactions;
end

toc