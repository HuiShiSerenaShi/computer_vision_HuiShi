
% Estimation of the fundamental matrix

clc
clear all
close all

%load the first PPM
load  Calib_direct_1.mat
P_left=P;

%load the second PPM
load  Calib_direct_2.mat
P_right=P;

% Computes fundamental matrix and epipoles from camera matrices
%calculate the optical centers from the two PPMs
c_left = -inv(P_left(:,1:3))*P_left(:,4);% - Q^-1 * q,  size of c_left is 3*1
c_right = -inv(P_right(:,1:3))*P_right(:,4);

%calculate the epipoles as a projection of the optical centers
e_left = P_left*[c_right' 1]'; % e'= P'*c, c = ((- Q^-1 * q)' 1)', c size is 4*1
e_right = P_right*[c_left' 1]'; % e is 3*1

e_left = e_left./norm(e_left); % unit vector
e_right = e_right./norm(e_right);

%calculate the fundamental matrix F = [e']x*Q'*invQ
F=[   0    -e_right(3)  e_right(2)
     e_right(3)    0   -e_right(1)
    -e_right(2)  e_right(1)   0   ]*P_right(:,1:3)*inv(P_left(:,1:3));

F = F./norm(F);

% Show epipolar line:
% load 2D images
I_left=imread('Image1.jpg');
I_right=imread('Image2.jpg');

figure,imagesc(I_left); colormap(gray); title('Click a point on this Left Image');axis image;
figure,imagesc(I_right); colormap(gray); title('Corresponding Epipolar Line in this Right Image');axis image;

line_color =['r' 'b' 'g'];
for i=1:3
    % Clicking a point on the left image:
    figure(1);    
    [left_x left_y] = ginput(1);
    hold on;
    plot(left_x,left_y,'r*');

    % Finding the epipolar line on the right image:
    left_P = [left_x; left_y; 1];
    right_P = F*left_P;
    right_epipolar_x=1:size(I_left,2);
    % Using the eqn of line: ax+by+c=0; y = (-c-ax)/b
    right_epipolar_y=(-right_P(3)-right_P(1)*right_epipolar_x)/right_P(2);
    figure(2);
    hold on;
    plot(right_epipolar_x,right_epipolar_y,line_color(i));
end
