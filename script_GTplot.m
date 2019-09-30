%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Based on the generated ground truth, generate label for plot ID
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear 
close all
clc

path_gt = 'T:\AnalysisDroneData\groundTruth\CLMB STND 2019 Flight Data\100081_2019_06_11_17_57_06\';
list = dir([path_gt, 'ground_truth_*.mat']);
    % get the correct order of the files
fileIdx = [];
for ii = 1:length(list)
    tempFile = list(ii).name;
    fileIdx  = [fileIdx str2double(tempFile(isstrprop(tempFile, 'digit')))];
end
[~, idx] = sort(fileIdx);
list = list(idx);

for ii = 22:length(list)
    fileName = list(ii).name;
    loaded = load([path_gt, fileName]);
    fields = fieldnames(loaded);
    gt = getfield(loaded, fields{1,1});
    figure, subplot(1,2,1), imagesc(gt), axis image, axis off
    BW = zeros(size(gt));
    BW(find(gt>0)) = 1;
    [lb, n]  = bwlabel(BW);
    subplot(1,2,2), imagesc(lb), axis image, axis off, colorbar
    disp(['File name ' fileName])
    for nn = 1:n
%         x = input(['x axis(number) for ' num2str(nn)]);
%         y = input(['y axis(letter) for ' num2str(nn)]);
%         ID = transfer(y, x);
%         lb(lb == nn) = ID;
        ID = input(['Plot ID for ' num2str(nn) '?']);
        lb(lb == nn) = ID;
    end
    saveName = strrep(fileName, 'ground_truth_', 'ID_');
    save([path_gt, saveName], 'lb')
    close all
end

% function ID = transfer(letter, number)
%     if strcmpi(letter, 'A')
%         num = 1;
%     elseif strcmpi(letter, 'B')
%         num = 2;
% 	elseif strcmpi(letter, 'C')
%         num = 3;
% 	elseif strcmpi(letter, 'D')
%         num = 4;
% 	elseif strcmpi(letter, 'E')
%         num = 5;
%     elseif strcmpi(letter, 'F')
%         num = 6;
%     end
%     ID = number*6 + num;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Based on the generated ground truth, generate label for plot ID
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
