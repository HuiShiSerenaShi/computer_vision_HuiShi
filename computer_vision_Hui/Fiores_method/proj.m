function [u,v] = proj(P,c3d)
% PROJ : compute perspective projection (from 3D to pixel coordinates)

h3d =[c3d ones(size(c3d,1),1)]';
h2d = P*h3d ;
c2d = h2d(1:2,:)./ [h2d(3,:)' h2d(3,:)']'; 
u = round(c2d(1,:))'; % 舍入至最近的小数或整数 四舍五入
v = round(c2d(2,:))'; 