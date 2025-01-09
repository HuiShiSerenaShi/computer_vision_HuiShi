% Estimate camera position with Fiore's method:
clear all
close all
clc

% Loading image information
load('imgInfo.mat')
% Image
img = imread('cav.jpg');

% load the 2D and 3D points
point_2D = imgInfo.punti2DImg;
point_3D = imgInfo.punti3DImg;

% show the 3D Points:
figure(1)
scatter3(point_3D(:,1),point_3D(:,2),point_3D(:,3),5,'o');
axis equal

% Reproject 3D points using calibration data:
figure(2)
imshow(img);
hold on;
plot(point_2D(:,1), point_2D(:,2),'r.');
P=imgInfo.K*[imgInfo.R imgInfo.T];
[u,v] = proj(P,point_3D);
plot(u,v,'go');


% compute the camera position using exterior orientation, Fiore's method
% subset of the points
point_3D_sub = point_3D(1:100,:)';
point_2D_sub = point_2D(1:100,:)';

% convert to normalized coordinates, pi = inv(k) *mi
number_of_points = size(point_2D_sub,2);
mi = [point_2D_sub;  ones(1,number_of_points)];
pi = inv(imgInfo.K) * mi;
pi_2d = pi(1:2,:)./ [pi(3,:)' pi(3,:)']';
m = pi_2d(1:2,:);
% convert to homogeneous
homogeneous_m = [m;ones(1,(size(m,2)))];
% inv(k)*W = [R t]M
M = [point_3D_sub; ones(1,(size(point_3D_sub,2)))]; % 4*100
[U, D, V] = svd (M);
% let Vr be the matrix composed by the last n-r columns of V, r = rank(M)
Vr = V(:,rank(M)+1:end);
% (kron(Vr',inv(k))*D)*z = 0, z is the scale factor, we can obtain z by
% solving this linear system.
% construction of D (3m*n), z is n*1
D = []; 
for i = 1:number_of_points % for every point
  D =  [D 
      zeros(3,i-1) homogeneous_m(:,i) zeros(3,number_of_points-i)];
end
[U1, D1, V1] = svd((kron(Vr',inv(imgInfo.K))*D));
z = abs(V1(:,end));
% z*inv(k)*mi = R*Mi + t, solve this absolute orientation problem to get G
% Xi = R*Yi + t
[G,s,res1] = absolute(vtrans(D *  z,3),point_3D_sub,'scale'); 

% reproject the 3D points using the new exterior matrix:
figure(3);
imshow(img);
hold on;
plot(point_2D(:,1), point_2D(:,2),'r.');
P1=imgInfo.K*G;
[u1,v1] = proj(P1,point_3D);
plot(u1,v1,'bo');

% Comparison between the estimated position from the calibration and that
% estimated with Fiore's method:
[imgInfo.R imgInfo.T G]

