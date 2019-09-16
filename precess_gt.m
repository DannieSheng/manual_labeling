%% Script used to process ground truth, i.e. map with SPICE result
% Author: Hudanyun Sheng
% 08/14/2019
% Department of Electrical and Computer Engineering
% University of Florida
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clc
dbstop if error

thres = 0.6;

dataPath    = 'T:\Box2\Drone Flight Data and Reference Files\Flight Data - All Sites\CLMB STND 2019 Flight Data\100085_2019_07_18_15_54_58\';

hdrPath   = strrep(dataPath, 'T:\Box2\Drone Flight Data and Reference Files\Flight Data - All Sites', 'T:\AnalysisDroneData\ReadableHDR');
hyperPath = strrep(hdrPath, 'ReadableHDR', 'MATdataCube');
gtPath    = strrep(hdrPath, 'ReadableHDR', 'groundTruth');
SPICEpath = strrep(dataPath, 'T:\Box2\Drone Flight Data and Reference Files\Flight Data - All Sites', 'T:\AnalysisDroneData\ReflectanceCube\SPICE');
% SPICEpath = [SPICEpath, '\new'];

process_gtPath = [gtPath, '\gt_processed'];
if ~exist(process_gtPath, 'dir')
    mkdir(process_gtPath)
end

list = dir([gtPath, '*.mat']);
% get the correct order of the files
fileIdx = [];
for ii = 1:length(list)
    tempFile = list(ii).name;
    fileIdx  = [fileIdx str2double(tempFile(isstrprop(tempFile, 'digit')))];
end
[~, idx] = sort(fileIdx);
list = list(idx);
% idx_all = [1:length(list)];
% idx_remove = [1, 3, 6, 9, 12, 18, 24, 30, 36, 40, 42];
% idx_keep = setdiff(idx_all, idx_remove);
% list = list(idx_keep);

for iFile = 14:length(list)
    fileName          = list(iFile).name;
    % load ground truth
    load(fullfile(gtPath, fileName)) %gt
    gt_map = zeros(size(gt));
    gt_map(find(gt>0)) = 1;

    % load (aggregated) SPICE result
    SPICEname = strrep(fileName, 'ground_truth', 'raw');
    SPICEname = strrep(SPICEname, '.mat', '_rd_rf_aggre.mat');
    load(fullfile(SPICEpath, SPICEname)) %final
    figure, imagesc(final), axis image
    temp = final.*gt_map;

    SPICEmap = zeros(size(temp));
    SPICEmap(find(temp>=thres)) = 1;
    figure, imagesc(SPICEmap)
    
    gt_final = SPICEmap.*gt;
    save(fullfile(process_gtPath, fileName), 'gt_final')
    figure, imagesc(gt_final), caxis([0,6]), colorbar
    axis image
    axis off
    saveas(gcf, fullfile(process_gtPath, strrep(fileName, '.mat', '.jpg')), 'jpg')    
end