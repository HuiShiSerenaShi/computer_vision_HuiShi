% Epipolar Rectification
% The aim is to find two new PPM matrices (one for each camera), obtained
% by rotating the original camera along their optical centers until the
% focal planes become coplanar. Thus making the epipolar lines parallel and horizontal.

clear all
close all
clc

%Loading calibration data
stereo = load('Calib_Results_stereo.mat');
left = load('Calib_Results_left.mat');
right = load('Calib_Results_right.mat');

% load image
img1=rgb2gray(imread('left01.jpg'));
img2=rgb2gray(imread('right01.jpg'));

% First step: projection of the stereo points in the two cameras
point_3d=stereo.X_left_1; % starting 3d points
% camera left: reference system centered on this camera, so R is I, T is 0
PPM_left = stereo.KK_left*[1 0 0 0;0 1 0 0;0 0 1 0]; %KK is internal parameters

% transform the 3D points from the world frame to the left camera frame
Rc_left = rodrigues(stereo.omc_left_1); % Rc is rotation matrix = rodrigues(omc), omc is rotation vector
G_c = [Rc_left, stereo.Tc_left_1;0 0 0 1];% G_c is 4*4
X_c = G_c * [point_3d; ones(1,size(point_3d,2))];
% project to image coordinates
m_left=PPM_left*X_c; % 2d homogeneous coordinates
x_left=m_left(1,:)./m_left(3,:); 
y_left=m_left(2,:)./m_left(3,:);

% right camera
% relation between the right camera and the left camera is XR = R * XL + T
G_r=[stereo.R stereo.T;0 0 0 1];% G_r is used for transform from the left frame to the right frame
PPM_right = stereo.KK_right*[1 0 0 0;0 1 0 0;0 0 1 0]*G_r;
m_right=PPM_right*X_c; % 2d homogeneous coordinates
x_right=m_right(1,:)./m_right(3,:);
y_right=m_right(2,:)./m_right(3,:);

% PPM breakdown
Q1=PPM_left(:,1:3);
Q2=PPM_right(:,1:3);
q1=PPM_left(:,4);
q2=PPM_right(:,4);

K1 = stereo.KK_left;
R1 = eye(3);
t1 = zeros(3)';

K2 = stereo.KK_right;
R2 = stereo.R;
t2 = stereo.T;

% Obtaining the optical centers of the two cameras C=-inv(Q1)*q
% being the system centered in the first camera its optical center will have
% coordinates 3d=[0 0 0]' Cartesian
c_left = - inv(Q1)*q1;
c_right= - inv(Q2)*q2;

% construct the rotation matrix R=[r1' r2' r3'] which is the same for both cameras
% r1: new X axis which is parallel to the baseline
r1 = (c_right-c_left);

% place an unit vector equal to the old Z axis
k=R1(3,:);
% r2: new Y axis, orthogonal to the X axis and the old Z axis
r2 = cross(k',r1);
% r3: new Z axis, orthogonal to the X and Y axis
r3 = cross(r1,r2);
 
% normalize and compose R
R = [r1'/norm(r1); r2'/norm(r2); r3'/norm(r3)];

% compose the new PPMs, set K (matrix of intrinsic parameters) equal
% to that of camera left
P_left_new = K1 * [R -R*c_left ];
P_right_new = K1 * [R -R*c_right ];

% obtain the transformation matrix used for image rectification
% T(3*3)=Qn*inv(Qo), where Qo refers to the old PPM and Qn to the new one.
T_left=P_left_new(:,1:3)*inv(Q1);
T_right=P_right_new(:,1:3)*inv(Q2);

% calculate the new projections of the adjusted points
m_left_new = T_left*m_left; 
m_right_new = T_right*m_right;

% Pass to Cartesian coordinates
m_l_new(1,:)=m_left_new(1,:)./m_left_new(3,:);
m_l_new(2,:)=m_left_new(2,:)./m_left_new(3,:);
m_r_new(1,:)=m_right_new(1,:)./m_right_new(3,:);
m_r_new(2,:)=m_right_new(2,:)./m_right_new(3,:);

% image rectification
img1_rec = imwarp(img1,T_left);
img2_rec = imwarp(img2,T_right);

% Display results on the old image and the rectified image
figure(1);
subplot(221); imshow(img1); hold on
scatter(x_left,y_left,'b*');
subplot(222); imshow(img2); hold on
scatter(x_right,y_right,'r*');

subplot(223); imshow(uint8(img1_rec)); hold on
scatter(m_l_new(1,:),m_l_new(2,:),'b*');
subplot(224); imshow(uint8(img2_rec)); hold on
scatter(m_r_new(1,:),m_r_new(2,:),'r*');

% Projection of epipolar lines
% Epipole
e_r = P_right_new*[-inv(P_left_new(:,1:3))*P_left_new(:,4);1];
% Fundamental matrix  F = [e']x*Q'*invQ
e_r_x= [0 -e_r(3) e_r(2); e_r(3) 0 -e_r(1);-e_r(2) e_r(1) 0];
F=e_r_x*P_right_new(:,1:3)*inv(P_left_new(:,1:3));

% click some random points on the left image, the epipolar line will show
% on the right image
figure,imagesc(img1_rec); colormap(gray); title('Click a point on this Left Image');axis image;
figure,imagesc(img2_rec); colormap(gray); title('Corresponding Epipolar Line in this Right Image');axis image;
line_color =['r' 'b' 'g'];
for i=1:3
    % Clicking a point on the left image:
    figure(2);    
    [left_x left_y] = ginput(1);
    hold on;
    plot(left_x,left_y,'r*');

    % Finding the epipolar line on the right image:
    left_P = [left_x; left_y; 1];
    right_P = F*left_P;
    right_epipolar_x=1:size(img2_rec,2);
    % Using the eqn of line: ax+by+c=0; y = (-c-ax)/b
    right_epipolar_y=(-right_P(3)-right_P(1)*right_epipolar_x)/right_P(2);
    figure(3);
    hold on;
    plot(right_epipolar_x,right_epipolar_y,line_color(i));
end
