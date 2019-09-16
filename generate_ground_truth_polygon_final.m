%% Project 1: Draw the polygon vertices, and return vertix coordinates, inside pixel coordinates and center coordinates.
% Author: Sheng Zou
% 01/21/2018
% Department of Electrical and Computer Engineering
% University of Florida
% Edited by Hudanyun Sheng
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% addpath('\\ece-azare-nas1.ad.ufl.edu\ece-azare-nas\Profile\hdysheng\Documents\MATLAB\Rhizotron code\droneData\thermalAnalysis')

clear;close all;clc

cube_name = '33012';

dataPath    = 'T:\Box2\Drone Flight Data and Reference Files\Flight Data - All Sites\CLMB STND 2019 Flight Data\100084_2019_06_25_16_39_57\';

hdrPath   = strrep(dataPath, 'T:\Box2\Drone Flight Data and Reference Files\Flight Data - All Sites', 'T:\AnalysisDroneData\ReflectanceCube\ReadableHDR');
hyperPath = strrep(dataPath, 'T:\Box2\Drone Flight Data and Reference Files\Flight Data - All Sites', 'T:\AnalysisDroneData\ReflectanceCube\MATdataCube');
gtPath    = strrep(dataPath, 'T:\Box2\Drone Flight Data and Reference Files\Flight Data - All Sites', 'T:\AnalysisDroneData\groundTruth');

if ~exist(gtPath, 'dir')
    mkdir(gtPath)
end

file_name = ['raw_', cube_name, '_rd_rf.mat'];
varStruct = load(fullfile(hyperPath, file_name));
nameCell  = fieldnames(varStruct);
data_hyper = getfield(varStruct, char(nameCell));

index_RGB = [124 65 39];
data_test = data_hyper(:,:,index_RGB);
mint = min(data_test(:));
maxt = max(data_test(:));
data_test = sqrt((data_test-mint)./(maxt-mint));

% if ROTATION == 1
%     data_test = imrotate(data_test, 180);
% end

%% 
gt = zeros(size(data_test,1), size(data_test,2));
answer = 'y';
% count  = 1;



while strcmp(answer, 'y')

% load the data
% load('data_train.mat')
% load('data_test.mat')

% display the image
% figure;imshow(data_train);axis on
figure;imshow(data_test);axis on
[num_r, num_c, ~] = size(data_test);

disp('zoom in the image, press any key to start draw then double click the polygon to finish')
pause % you can zoom in the image, once done, press any key to start draw
%% draw the polygon, double click the polygon to finish
[~,~,~,yi,xi] = roipoly; % xi, yi are the x, y coordinates of polygon vertices you draw

temp1 = repmat(floor(min(xi)):ceil(max(xi)),length(floor(min(yi)):ceil(max(yi))),1);
xq = reshape(temp1,1,size(temp1,1)*size(temp1,2)); % candidate position for xq
temp2 = repmat([floor(min(yi)):ceil(max(yi))]',1,length(floor(min(xi)):ceil(max(xi))));
yq = reshape(temp2,1,size(temp2,1)*size(temp2,2)); % candidate position for yq

%% Find the pixel coordinates inside the polygon
[in,on] = inpolygon(xq,yq, xi,yi);                          % Logical Matrix
inon = in | on;                                             % Combine ‘in’ And ‘on’
idx = find(inon(:));                                        % Linear Indices Of ‘inon’ Points
xcoord = xq(idx);                                           % X-Coordinates Of ‘inon’ Points
ycoord = yq(idx);                                           % Y-Coordinates Of ‘inon’ Points
idx1  = find(xcoord<=0);
if ~isempty(idx1)
    xcoord(idx1) = 1;
%     ycoord(idx1) = [];
end
idx2 = find(ycoord<=0);
if ~isempty(idx2)
% 	xcoord(idx2) = [];
    ycoord(idx2) = 1;
end
idx3 = find(xcoord >= num_r);
if ~isempty(idx3)
    xcoord(idx3) = num_r;
end
idx4 = find(ycoord >= num_c);
if ~isempty(idx4)
    ycoord(idx4) = num_c;
end
    

%% Find the center of the polygon
[ geom, iner, cpmo ] = polygeom( xi, yi ); % find the center of this polygon
x_cen = round(geom(2)); % x coordinate of polygon center (note: it has been round to integer)
y_cen = round(geom(3)); % y coordinate of polygon center (note: it has been round to integer)

%% Plot polygon based on coordinates to check
color_id  = input('Index for the color?', 's');
color_id  = str2double(color_id);
% A = zeros(6250,6250);
for t = 1:length(xcoord)
%     gt_map(xcoord(t),ycoord(t)) = count;
    gt(xcoord(t),ycoord(t)) = color_id;
    data_test(xcoord(t), ycoord(t), :) = [255 255 255];
end
% gt_map(x_cen,y_cen) = 2;
figure;imagesc(gt);axis image

%% Output
% polygon.xi = xi;% vertices
% polygon.yi = yi;
% polygon.xcoord = xcoord;% inside pixels
% polygon.ycoord = ycoord;
% polygon.x_cen = x_cen;% center
% polygon.y_cen = y_cen;
answer = input('Continue?(y/n)\n', 's');

% count = count + 1;
end
%%%%%%%%%%%%%% temp to delete %%%%%%%%%%%%%%%%%%%%
% gt2 = gt;
% 
% load([gtPath, 'ground_truth_', cube_name, '.mat']), % gt
% 
% gt = gt + gt2;

save([gtPath, 'ground_truth_', cube_name, '.mat'], 'gt')
figure, imagesc(gt), axis image, axis off, caxis([0,6]), colorbar
saveas(gcf, [gtPath, cube_name, '.jpg'], 'jpg')