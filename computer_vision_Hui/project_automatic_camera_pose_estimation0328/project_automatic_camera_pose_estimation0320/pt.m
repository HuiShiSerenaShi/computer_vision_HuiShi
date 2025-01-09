function mt = pt(H,m);   
%PT applica una trasformazione proiettiva 2D o 3D.
% %PT applies a 2D or 3D projective transformation.
%mt = pt(H,m) applica una omografia H del piano o dello spazio
%proiettivo a un insime di punti m.
%mt = pt(H,m) applies a homography H of the plane or space
% projective to a set of points m.

if sum(size(H)) == 6
  % omografia del piano
  % homography of the plane
  mt = p2t(H,m);
  elseif sum(size(H)) == 8
% omografia dello spazio
% homography of space
  mt = p3t(H,m);
else
  error('Trasformazione non implementata'); %Transform not implemented
end

