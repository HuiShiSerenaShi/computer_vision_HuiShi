
% Reprojecting 3D points on 2D images

close all
clear all

% load the 3D points and calib results
points_3D = load(['3D_points_HuiShi.mat']);
camera = load(['Calib_Results.mat']);

% load the image, each grid on the chessboard is 30*30 mm
ImageIN=imread('Image16.tif');

% show the 3D Points on figure 1, the shape is triangle
X=points_3D.points_3D
figure(1)
plot3(X(1,:),X(2,:), X(3,:), 'o');

% the matrix of intrinsic parameters:
KK = camera.KK; % KK = [f(1) alpha_c*f(1)  c(1);  0  f(2)  c(2);  0 0 1];

% the matrix of extrinsic parameters:
R = camera.Rc_16;
T=camera.Tc_16;

% the PPM
P = KK *[R T];

% reproject the 3D points to 2D points using the obtained PPM
homogeneous_3d =[X' ones(size(X',1),1)]; % X' is n*3, homogeneous_3d is n*4, n is the number of points
homogeneous_2d = P*homogeneous_3d' ; % P is 3*4, homogeneous_3d' is 4*n, homogeneous_2d is 3*n
pixel_2d = homogeneous_2d(1:2,:)./ [homogeneous_2d(3,:)' homogeneous_2d(3,:)']'; % pixel_2d is 2*n
u = round(pixel_2d(1,:))'; % take the first row of pixel_2d
v = round(pixel_2d(2,:))'; % take the second row of pixel_2d

% show the obtained 2D points on figure2
figure(2)
imshow(ImageIN);
hold on
plot(u, v, 'b+');


%Alternative (with Radial Distortion):
om=camera.omc_16; % Rc_16 = rodrigues(omc_16), omc_16 is rotation vector
f=camera.fc; % The focal length in pixels is stored in the 2x1 vector fc.
c=camera.cc; % The principal point coordinates are stored in the 2x1 vector cc.
k=camera.kc; % The image distortion coefficients (radial and tangential distortions) are stored in the 5x1 vector kc

%xp: Projected pixel coordinates (2xN matrix for N points)
[xp,dxpdom,dxpdT,dxpdf,dxpdc,dxpdk] = project_points(X,om,T,f,c,k); 

% show the obtained 2D points on figure 3
figure(3)
imshow(ImageIN);
hold on
plot(xp(1,:), xp(2,:), 'r+');

% Special Effect:
% switch the triangle from a upper triangle to a lower triangle on the chessboard
% by switching the x and y coordinates
X_lower_triangle = X;
X_lower_triangle(1,:) =X(2,:); 
X_lower_triangle(2,:) =X(1,:);
% show the 3D points on figure 1
figure(1)
hold on
plot3(X_lower_triangle(1,:),X_lower_triangle(2,:), X_lower_triangle(3,:), 'b+');
% reproject the lower triangle on figure 4
[xp_lower_triangle,dxpdom,dxpdT,dxpdf,dxpdc,dxpdk] = project_points(X_lower_triangle,om,T,f,c,k);
figure(4)
imshow(ImageIN);
hold on
plot(xp_lower_triangle(1,:), xp_lower_triangle(2,:), 'b+');