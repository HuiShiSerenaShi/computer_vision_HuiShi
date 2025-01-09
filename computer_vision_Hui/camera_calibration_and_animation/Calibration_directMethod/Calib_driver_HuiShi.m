% Calibration: direct method


clear all
close all
clc

% read image:
img1 = imread('object_HuiShi.jpg');


% The calibration object is known as the following 6 3D points, 
% refer to the image named help_HuiShi.jpg
Mi =    [0,0,2.5,1;
        9.8,0,2.5,1;
        9.8,19.8,2.5,1;
        0,19.8,2.5,1;
        9.8,0,0,1;
        9.8,19.8,0,1];
    
    
%Show the image
figure(1);
imshow(img1);
hold on;

% Collect 2D points from the image:    
xc = []; % x of the collected points
yc = []; % y of the collected points
calib_i = 0;
while calib_i <6 % collect 6 points
[clickX,clickY] = ginput(1);
    xc = [xc;clickX];
    yc= [yc;clickY];
    scatter(clickX,clickY,'g','+'); % show the collected points on the image
    text(clickX,clickY,strcat('.       ',num2str(calib_i+1))); % show the index of the point
    calib_i=calib_i+1;
end

mi = [xc,yc,ones(6,1)]; % mi is the homogeneous coordinates of the 6 2D points

% Calibration:
A = []; % A*vec(P') = 0, PPM is the solution of this homogeneous linear system.
% A is 2n*12, vec(P') contains 12 unknown of the PPM. n is the number of points.
for i = 1:6 
 % construction of A, A = (Mi' kronecker product [mi]x )
 %  [mi]x is a skew symmetric matrix obtained from vector mi
    a = mi(i,:).'; % a is 3*1
    ax = [0,-a(3,1),a(2,1);
          a(3,1),0,-a(1,1);
         -a(2,1),a(1,1),0];      
     % Our Mi is alreay the transpose of M
     KRO = kron(ax,Mi(i,:));

     A = [A;KRO(1,:);KRO(2,:)]; % only 2 of the 3 equations are independent
end
% SVD (A = UDV')is used to solve the linear system, 
% the solution is the last column of V.
 [U,S,V] = svd(A,'econ'); 
 vecP = V(:,size(A,2));

P = [vecP(1,1),vecP(2,1),vecP(3,1),vecP(4,1);
vecP(5,1),vecP(6,1),vecP(7,1),vecP(8,1);
vecP(9,1),vecP(10,1),vecP(11,1),vecP(12,1)
]; % matrix form of PPM

% factorization of P using Q-R factorization:
%  1) take Q (3*3) and q(3*1) from P
Q = P(:,1:3);
q = P(:,4);
%  2) compute Q^-1
Q_inv = inv(Q);
%  3) compute factorization Q^-1 = OT, O is the orthogonal matrix, 
% T is the upper triangular matrix
[O,T] = qr(Q_inv);

% set R = O^-1 , K = T^-1 , t = T * q (K^-1 * q)
R = inv(O);
K = inv(T);
t = T * q;
% get P
P = K*[R t];
 
P

% reproject the 3D points onto the image using the obtained PPM
m_reproj = [];
for j = 1:6   
    m_homogeneous = P*(Mi(j,:).'); % P is 3*4, Mi is 4*1, m_homogeneous is 3*1
    m_reproj = [m_reproj;m_homogeneous.'/m_homogeneous(3,1)];
end

hold on

for k = 1:6
    scatter(m_reproj(k,1),m_reproj(k,2),'r'); % show the reprojection on the image
    scatter(xc(k,1),yc(k,1),'g','+'); % show the collected 2D points
    text((m_reproj(k,1)),(m_reproj(k,2)),strcat('.       ',num2str(k))); % show the index of the points
   
end

% save the obtained PPM to a .mat file
save('Calib_direct_HuiShi.mat', 'P');