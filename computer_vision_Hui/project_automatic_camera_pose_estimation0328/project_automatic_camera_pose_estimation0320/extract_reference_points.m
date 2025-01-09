% reference points extraction
% Author: Hui Shi, 2023

% Input: 
% a 3D model and a reference picture of a calibtrated scene, and its calibration data
% Output:
% the extracted reference points are saved in reference_points.mat to be used by camera_pose_estimator.m
% Algorithm:
% 1. Extract 2D feature points from the reference image, using SIFT from the vlfeat lib.
% ref : https://www.vlfeat.org/overview/sift.html#tut.sift.match
% 2. Project 3D points to the reference image
% 3. Match the largest 2D feature points with the 3D points, and take the
% matches as reference points


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

% 1. Extract 2D feature points from the reference image, using SIFT from the vlfeat lib.
% ref : https://www.vlfeat.org/overview/sift.html#tut.sift.match
img_ref = rgb2gray(img_ref) ;
img_ref = im2single(img_ref);
[frame_ref, descriptor_ref] = vl_sift(img_ref) ;

% sort the scale of the extracted frames and take the biggest ones
scale_f_ref = frame_ref(3,:);
[dump,scaleind_ref] = sort(scale_f_ref,'descend');
% change the num_feature (number of biggest frames) if the image size is too small
if size(img_ref,1) <= 1000 && size(img_ref,2) <= 1000
    num_feature = 1000;
else
    num_feature = 5000;
end
scaleind_ref = scaleind_ref(:,1:num_feature)';
frame_ref = frame_ref(:,scaleind_ref);
descriptor_ref = descriptor_ref(:,scaleind_ref);

% show the selected feature points
figure('Name','Reference points')
imshow(img_ref_RGB);
hold on
h_ref = vl_plotframe(frame_ref) ;
set(h_ref,'color','y','linewidth',2) ;


% 2. Project 3D points to the reference image
% Read camera parameters:
name_ref_xmp = [name_ref(1:end-3) 'xmp'];
[K, R, t] = read_xmp(name_ref_xmp);
G = [R t; 0 0 0 1];
ppm = K * [1 0 0 0
        0 1 0 0
        0 0 1 0] * G;
% Project 3D points to image
[u, v] = proj(ppm,point_3D);
plot(u, v, 'g.');

% 3. Match the largest 2D feature points with the 3D points, and take the
% matches as reference points
window_size=3; % change the window size if necessary
ind_match_3D = [];
ind_match_feature = [];
% search around the feature points, find the cooresponding projected 3D points
for i=1:size(frame_ref,2) % for every feature point
    for j =1:size(u) % for every projected u
        %  if u is within x +/- window_size
        if frame_ref(1,i) >= round(u(j))-window_size && frame_ref(1,i) <= round(u(j))+ window_size
            % if v is within y +/- window_size
            if frame_ref(2,i) >= round(v(j))-window_size && frame_ref(2,i) <= round(v(j))+ window_size
                % record the matches
                ind_match_3D = [ind_match_3D j];
                ind_match_feature = [ind_match_feature i];
            end
        end
    end
end
% show the reference points as red circles
plot(u(ind_match_3D(1,:)), v(ind_match_3D(1,:)), 'ro');

ref_feature = frame_ref(:,ind_match_feature(1,:));
ref_p3D = point_3D(ind_match_3D(1,:), :);
% assign to reference points the 2D descriptor inherited from the 2D feature points
ref_descriptor = descriptor_ref(:,ind_match_feature(1,:));

% save the ref_feature, ref_p3D, ref_descriptor, num_feature to reference_points.mat
% to be used by camera_pose_estimator.m
save('reference_points.mat', "ref_p3D", "ref_feature", "ref_descriptor", "num_feature");