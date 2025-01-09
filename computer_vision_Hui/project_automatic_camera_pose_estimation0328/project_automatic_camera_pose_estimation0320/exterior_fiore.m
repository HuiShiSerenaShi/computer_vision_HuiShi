function [G, s] = exterior_fiore(A,model3d,data2d);
%_EXTERIOR_FIORE Solve exterior orientation with Fiore's algorithm
%  
% Algorithm ref.: Fiore

% Author: A. Fusiello, 2006

if A(3,3)~=1
  error('A deve essere normalizzata'); % A must be normalized
end

% change to normalized coordinates (or image coordinates) 
m = pt(inv(A),data2d);

% convert to homogeneous
m = [m;ones(1,(size(m,2)))];


S = [model3d; ones(1,(size(model3d,2)))]; % model3d 3*100 底下加一行1 成为4*100
[U, X, V] = svd (S);
i = rank(S);
V2 = V(:,i+1:end);

numP = size(data2d,2);
D = [];

% can be done without for???
for i = 1:numP % 每个点迭代
  D =  [D
        zeros(3,i-1) m(:,i) zeros(3,numP-i)];
end
% D + 3*（i-1）个0 + 3*i个 2d点齐次坐标+ 3*（点总数-i）个0
L = (kron(V2',eye(3))*D);
z = ns(L); % z is scale factor


% il fattore di scale puo' essere negativo, ma se la matrice degli
% intrinseci e' normalizzata correttamente, le depth sono positive!
% the scale factor can be negative, but if the matrix of
% intrinsics is normalized correctly, depths are positive!
z = z * sign(z(1)); % sign +1 -1 0

% sanity check
% norm(L*z,'fro');
% norm((vtrans(D * z,3) * V2),'fro');
% norm(S * V2,'fro');

[G1,s,res1] = absolute(vtrans(D *  z,3),model3d,'scale');
% % % $$$ 
% % [G2,s,res2] = absolute(vtrans(D * -z,3),model3d,'scale');
% % % $$$ 
% %  if (res1<res2)
% %   G = G1;
% %   else
% %     G = G2;
% %  end
% % % $$$  

G = G1;




