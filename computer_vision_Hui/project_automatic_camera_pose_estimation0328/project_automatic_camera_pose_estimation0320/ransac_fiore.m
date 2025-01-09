% Camera pose estimation using Fiore's exterior estimation and robust fitting using RANSAC.
% Author: Hui Shi, 2023

% Input: 
% 1. K - camera intrinsic parameters
% 2. points_3D - 3D points (3*n matrix) from the correspondences
% 3. points_2D - 2D points (2*n matrix) from the correspondences
% 4. tollerance - acceptable distance (between the 2D points and projection of 3D points using
% estimated camera pose) used to filter out the outliers
% 5. max_iterations - iteration times needed for RANSAC fitting
% Output:
% G - camera pose, inliers, outliers


function [G, inliers, outliers] = ransac_fiore(K, points_3D, points_2D, tollerance, max_iterations)

inliers = [];
outliers = [];
p_model = 6; % minimum number of points needed for Fiore's exterior estimation

i = 0;
while (i < max_iterations) % iterate max_iterations times 
    inliers_temp = [];
    outliers_temp = [];
    % make the data to be random
    rand_ind = randperm(size(points_3D,2));
    points_3D_rand = points_3D(:,rand_ind);
    points_2D_rand = points_2D(:,rand_ind);

    % run Fiore's exterior estimation, obtain the model parameters
    [G_temp,s] = exterior_fiore(K,points_3D_rand(:,1:p_model),points_2D_rand(:,1:p_model));

    % project the rest of the 3D points to the image using the estimated model parameters
    p_3D = points_3D_rand(:,p_model+1:end);
    ppm_temp=K*G_temp;
    [u,v] = proj(ppm_temp,p_3D');
    projected_3D = [u';v'];
    % take the rest of the 2D points
    p_2D = points_2D_rand(:,p_model+1:end);


    % model fitting using the rest of the data
    % filter out the outliers using the distance between the 2D points and projected 3D points 
    for j = 1:size(projected_3D,2)
        distance = norm(p_2D(:,j)-projected_3D(:,j));
        if (abs(distance) <= tollerance)
            inlier = [p_3D(:,j); p_2D(:,j)];
            inliers_temp = [inliers_temp inlier];
        else
            outlier = [p_3D(:,j); p_2D(:,j)];
            outliers_temp = [outliers_temp outlier];   
        end
    end
    % update the output if there is a better camera pose estimation
    % according to the number of inliers
    if (size(inliers_temp, 2) > size(inliers, 2))
        inliers = inliers_temp;
        outliers = outliers_temp;
        G = G_temp;
    end
    i = i + 1;
end

% run Fiore's exterior estimation, obtain the camera pose using all inliers from the best
% model parameters estimation
[G,s] = exterior_fiore(K,inliers(1:3,:),inliers(4:5,:));


% debugging, display the number of iterations, inliers, outliers  
disp('Iterations: [n / total]');
disp([i, max_iterations]);
disp('Inliers: [n / total]');
disp([size(inliers, 2), size(inliers, 2) + size(outliers, 2)]);
disp('Outliers: [n / total]');
disp([size(outliers, 2), size(inliers, 2) + size(outliers, 2)]);