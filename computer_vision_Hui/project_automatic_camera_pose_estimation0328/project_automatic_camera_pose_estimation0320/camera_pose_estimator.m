% Computer vision project: 
% Automatic camera pose estimation from 3D-> 2D correspondences
% Author: Hui Shi, 2023

% Input: 
% 1. a 3D model and a reference picture of a calibtrated scene, and the
% reference points extracted by extract_reference_points.m
% 2. a target image whose camera pose to be estimated and its camera intrinsic parameter
% Output: camera pose of the target image
% Algorithm:
% 1. Extract 2D feature points from the target image
% 2. Match the 2D feature points of the target image with the reference points, 
% by comparing their descriptors.
% 3. Estimate the camera pose of the target image using Fiore's exterior
% estimation method, which takes 3D-->2D correspondences as input. Robust fitting using RANSAC.

clear all
close all
clc
% setup the vlfeat lib
run('vlfeat-0.9.21/toolbox/vl_setup');
vl_version verbose


% load the reference image and the 3D points
load('point_3D.mat')
point_3D = Xvis;
name_ref = '_SAM1001.JPG'; % change the image name
img_ref = imread(name_ref);
img_ref_RGB = imread(name_ref);

% show the 3D points
figure('Name','3D points')
hold on
plot3(point_3D(:, 1),point_3D(:, 2), point_3D(:,3), 'b.');
axis equal;
grid on;

% load the reference points
load('reference_points.mat')
num_feature = num_feature;
ref_p3D = ref_p3D;
ref_feature = ref_feature;
ref_descriptor = ref_descriptor;


% 1. Extract 2D feature points from the target image
%name_target = '_SAM1002.JPG'; % change the image name
%name_target = '_SAM1079.JPG';
name_target = '_SAM1080.JPG';
%name_target = '_SAM1107.JPG';
%name_target = '_SAM1108.JPG';

% read target image
img_target = imread(name_target);
img_target_RGB = imread(name_target);
img_target = rgb2gray(img_target) ;
img_target = im2single(img_target);
% Extract 2D feature points
[frame_target, descriptor_target] = vl_sift(img_target) ;
% sort the scale of the extracted frames and take the biggest ones
scale_f_targ = frame_target(3,:);
[dump,scaleind_targ] = sort(scale_f_targ,'descend');
scaleind_targ = scaleind_targ(:,1:num_feature)';
frame_target = frame_target(:,scaleind_targ);
descriptor_target = descriptor_target(:,scaleind_targ);

% show the target image with extracted features
figure('Name','target image')
imshow(img_target_RGB);
hold on
h_targ = vl_plotframe(frame_target) ;
set(h_targ,'color','y','linewidth',2) ;


% 2. Match the 2D feature points of the target image with the reference points, 
% by comparing their descriptors
[matches, scores] = vl_ubcmatch(ref_descriptor, descriptor_target) ;
% sort the scores and take the best matches
[dump,scoreind] = sort(scores,'ascend');
score_ratio = 0.5; % change the score_ratio if necessary
best_matchesind = scoreind(1,1:round(size(scoreind,2)*score_ratio));
% obtain 3D-->2D correspondences 
best_match_3D = ref_p3D(matches(1,best_matchesind),:);
best_match_2D = frame_target(:,matches(2,best_matchesind));

% show the best matches
% combine reference image and target image
newfig=zeros(size(img_ref,1), size(img_ref,2)+size(img_target,2),3);
newfig(:,1:size(img_ref,2),:) = img_ref_RGB;
newfig(1:size(img_target,1) ,(size(img_ref,2)+1):end,:)=img_target_RGB;
newfig=uint8(newfig);
figure('Name','Best matches');
image(newfig);
axis image;
hold on
% plot the best matches
f_targ_shifted = frame_target;
f_targ_shifted(1,:) = f_targ_shifted(1,:)+size(img_ref,2); % shift the target image
h1 = vl_plotframe(ref_feature(:,matches(1,best_matchesind)));
h2 = vl_plotframe(f_targ_shifted(:,matches(2,best_matchesind)));
set(h1,'color','g','linewidth',2);
set(h2,'color','b','linewidth',2);
hold on
% plot lines between the best matches
for i = 1:size(best_matchesind,2)
    indx = best_matchesind(i);
    line([ref_feature(1,matches(1,indx)) f_targ_shifted(1,matches(2,indx))],...
    [ref_feature(2,matches(1,indx)) f_targ_shifted(2,matches(2,indx))], 'linewidth',1, 'color','r')
end


% 3. Estimate the camera pose of the target image using Fiore's exterior
% estimation method, which takes 3D-->2D correspondences as input. Robust fitting using RANSAC.
% read the camera parameters
name_targ_xmp = [name_target(1:end-3) 'xmp'];
[K1, R1, t1] = read_xmp(name_targ_xmp);
% the known camera extrinsic parameter and ppm are used for later comparing
% with the estimated result.
G1 = [R1 t1; 0 0 0 1];
ppm_known = K1 * [1 0 0 0
        0 1 0 0
        0 0 1 0] * G1;

% run Fiore's method and robust fitting using RANSAC, obtain the estimated camera pose
tollerance = 10; % acceptable distance used to filter out the outliers
max_iterations = 150; % change the RANSAC iteration times if needed
[G_estimated, inliers, outliers] = ransac_fiore(K1, best_match_3D', best_match_2D(1:2,:), tollerance, max_iterations);
P_estimated=K1*G_estimated;

% project the 3D points to the image using the estimated ppm (red circle)
% and compare with the projection using the known ppm (blue dot)
figure('Name','projection of 3D points using estimated ppm "red o" and known ppm "blue ."');
[u2,v2] = proj(ppm_known,point_3D);
[u3,v3] = proj(P_estimated,point_3D);
imshow(img_target_RGB);
hold on
plot(u2,v2,'b.');
plot(u3,v3,'ro')

% compare the estimated camera pose with the known camera pose
disp('known camera pose:')
[R1 t1]
disp('estimated camera pose:')
G_estimated