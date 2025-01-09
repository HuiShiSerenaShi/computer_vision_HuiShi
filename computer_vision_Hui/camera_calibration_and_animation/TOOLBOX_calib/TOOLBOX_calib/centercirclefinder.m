function [xc,good,bad] = centercirclefinder(xt,I,wintx,winty);


%xt = [521.6249 ; 469.9916];
%wintx = 60;
%winty = 60;


xt = xt';
xt = fliplr(xt);


if nargin < 4,
   winty = 5;
   if nargin < 3,
      wintx = 5;
   end;
end;


if nargin < 6,
   wx2 = -1;
   wy2 = -1;
end;


mask = ones(2*wintx + 1,2*winty + 1);
%mask = exp(-((-wintx:wintx)'/(wintx)).^2) * exp(-((-winty:winty)/(winty)).^2);



offx = [-wintx:wintx]'*ones(1,2*winty+1);
offy = ones(2*wintx+1,1)*[-winty:winty];

resolution = 0.0001;

MaxIter = 15;

[nx,ny] = size(I);
N = size(xt,1);

xc = xt; % first guess... they don't move !!!

type_feat = zeros(1,N);


for i=1:N,
   
   v_extra = resolution + 1; 		% just larger than resolution
   
   compt = 0; 				% no iteration yet
   
   while (norm(v_extra) > resolution) & (compt<MaxIter),
      
      cIx = xc(i,1); 			%
      cIy = xc(i,2); 			% Coords. of the point
      crIx = round(cIx); 		% on the initial image
      crIy = round(cIy); 		%      
      itIx = cIx - crIx; 		% Coefficients
      itIy = cIy - crIy; 		% to compute
      if itIx > 0, 			% the sub pixel
	 vIx = [itIx 1-itIx 0]'; 	% accuracy.
      else
	 vIx = [0 1+itIx -itIx]';
      end;
      if itIy > 0,
	 vIy = [itIy 1-itIy 0];
      else
	 vIy = [0 1+itIy -itIy];
      end;

      
      % What if the sub image is not in?
      
      if (crIx-wintx-2 < 1), xmin=1; xmax = 2*wintx+5;
      elseif (crIx+wintx+2 > nx), xmax = nx; xmin = nx-2*wintx-4;
      else
	 xmin = crIx-wintx-2; xmax = crIx+wintx+2;
      end;

      if (crIy-winty-2 < 1), ymin=1; ymax = 2*winty+5;
      elseif (crIy+winty+2 > ny), ymax = ny; ymin = ny-2*winty-4;
      else
	 ymin = crIy-winty-2; ymax = crIy+winty+2;
      end;
      
      
      SI = I(xmin:xmax,ymin:ymax); % The necessary neighborhood
      SI = conv2(conv2(SI,vIx,'same'),vIy,'same');
      SI = SI(2:2*wintx+4,2:2*winty+4); % The subpixel interpolated neighborhood
      [gy,gx] = gradient(SI); 		% The gradient image
      gx = gx(2:2*wintx+2,2:2*winty+2); % extraction of the useful parts only
      gy = gy(2:2*wintx+2,2:2*winty+2); % of the gradients
      
      px = cIx + offx;
      py = cIy + offy;
      
      gxx = gx .* gx .* mask;
      gyy = gy .* gy .* mask;
      gxy = gx .* gy .* mask;
   
      
      bb = [sum(sum(gyy .* px - gxy .* py)); sum(sum(-gxy .* px + gxx .* py))];
      
      a = sum(sum(gyy));
      b = -sum(sum(gxy));
      c = sum(sum(gxx));
      
      dt = a*c - b^2;
      
      xc2 = [c*bb(1)-b*bb(2) a*bb(2)-b*bb(1)]/dt;
      
      
      %keyboard;
      
      
      %keyboard;
      
%      G = [a b;b c];
%      [U,S,V]  = svd(G);


%      if S(1,1)/S(2,2) > 150,
%	 bb2 = U'*bb;
%	 xc2 = (V*[bb2(1)/S(1,1) ;0])';
%      else
%	 xc2 = [c*bb(1)-b*bb(2) a*bb(2)-b*bb(1)]/dt;
%      end;
      
      
      %if (abs(a)> 50*abs(c)),
%	 xc2 = [(c*bb(1)-b*bb(2))/dt xc(i,2)];
%      elseif (abs(c)> 50*abs(a))
%	 xc2 = [xc(i,1) (a*bb(2)-b*bb(1))/dt];
%      else
%	 xc2 = [c*bb(1)-b*bb(2) a*bb(2)-b*bb(1)]/dt;
%      end;
      
      %keyboard;
      
      v_extra = xc(i,:) - xc2;
      
      xc(i,:) = xc2;
      
%      keyboard;

      compt = compt + 1;
      
   end
end;


% check for points that diverge:

delta_x = xc(:,1) - xt(:,1);
delta_y = xc(:,2) - xt(:,2);

%keyboard;


bad = (abs(delta_x) > wintx) | (abs(delta_y) > winty);
good = ~bad;
in_bad = find(bad);

% For the diverged points, keep the original guesses:

xc(in_bad,:) = xt(in_bad,:);

xc = fliplr(xc);
xc = xc';

bad = bad';
good = good';
