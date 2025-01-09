% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly excecuted under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 657.643747845561506 ; 658.041127600232585 ];

%-- Principal point:
cc = [ 303.192392394826754 ; 242.555660143265328 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ -0.256098158881069 ; 0.130887313444893 ; -0.000191177536109 ; 0.000038483262494 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 0.402428214743973 ; 0.430564421569780 ];

%-- Principal point uncertainty:
cc_error = [ 0.818599407192129 ; 0.748804468672535 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.003142071612697 ; 0.012508262165280 ; 0.000169370366343 ; 0.000167547308565 ; 0.000000000000000 ];

%-- Image size:
nx = 640;
ny = 480;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 20;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ 1.654720e+00 ; 1.651630e+00 ; -6.697971e-01 ];
Tc_1  = [ -1.778479e+02 ; -8.365803e+01 ; 8.532221e+02 ];
omc_error_1 = [ 9.548576e-04 ; 1.234568e-03 ; 1.577699e-03 ];
Tc_error_1  = [ 1.062969e+00 ; 9.798286e-01 ; 5.385138e-01 ];

%-- Image #2:
omc_2 = [ 1.848877e+00 ; 1.900269e+00 ; -3.969660e-01 ];
Tc_2  = [ -1.552066e+02 ; -1.592776e+02 ; 7.578523e+02 ];
omc_error_2 = [ 1.003395e-03 ; 1.226904e-03 ; 1.907818e-03 ];
Tc_error_2  = [ 9.491812e-01 ; 8.686449e-01 ; 5.292989e-01 ];

%-- Image #3:
omc_3 = [ 1.742277e+00 ; 2.077254e+00 ; -5.051086e-01 ];
Tc_3  = [ -1.254892e+02 ; -1.745481e+02 ; 7.757372e+02 ];
omc_error_3 = [ 9.182542e-04 ; 1.299982e-03 ; 1.972192e-03 ];
Tc_error_3  = [ 9.702812e-01 ; 8.889117e-01 ; 5.087806e-01 ];

%-- Image #4:
omc_4 = [ 1.827844e+00 ; 2.116467e+00 ; -1.102882e+00 ];
Tc_4  = [ -6.468451e+01 ; -1.547919e+02 ; 7.793400e+02 ];
omc_error_4 = [ 8.241572e-04 ; 1.346626e-03 ; 1.846835e-03 ];
Tc_error_4  = [ 9.778190e-01 ; 8.872220e-01 ; 4.098788e-01 ];

%-- Image #5:
omc_5 = [ 1.078974e+00 ; 1.922185e+00 ; -2.527138e-01 ];
Tc_5  = [ -9.248733e+01 ; -2.290794e+02 ; 7.369116e+02 ];
omc_error_5 = [ 8.051719e-04 ; 1.256013e-03 ; 1.413680e-03 ];
Tc_error_5  = [ 9.314581e-01 ; 8.465937e-01 ; 5.010164e-01 ];

%-- Image #6:
omc_6 = [ -1.701766e+00 ; -1.929498e+00 ; -7.917741e-01 ];
Tc_6  = [ -1.490441e+02 ; -7.960215e+01 ; 4.451486e+02 ];
omc_error_6 = [ 7.741240e-04 ; 1.253837e-03 ; 1.698282e-03 ];
Tc_error_6  = [ 5.582156e-01 ; 5.234285e-01 ; 4.286888e-01 ];

%-- Image #7:
omc_7 = [ 1.996394e+00 ; 1.931396e+00 ; 1.310790e+00 ];
Tc_7  = [ -8.307616e+01 ; -7.769524e+01 ; 4.404076e+02 ];
omc_error_7 = [ 1.482781e-03 ; 7.611010e-04 ; 1.780786e-03 ];
Tc_error_7  = [ 5.608973e-01 ; 5.115976e-01 ; 4.525427e-01 ];

%-- Image #8:
omc_8 = [ 1.961170e+00 ; 1.824198e+00 ; 1.326282e+00 ];
Tc_8  = [ -1.702794e+02 ; -1.035203e+02 ; 4.623205e+02 ];
omc_error_8 = [ 1.414866e-03 ; 7.761887e-04 ; 1.707630e-03 ];
Tc_error_8  = [ 6.132897e-01 ; 5.558441e-01 ; 5.098307e-01 ];

%-- Image #9:
omc_9 = [ -1.363901e+00 ; -1.980862e+00 ; 3.208860e-01 ];
Tc_9  = [ -2.107848e+00 ; -2.250933e+02 ; 7.289449e+02 ];
omc_error_9 = [ 9.645619e-04 ; 1.238785e-03 ; 1.596300e-03 ];
Tc_error_9  = [ 9.190384e-01 ; 8.338236e-01 ; 5.210277e-01 ];

%-- Image #10:
omc_10 = [ -1.513492e+00 ; -2.087101e+00 ; 1.880738e-01 ];
Tc_10  = [ -2.988523e+01 ; -3.003472e+02 ; 8.605054e+02 ];
omc_error_10 = [ 1.176223e-03 ; 1.408109e-03 ; 2.122553e-03 ];
Tc_error_10  = [ 1.104440e+00 ; 9.911733e-01 ; 6.915382e-01 ];

%-- Image #11:
omc_11 = [ -1.793139e+00 ; -2.065010e+00 ; -4.802063e-01 ];
Tc_11  = [ -1.512820e+02 ; -2.352881e+02 ; 7.050052e+02 ];
omc_error_11 = [ 1.055024e-03 ; 1.328787e-03 ; 2.283924e-03 ];
Tc_error_11  = [ 9.054036e-01 ; 8.487710e-01 ; 6.840629e-01 ];

%-- Image #12:
omc_12 = [ -1.839142e+00 ; -2.087535e+00 ; -5.158613e-01 ];
Tc_12  = [ -1.336743e+02 ; -1.771663e+02 ; 6.051959e+02 ];
omc_error_12 = [ 8.995807e-04 ; 1.277211e-03 ; 2.107455e-03 ];
Tc_error_12  = [ 7.711570e-01 ; 7.176834e-01 ; 5.719655e-01 ];

%-- Image #13:
omc_13 = [ -1.919022e+00 ; -2.116713e+00 ; -5.945150e-01 ];
Tc_13  = [ -1.328659e+02 ; -1.435033e+02 ; 5.450045e+02 ];
omc_error_13 = [ 8.392244e-04 ; 1.264289e-03 ; 2.072060e-03 ];
Tc_error_13  = [ 6.924575e-01 ; 6.424233e-01 ; 5.191203e-01 ];

%-- Image #14:
omc_14 = [ -1.954395e+00 ; -2.124760e+00 ; -5.847839e-01 ];
Tc_14  = [ -1.237533e+02 ; -1.370916e+02 ; 4.910906e+02 ];
omc_error_14 = [ 7.898318e-04 ; 1.239014e-03 ; 2.028494e-03 ];
Tc_error_14  = [ 6.248686e-01 ; 5.783212e-01 ; 4.659138e-01 ];

%-- Image #15:
omc_15 = [ -2.110704e+00 ; -2.253882e+00 ; -4.950597e-01 ];
Tc_15  = [ -1.993040e+02 ; -1.344612e+02 ; 4.752472e+02 ];
omc_error_15 = [ 9.114197e-04 ; 1.159880e-03 ; 2.210196e-03 ];
Tc_error_15  = [ 6.129538e-01 ; 5.736057e-01 ; 5.020580e-01 ];

%-- Image #16:
omc_16 = [ 1.886758e+00 ; 2.335939e+00 ; -1.729953e-01 ];
Tc_16  = [ -1.615402e+01 ; -1.702753e+02 ; 6.958200e+02 ];
omc_error_16 = [ 1.252577e-03 ; 1.323442e-03 ; 2.749214e-03 ];
Tc_error_16  = [ 8.717373e-01 ; 7.911879e-01 ; 5.946044e-01 ];

%-- Image #17:
omc_17 = [ -1.612964e+00 ; -1.953643e+00 ; -3.476711e-01 ];
Tc_17  = [ -1.353877e+02 ; -1.389062e+02 ; 4.903580e+02 ];
omc_error_17 = [ 7.804850e-04 ; 1.194019e-03 ; 1.682703e-03 ];
Tc_error_17  = [ 6.168332e-01 ; 5.736658e-01 ; 4.130544e-01 ];

%-- Image #18:
omc_18 = [ -1.341894e+00 ; -1.693366e+00 ; -2.975759e-01 ];
Tc_18  = [ -1.854450e+02 ; -1.577390e+02 ; 4.415836e+02 ];
omc_error_18 = [ 8.954255e-04 ; 1.160257e-03 ; 1.328883e-03 ];
Tc_error_18  = [ 5.609494e-01 ; 5.230819e-01 ; 4.012705e-01 ];

%-- Image #19:
omc_19 = [ -1.925896e+00 ; -1.838152e+00 ; -1.440606e+00 ];
Tc_19  = [ -1.066810e+02 ; -7.954567e+01 ; 3.343515e+02 ];
omc_error_19 = [ 7.704959e-04 ; 1.358529e-03 ; 1.721752e-03 ];
Tc_error_19  = [ 4.352643e-01 ; 3.991746e-01 ; 3.762850e-01 ];

%-- Image #20:
omc_20 = [ 1.895846e+00 ; 1.593082e+00 ; 1.471977e+00 ];
Tc_20  = [ -1.439836e+02 ; -8.800496e+01 ; 3.964140e+02 ];
omc_error_20 = [ 1.435175e-03 ; 7.937639e-04 ; 1.546516e-03 ];
Tc_error_20  = [ 5.313246e-01 ; 4.757678e-01 ; 4.551943e-01 ];

