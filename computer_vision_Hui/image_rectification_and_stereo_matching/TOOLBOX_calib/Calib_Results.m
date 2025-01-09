% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly excecuted under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 3095.622702177486190 ; 3115.674216108103792 ];

%-- Principal point:
cc = [ 1524.316156134819039 ; 2161.199172729241582 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ 0.074377929695136 ; -0.106180840071249 ; 0.016155453082716 ; -0.006493070783822 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 54.787525614320451 ; 57.190257924211672 ];

%-- Principal point uncertainty:
cc_error = [ 39.517937224787538 ; 48.366594471286099 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.033925356584000 ; 0.056607609919080 ; 0.006051045474856 ; 0.003024777043698 ; 0.000000000000000 ];

%-- Image size:
nx = 3024;
ny = 4032;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 5;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ -2.034438e+00 ; -2.046020e+00 ; 6.878867e-02 ];
Tc_1  = [ -2.929857e+01 ; -1.821408e+02 ; 4.107612e+02 ];
omc_error_1 = [ 1.157568e-02 ; 9.644762e-03 ; 2.122640e-02 ];
Tc_error_1  = [ 5.361503e+00 ; 6.406733e+00 ; 7.577603e+00 ];

%-- Image #2:
omc_2 = [ -2.228371e+00 ; -2.105851e+00 ; -3.405853e-01 ];
Tc_2  = [ -6.561832e+00 ; -1.741497e+02 ; 3.667988e+02 ];
omc_error_2 = [ 9.457171e-03 ; 1.205296e-02 ; 2.021437e-02 ];
Tc_error_2  = [ 4.926713e+00 ; 5.770253e+00 ; 6.972572e+00 ];

%-- Image #3:
omc_3 = [ -1.635106e+00 ; -1.884634e+00 ; 5.169041e-01 ];
Tc_3  = [ 8.317352e+00 ; -1.741657e+02 ; 3.803496e+02 ];
omc_error_3 = [ 1.192413e-02 ; 8.243443e-03 ; 1.680455e-02 ];
Tc_error_3  = [ 5.019255e+00 ; 5.894133e+00 ; 6.589395e+00 ];

%-- Image #4:
omc_4 = [ -2.182503e+00 ; -2.228236e+00 ; 2.899552e-01 ];
Tc_4  = [ -3.252411e+01 ; -1.597556e+02 ; 4.020137e+02 ];
omc_error_4 = [ 1.025359e-02 ; 7.377644e-03 ; 1.982835e-02 ];
Tc_error_4  = [ 5.203349e+00 ; 6.155540e+00 ; 7.095635e+00 ];

%-- Image #5:
omc_5 = [ -2.214306e+00 ; -2.053954e+00 ; 1.308203e-01 ];
Tc_5  = [ -3.087251e+00 ; -1.854458e+02 ; 4.041268e+02 ];
omc_error_5 = [ 1.146182e-02 ; 9.497374e-03 ; 2.014637e-02 ];
Tc_error_5  = [ 5.321815e+00 ; 6.290199e+00 ; 7.383550e+00 ];

