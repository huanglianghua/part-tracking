clc;clear;close all;warning off;

otbPath = 'data/';    % OTB data path

dr = dir(otbPath);
dr = dr(3:end);

for i = 1:length(dr)
    titles{i} = dr(i).name; % fatch all the OTB sequence titles
end

for i = 1:length(titles)
    clc; clearvars -except i otbPath titles; close all;
    title = titles{i};
    if exist([otbPath title],'dir')
        single_tracker(otbPath, title);  % run tracking
    end
end
