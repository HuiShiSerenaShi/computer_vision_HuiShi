clear all
close all

%load the first PPM
load  Calib_direct_1.mat
P_left=P;

%load the second PPM
load  Calib_direct_2.mat
P_right=P;

% read the image, the object size is 19.8*9.8*2.5 cm
I1=imread('Image1.jpg');
I2=imread('Image2.jpg');

% point acquisition in the left image
figure,imshow(I1);
[x_left_1 y_left_1]=ginput(1);
hold on, plot(x_left_1,y_left_1,'g*');
[x_left_2 y_left_2]=ginput(1);
hold on, plot(x_left_2,y_left_2,'g*');
m_left=[x_left_1 x_left_2; y_left_1 y_left_2];
hold on, plot(m_left(1,:),m_left(2,:),'g');

% point acquisition in the right image
figure,imshow(I2);
[x_right_1 y_right_1]=ginput(1);
hold on, plot(x_right_1,y_right_1,'g*');
[x_right_2 y_right_2]=ginput(1);
hold on, plot(x_right_2,y_right_2,'g*');
m_right=[x_right_1 x_right_2; y_right_1 y_right_2];


% triangulation calculation, Linear-Eigen algorithm
% A*M = 0, the 3D point M is the solution of this homogeneous linear system
M = []
P_left = P_left./norm(P_left(3,1:3));
P_right = P_right./norm(P_right(3,1:3));
% construction of A1 for calculating the first 3D point
A1 = [
P_left(1,:) - m_left(1,1)*P_left(3,:) % (P1 - u*P3)'
P_left(2,:) - m_left(2,1)*P_left(3,:) % (P2 - v*P3)'
P_right(1,:) - m_right(1,1)*P_right(3,:) % (P1' - u'*P3')'
P_right(2,:) - m_right(2,1)*P_right(3,:) % (P2' - v'*P3')'
]
[U, D, V] = svd(A1); % A = U*S*V'
x = V(:,end); % Least squares solution of homogeneous linear equations
M =[M x(1:3)./x(4)]; % Euclidean coordinates

% construction of A2 for calculating the second 3D point
A2 = [
P_left(1,:) - m_left(1,2)*P_left(3,:) % (P1 - u*P3)'
P_left(2,:) - m_left(2,2)*P_left(3,:) % (P2 - v*P3)'
P_right(1,:) - m_right(1,2)*P_right(3,:) % (P1' - u'*P3')'
P_right(2,:) - m_right(2,2)*P_right(3,:) % (P2' - v'*P3')'
]
[U, D, V] = svd(A2); % A = U*S*V'
x = V(:,end); % Least squares solution of homogeneous linear equations
M =[M x(1:3)./x(4)]; % Euclidean coordinates

% Calculate the 3D distance between the two estimated points
d=sqrt(sum( (M(:,1) - M(:,2)) .^2))
close all
% show the result 
imshow(I1);
hold on, plot(m_left(1,:),m_left(2,:),'g*')
hold on, plot(m_left(1,:),m_left(2,:),'g')
hold on, text(m_left(1,1),m_left(2,1),num2str(d),'FontSize',16,'Color','g')


