%**************************************************************************
% Fourier Ptychographic Imaging for transparent objects, transmitted light
% Config file
%
% Author: Alankar Kotwal <alankarkotwal13@gmail.com>
%
% Make sure you run this file from the lvp-imaging directory
%**************************************************************************

% Housekeeping

imageFolder = '20141129_Transparency'; % Folder for saving the input images

%**************************************************************************

% Pre-processing

regImages = 'no';                        % Should I perform registration?
regType = 'Multimodal';                   % Type of registration to be used
metricType = 'affine';
cropImages = 'yes';
fixedImageName = '20141129_Transparency_45.png';
tempImageDir = 'temp/';
xMargin = 100;                            % Crop margin
yMargin = 100;

%**************************************************************************

% Imaging system specs

nX = 8;                         % Number of LEDs along X
nY = 8;                         % Number of LEDs along Y
xSep = 0.4;                     % Separation of the LEDs along X, in cm
ySep = 0.4;                     % Separation of the LEDs along Y, in cm
h = 21.9;                       % Height of the sample from the LED array,
                                % again in cm
lensRad = 1.3;                  % Lens radius in cm
lam = 632;                      % Wavelength in nm
foc = 4.9;                      % Focal length of the objective for lambda
pixSize = 5;                    % Pixel size for the sensor, um
magnification = 3;              % Imaging system magnification, f_obj/f_eye

%**************************************************************************

% Output stuff
scale = 10;                     % Factor by which you want to scale the
                                % image pixels
maxIter = 5;                    % Maximum number of iterations