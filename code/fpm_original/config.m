%**************************************************************************
% Fourier Ptychographic Imaging
% Config file
%
% Author: Alankar Kotwal <alankarkotwal13@gmail.com>
%
% Make sure you run this file from the lvp-imaging directory
%**************************************************************************

% Housekeeping

imageFolder = 'images/test';    % Folder for saving the input images

%**************************************************************************

% Imaging system specs

nX = 32;                        % Number of LEDs along X
nY = 32;                        % Number of LEDs along Y
xSep = 0.5;                     % Separation of the LEDs along X
ySep = 0.5;                     % Separation of the LEDs along Y

%**************************************************************************

% Serial stuff

autodetectSerialPort = 0;       % Choose if you want to autodetect serial
                                % port. Still to be implemented
serialPort = '/dev/ttyUSB0';    % If above is 'no', port name

%**************************************************************************

% Webcam stuff

webcamName = 'linuxvideo';      % Webcam name used by Matlab, find this
                                % using imaqtool
webcamNo = 1;                   % If the above isn't 'winvideo' or
                                % 'linuxvideo': 1. Otherwise: 0