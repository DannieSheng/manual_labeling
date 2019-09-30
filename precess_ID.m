%% Script used to process plot ID
% Author: Hudanyun Sheng
% 09/23/2019
% Department of Electrical and Computer Engineering
% University of Florida
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clc
dbstop if error

idPath = 'T:\AnalysisDroneData\groundTruth\CLMB STND 2019 Flight Data\100081_2019_06_11_17_57_06\';
gtPath = [idPath 'gt_processed\'];
processed_idPath = [idPath 'id_processed\'];
if ~exist(processed_idPath, 'dir')
    mkdir(processed_idPath)
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

for iFile = 1:length(list)
    fileName          = list(iFile).name;
    load([gtPath, fileName]) %gt_final
    gt_map = zeros(size(gt_final));
    gt_map(find(gt_final>0)) = 1;
    
    fileName_ID = strrep(fileName, 'ground_truth', 'ID');
    load([idPath, fileName_ID]) %lb
    id = lb.*gt_map;
    save([processed_idPath, fileName_ID], 'id')
end