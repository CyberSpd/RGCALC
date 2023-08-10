clear;
clc;

% ********************************************************************
%
%     Matlab script used to test the marswrmx routine
%
%     marswrmx.mexmaci64 is a Matlab mex driver for Fortran subroutine MARSWR  
%
%     Ref.: NRL Report 7448 
%
%           A Fortran Computer Program to Calculate the Range of a Pulse
%           Radar
%
%           L. V. Blake  August 28, 1972
%           
%     Fehlner's MARCUM subroutine renamed MARSWR and adapted by L.V. Blake
%     for the RGCALC program 
%
%
%     Matlab 2022a update 7
%     Intel oneapi 2023.2.0 (ifort) fortran compiler 
%     Mac OS Monterey v. 12.6.8
%
%
% ********************************************************************

% input array (1X4)   

radar_param(1,1) = 12.86; % Signal-to-noise ratio (dB)
radar_param(1,2) = 2;    % N pulse integrated
radar_param(1,3) = 6;     % False-Alarm probability
radar_param(1,4) = 4;     % Swerling case (0-4)

% ************** call to marswmx mex routine *****************************

det_prob = marswrmx(radar_param);  %  call mex routine of MARSWR.FOR
clear mex % Important - prevent variable persitence for successive mex calls

% ************************************************************************

%     MARSWR OUTPUT VALUES in 2X6 array
%   

fprintf(' ***************************************************  \n');
fprintf('   Matlab marswrmx mex (Fortran MARSWR subroutine)    \n');
fprintf(' ***************************************************  \n');
fprintf('   Input : Signal-to-noise Ratio (dB) ...... %6.1f\n',det_prob(1,1));  % probability of detection
fprintf('   Input : Number of Pulses Integrated ..... %6.1d\n',det_prob(1,2));  % threshold 
fprintf('   Input : False-Alarm Probability ......... %6.1f\n',det_prob(1,3));  % Return 1 if error 
fprintf('   Input : Swerling Case ................... %6.1d\n',det_prob(1,4));  % Return 1 if error 
fprintf('   Output : Probability of Detection ....... %6.1f\n',det_prob(2,1));  % probability of detection
fprintf('   Output : Threshold (dB) ................. %6.1f\n',det_prob(2,2));  % threshold 
fprintf('   Output :Fortran MARSWR.FOR error status . %6.1d\n',det_prob(2,3));  % Return 1 if error 


