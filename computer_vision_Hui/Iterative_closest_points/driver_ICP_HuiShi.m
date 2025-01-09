% ICP
% a matlab script finding the rigid transformation that aligns two cloud of points
% using iterative closest points method

clear 
close all

% load the 3D points
data = load('a4000001.cnn'); % 676*3
model = load('a4000007.cnn');% 545*3

% show the 3D points
figure(1);
plot3(model(:,1), model(:,2), model(:,3), '.b');
hold on
plot3(data(:,1), data(:,2), data(:,3), '.r');
hold on
grid on
axis equal

% find a rigid trasformation G (4*4 homogeneous matrix) which brings data onto model.
% ICP - Iterative Closet Point algorithm.
number_of_iterations = 200;
error_threshold = 0.00000001;
G=eye(4); % set G as I in the first iteration.
error = inf;
pre_error = 0;
i=0; % iterations counter
% iterate till reaches threshold of the error and till the
% pre-defined  number of iterations is finished.
while ((abs(error-pre_error)> error_threshold) && i < number_of_iterations)
    i = i+1;
    pre_error = error;
    % apply current 3D rigid transformation bringing data onto model 
    G_rigid = G(1:3,:);
    homogeneous_data =[data ones(size(data,1),1)]'; % homogeneous and transpose
    % obtain the new set of data which is closer to the model after each iteration
    data_regression = (G_rigid*homogeneous_data)';  

    % compare the new set of data with the model by computing the closest points
    % model_closestP(i,:) are the coordinates of the closest point in the model set
    % corresponding to the i-th point in the data_regression set
    % error is the average minimum distance between closest points
    [error,model_closestP] = find_closest_points(data_regression,model);
    
    % find the transformation between the data_regression and the model_closestP
    % using absolute orientation, Xi = s(R*Yi + t)
    number_of_points = size(data_regression,1);
    % mean(Xi) = s*R*mean(Yi)
    % compute the mean(Xi) and mean(Yi)
    % mean(Xi) = Xi - centroid, mean(Yi) = Yi - centroid, centroid_X = sum(Xi/N)
    centroid_data = sum(data_regression,1)./number_of_points;
    centroid_model = sum(model_closestP,1)./number_of_points;
    mean_data = data_regression-centroid_data;
    mean_model  = model_closestP-centroid_model;
    % compute rotation R = U*S*V'
    [U,D,V]=svd(mean_model'*mean_data);
    S = diag([1,1,det(U*V')]);
    R = U*S*V';
    %  compute traslation
    t = centroid_model' - R * centroid_data';
    % rigid transformation
    G_absolute =  [R, t
        0 0 0 1];
    % obtain the new G and then iterate again and again...
    G = G_absolute * G
end

% align the data and model using the obtained final 3D rigid transformation
G_final = G(1:3,:);
homogeneous_data =[data ones(size(data,1),1)]'; 
datafinal = (G_final*homogeneous_data)';

figure(2);
plot3(model(:,1), model(:,2), model(:,3), '.b');
hold on
plot3(datafinal(:,1), datafinal(:,2), datafinal(:,3), '.r');
hold on
grid on
axis equal
