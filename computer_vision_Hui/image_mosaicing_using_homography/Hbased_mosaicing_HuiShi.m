%% Homography
clear all;
close all;
clc;

% load image
% img1=imread('./panorama_image1_big.jpg');
% img2=imread('./panorama_image2_big.jpg');
img1=imread('left6.jpeg');
img2=imread('right6.jpeg');

img1=rgb2gray(img1);
img2=rgb2gray(img2);
figure(1)
imshow(img1);
figure(2)
imshow(img2);

% Acquisition of points
num_p=8; % number of points to acquire
point_left=[];
point_right=[];
for i=1:num_p
    figure(1); 
    hold on,
    [x_left, y_left]=ginput(1);
    plot(x_left,y_left,'g*');
    point_left=[point_left; x_left, y_left];
    
    figure(2); 
    hold on
    [x_right, y_right]=ginput(1);
    plot(x_right,y_right,'b*'); 
    point_right=[point_right; x_right, y_right];
end

point_left=point_left';
point_right=point_right';

% Representation of chosen points on images
figure;
subplot(121); imshow(img1);
subplot(122); imshow(img2);
subplot(121); hold on; scatter(point_left(1,:),point_left(2,:),'*r');
subplot(122); hold on; scatter(point_right(1,:),point_right(2,:),'*g');

% Homography matrix calculation
% The relation between the 2d points of the two images is m' = H*m,
% (m(transpose) kronecker product with [m']x)*vec(H) = 0, H has 9 elements
% H is the solution of this linear system
% construction of A
A=[];
for i=1:size(point_left,2)
    % m_right: homogeneous coordinates of the point in the right image
    m_right=[point_right(:,i);1];
    % construction of [m']x
    m_right_x=[0 -m_right(3) m_right(2);
               m_right(3) 0 -m_right(1);
              -m_right(2) m_right(1) 0];
    % m_left: homogeneous coordinates of the point in the left image
    m_left=[point_left(:,i);1];
    % kronecker product
    kro=kron(m_left', m_right_x);
    % take the first two linearly independent rows, rank = 2
    A=[A; kro(1,:);kro(2,:)];
end

% Calculation of H using least square method
[U, D, V] = svd(A); 
h = V(:,end); 
H = [h(1) h(4) h(7);
     h(2) h(5) h(8);
     h(3) h(6) h(9)]
H=H./H(3,3);

% find the cooresponding points of the right image on the left image
% m' = H*m --> m = inv(H)*m'
[img_right_new, bounding_box, alpha]=imwarp(img2,inv(H), 'linear', 'valid'); % linear interpolation
bad_points=find(isnan(img_right_new)); % find the index of the point which is NaN
img_right_new(bad_points)=0; % set the bad points from NaN to 0

% find the size of the final stitching image:
% bounding_box is the bounding box of the transformed image in the
% coordinate frame of the input image. The first 2 elements of the bounding_box are
% the translation that have been applied to the upper left corner.
% The bounding box is specified with [minx; miny; maxx; maxy];
bb_right(1)=bounding_box(2); bb_right(2)=bounding_box(1); bb_right(3)=bounding_box(4); bb_right(4)=bounding_box(3);
bb_right=bb_right';% the bounding_box becomes [miny; minx; maxy; maxx]'

bb_left=[0; 0; size(img1)'];% bounding_box of the left image
% find the corners and the bounding box of the final stitching image
corners=[bb_right bb_left];  % 1*4 + 1*4 

minx = min(corners(2,:)); % take the smaller one from the two minx
miny = min(corners(1,:)); % take the smaller one from the two miny
maxx = max(corners(4,:)); % take the bigger one from the two maxx
maxy = max(corners(3,:)); % take the bigger one from the two maxy
bb_final=[miny; minx; maxy; maxx];

% find the size of the final stitching image
offset=[abs(miny); abs(minx)];
size_final=bb_final+[offset; offset]; % move the origin of the final image to (0,0)

% construction of the final image
if(size_final(1)==0 && size_final(2)==0)
    color_left=zeros(size_final(3), size_final(4));
    color_right=color_left;
    final_image=color_left;
else
    disp('somethig wrong...'); 
end

% fill in the final image with color(value of the image matrix)
if((offset(1)>0) && (offset(2)>0)) % if both x and y have offset
% color_left: miny:y_left_image+miny-1, minx:x_left_image+minx-1 = img1
% color_right: 1:y_img_right_new, 1:x_img_right_new = img_right_new
    color_left(offset(1):(size(img1,1)+offset(1)-1),offset(2):(size(img1,2)+offset(2)-1))=img1(:,:);
    color_right(1:(size(img_right_new,1)),1:size(img_right_new,2))=img_right_new(:,:);
end

if ((offset(1)>0) && (offset(2)==0)) % if only y has offset
% color_left: miny:y_left_image+miny-1, 1:x_left_image= img1
% color_right: 1:y_img_right_new, abs(bb_right(2):x_img_right_new+abs(bb_right(2)-1 = img_right_new    
    color_left(offset(1):(size(img1,1)+offset(1)-1),1:size(img1,2))=img1(:,:);
    color_right(1:size(img_right_new,1),abs(bb_right(2)):(size(img_right_new,2)+abs(bb_right(2))-1))=img_right_new(:,:);
end

if ((offset(1)==0) && (offset(2)>0))% if only x has offset
% color_left: 1:y_left_image, minx:x_left_image+minx-1= img1
% color_right: bb_right(1):y_img_right_new+bb_right(1)-1, 1:x_img_right_new = img_right_new
    color_left(1:size(img1,1),offset(2):(size(img1,2)+offset(2)-1))=img1(:,:);
    color_right(bb_right(1):(size(img_right_new,1)+bb_right(1)-1),1:size(img_right_new,2))=img_right_new(:,:);
end
        
if ((offset(1)==0) && (offset(2)==0))% if both x and y have no offset
    color_left(1:size(img1,1),1:size(img1,2))=img1(:,:);
    color_right(bb_right(1):(size(img_right_new,1)+bb_right(1)-1),bb_right(2):(size(img_right_new,2)+bb_right(2)-1))=img_right_new(:,:);
end
% color_left: 1:y_left_image, 1:x_left_image= img1
% color_right: bb_right(1):y_img_right_new+bb_right(1)-1, bb_right(2):x_img_right_new+bb_right(2)-1 = img_right_new

% the final image is obtained by stitching the two images
% the color is brighter at the overlapping region
final_image=color_left.*0.5+color_right.*0.5; 

figure(4)
imshow(uint8(final_image))

