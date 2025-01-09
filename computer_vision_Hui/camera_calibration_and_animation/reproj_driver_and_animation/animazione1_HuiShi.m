
% Exercise on 2D image animation
close all
clear all
cali = load(['Calib_Results.mat']);
camera = load(['Calib_Results.mat']);

% load the image
ImageIN=imread('Image16.tif'); 

% 3D Points and the camera parameters
X=cali.X_16;
T=camera.Tc_16;
om=camera.omc_16; % Rc_16 = rodrigues(omc_16), omc_16 is rotation vector
f=camera.fc; % The focal length in pixels is stored in the 2x1 vector fc.
c=camera.cc; % The principal point coordinates are stored in the 2x1 vector cc.
k=camera.kc; % The image distortion coefficients (radial and tangential distortions) are stored in the 5x1 vector kc

%Animation, 2 stars travel at different direction on the chessboard
figure(1)
imshow(ImageIN);
hold on
hLine = line('XData',0, 'YData',0, 'Color','magenta', 'Marker','pentagram', 'MarkerSize',3, 'LineWidth',3);
hLine_1 = line('XData',0, 'YData',0, 'Color','magenta', 'Marker','pentagram', 'MarkerSize',3, 'LineWidth',3);

while true
    for i = 1:size(X,2)
        % first star(point)
        point=[X(1,i); X(2,i); X(3,i)] 
        [xp_anim,dxpdom,dxpdT,dxpdf,dxpdc,dxpdk]=project_points(point,om,T,f,c,k);
        set(hLine, 'XData',xp_anim(1), 'YData',xp_anim(2))
        % second star(point)
        point_1=[X(1,size(X,2)-i+1); X(2,size(X,2)-i+1); X(3,size(X,2)-i+1)] 
        [xp_anim_1,dxpdom,dxpdT,dxpdf,dxpdc,dxpdk]=project_points(point_1,om,T,f,c,k);
        set(hLine_1, 'XData',xp_anim_1(1), 'YData',xp_anim_1(2))
        drawnow
        pause(0.1);
    end
end