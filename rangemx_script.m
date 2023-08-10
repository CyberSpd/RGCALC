clear;
clc;

% ********************************************************************
%
%     Matlab script used to test the rangemx routine
%
%     rangemx.mexmaci64 is a Matlab mex driver for Fortran program RGCALC 
%
%     Ref.: NRL Report 7448 
%
%           A Fortran Computer Program to Calculate the Range of a Pulse
%           Radar
%
%           L. V. Blake  August 28, 1972
%
%
%     Matlab 2022a update 7
%     Intel oneapi 2023.2.0 (ifort) fortran compiler 
%     Mac OS Monterey v. 12.6.8
%
%
% ********************************************************************

% Radar exemple on page 14 of Blake's NRL Report 

s_n = 'Fictitious Microwave Volume-Scan Radar';      % Radar name
s_pt = '1200.0';   % Peak Pulse Power (kilowatts)
s_tau = '60.0';     % Pulse Duration (usec)
s_gt = '34.0';     % Transmit Antenna Gain (dB)
s_gr = '34.0';     % Receive Antenna Gain (dB)
s_fm = '2850.0';   % Frequency (MHz) 
s_anf = '3.0';     % Receiver Noise Figure (dB) 
s_cb = '1.5';      % Bandwidth Correction factor (dB)
s_ala = '3.0';     % Antenna Ohmic Loss (dB)
s_alt = '0.5';     % Transmit Transmission Line Loss (dB)
s_alr = '1.2';     % Receive Transmission Line Loss (dB)
s_alp = '3.2';     % Scanning-Antenna Pattern Loss (dB)
s_alx = '0.7';     % Miscellaneous Loss (dB)

%------------------------------------------------------------------
% Use a dialog box to get input
%------------------------------------------------------------------

headerstr = 'Radar Parameters Page 1';
promptstr = {'Radar name','Peak Pulse Power (kW)', 'Pulse Duration (usec)',...
      'Transmit Antenna Gain (dB)',...
      'Receive Antenna Gain (dB)', 'Frequency (MHz)',...
      'Receiver Noise Figure (dB)','Bandwidth Correction factor (dB)',...
      'Antenna Ohmic Loss (dB)','Transmit Transmission Line Loss (dB)',...
      'Receive Transmission Line Loss (dB)','Scanning-Antenna Pattern Loss (dB)',...
      'Miscellaneous Loss (dB)'}; 

defaultstr = {s_n, s_pt,s_tau, s_gt,  s_gr, s_fm, ...
      s_anf,s_cb,s_ala,s_alt,s_alr,s_alp,s_alx};
response = inputdlg(promptstr, headerstr, 1, defaultstr);
fields = {'s_n','s_pt', 's_tau', 's_gt',  's_gr', 's_fm', ...
      's_anf','s_cb','s_ala','s_alt','s_alr','s_alp','s_alx'};
input = cell2struct(response,fields,1);

s_name = input.s_n;
n_pt = str2double(input.s_pt);
n_tau = str2double(input.s_tau);
n_gt = str2double(input.s_gt);
n_gr= str2double(input.s_gr);
n_fm = str2double(input.s_fm);
n_anf = str2double(input.s_anf);
n_cb = str2double(input.s_cb);
n_ala=str2double(input.s_ala);
n_alt=str2double(input.s_alt);
n_alr=str2double(input.s_alr);
n_alp=str2double(input.s_alp);
n_alx = str2double(input.s_alx);

clear input response fields default prompt title;

s_np = '2';     % Number of Pulses Integrated (ignored if Swerling 6-7)
s_pd = '0.9';    % Probability of Detection  (SNDB if case 6)
s_fa = '6.0';   % False-Alarm Probability (Negative Power of Ten) (SNDB if case 7)
s_sig = '1.0';   % Target Cross Section (Square Meters)
s_el = '0.40';   % Target Elevation Angle (Degrees)
s_ns = '1';      % Average Solar and Galactic Noise Assumed (-1,0,1)
s_ka = '5';      % Swerling Case 0,1,2,3,4,5,6,7
s_rhofac = '1';  % Water-vapor density mult.

headerstr = 'Radar Parameters Page 2';
promptstr = {'Number of Pulses Integrated', 'Probability of Detection ',...
      'False-Alarm Probability ', 'Target Cross Section (Square Meters)',...
      'Target Elevation Angle (Degrees)','Average Solar and Galactic Noise Assumed',...
      'Swerling Case', 'Water-vapor density mult.'};
defaultstr = {s_np, s_pd, s_fa, s_sig, s_el, s_ns, s_ka, s_rhofac};
response = inputdlg(promptstr, headerstr, 1, defaultstr);
fields = {'s_np','s_pd','s_fa','s_sig','s_el','s_ns','s_ka','s_rhofac'};
input = cell2struct(response,fields,1);

%------------------------------------------------------------------
% Convert cell structure created by dialog box back to numbers
%------------------------------------------------------------------

n_np = str2double(input.s_np);
n_pd = str2double(input.s_pd);
n_fa = str2double(input.s_fa);
n_sig = str2double(input.s_sig);
n_el = str2double(input.s_el);
n_ns = str2double(input.s_ns);
n_ka = str2double(input.s_ka);
n_rhofac = str2double(input.s_rhofac);

clear input response fields default prompt title;

radar_name = s_name;

radar_param(1) = n_pt;    % Peak Pulse Power (kW)
radar_param(2) = n_tau;    % Pulse Duration (usec)
radar_param(3) = n_gt;    % Transmit Antenna Gain (dB)
radar_param(4) = n_gr;    % Receive Antenna Gain (dB)
radar_param(5) = n_fm;    % Frequency (MHz) 
radar_param(6) = n_anf;    % Receiver Noise Figure (dB) 
radar_param(7) = n_cb;    % Bandwidth Correction factor (dB)
radar_param(8) = n_ala;    % Antenna Ohmic Loss (dB)
radar_param(9) = n_alt;    % Transmit Transmission Line Loss (dB)
radar_param(10) = n_alr;    % Receive Transmission Line Loss (dB)
radar_param(11) = n_alp;   % Scanning-Antenna Pattern Loss (dB)
radar_param(12) = n_alx;   % Miscellaneous Loss (dB)
radar_param(13) = n_np;   % Number of Pulses Integrated (ignored if Swerling 6-7)
radar_param(14) = n_pd;   % Probability of Detection  (SNDB if case 6)
radar_param(15) = n_fa;   % False-Alarm Probability (Negative Power of Ten) (SNDB if case 7)
radar_param(16) = n_sig;   % Target Cross Section (Square Meters)
radar_param(17) = n_el;   % Target Elevation Angle (Degrees)
radar_param(18) = n_ns;   % Average Solar and Galactic Noise Assumed (-1,0,1)
radar_param(19) = n_ka;   % Swerling Case 0,1,2,3,4,5,6,7
radar_param(20) = n_rhofac;   % Water-vapor density multiplicator

% ********** call to RGCALC fortran program - input : radar_param (1x19) ***************************

radar_rng = rangemx(radar_param);  %  CALL RGCALC FORTRAN PROGRAM 
clear mex; % important  - prevent variable persitence issue in multiple call to fortran subroutines !!!!

% *********** return : radar_rng (12x75) ***********************

 IS1 = '  RADAR NAME OR DESCRIPTION -- \n';
 IS1N = radar_name; 
 IST = '  RADAR AND TARGET PARAMETERS (INPUTS) -- \n';
 IS2 = sprintf('  PULSE POWER, KW ...............................%11.1f\n',radar_rng(1,1)); 
 IS3 = sprintf('  PULSE LENGTH, MICROSEC ........................%11.1f\n',radar_rng(1,2)); 
 IS4 = sprintf('  TRANSMIT ANTENNA GAIN, DB .....................%11.1f\n',radar_rng(1,3)); 
 IS5 = sprintf('  RECEIVE ANTENNA GAIN, DB ......................%11.1f\n',radar_rng(1,4)); 
 IS6 = sprintf('  FREQUENCY, MHZ ................................%11.1f\n',radar_rng(1,5)); 
 IS7 = sprintf('  RECEIVER NOISE FACTORE (FIGURE), DB ...........%11.1f\n',radar_rng(1,6)); 
 IS8 = sprintf('  BANDWIDTH CORRECTION FACTOR, DB ...............%11.1f\n',radar_rng(1,7)); 
 IS9 = sprintf('  ANTENNA OHMIC LOSS, DB ........................%11.1f\n',radar_rng(1,8)); 
 IS10 = sprintf('  TRANSMIT TRANSMISSION LINE LOSS, DB ...........%11.1f\n',radar_rng(1,9)); 
 IS11 = sprintf('  RECEIVE  TRANSMISSION LINE LOSS, DB ...........%11.1f\n',radar_rng(1,10)); 
 IS12 = sprintf('  SCANNING-ANTENNA PATTERN LOSS, DB .............%11.1f\n',radar_rng(1,11)); 
 IS13 = sprintf('  MISCELLANEOUS LOSS, DB ........................%11.1f\n',radar_rng(1,12)); 
 IS14 = sprintf('  NUMBER OF PULSES INTEGRATED....................        %3d\n',radar_rng(1,13)); 
 IS15 = sprintf('  PROBABILITY OF DETECTION ......................%11.1f\n',radar_rng(1,14)); 
 IS16 = sprintf('  FALSE-ALARM PROBABILITY .......................%11.1f\n',radar_rng(1,15)); 
 IS17 = sprintf('  TARGET CROSS SECTION, SQUARE-METERS ...........%11.1f\n',radar_rng(1,16)); 
 IS18 = sprintf('  TARGET ELEVATION ANGLE, DEGREES ...............%11.1f\n',radar_rng(1,17)); 
 if radar_rng(1,18) == -1  
    ISGN = '  MINIMUM SOLAR AND GALACTIC NOISE ASSUMED\n';
 end
 if radar_rng(1,18) == 0 
    ISGN = '  AVERAGE SOLAR AND GALACTIC NOISE ASSUMED\n';
 end
 if radar_rng(1,18) == 1  
    ISGN = '  MAXIMUM SOLAR AND GALACTIC NOISE ASSUMED\n';
 end 

 ISPPF = '  PATTERN-PROPAGATION FACTORS ASSUMED = 1. \n'; 

 SSP = '  ';  
 SRT = '\n';  % return to next line     

 STRa =  sprintf([SRT IS1 SRT SSP IS1N SRT SRT IST SRT IS2 IS3 IS4 IS5 IS6 IS7 IS8 IS9 IS10 IS11 IS12 IS13 ...
                           IS14 IS15 IS16 IS17 IS18 ISGN ISPPF]);

 S0 = '         ********************************* \n'; 
 S1 = '  CALCULATED QUANTITIES (OUTPUTS) --                           \n';
 S3 = '  NOISE TEMPERATURES, DEGREES KELVIN --                    \n';
 S5 = sprintf('         ANTENNA (TA) ...........................%11.1f\n',radar_rng(2,1));
 S6 = sprintf('         RECEIVING TRANSMISSION LINE (TR) .......%11.1f\n',radar_rng(2,2));
 S7 = sprintf('         RECEVER (TE) ...........................%11.1f\n',radar_rng(2,3));
 S8 = sprintf('         TE X LINE-LOSS FACTOR = TEI ............%11.1f\n',radar_rng(2,4));
 S9 = sprintf('         SYSTEM (TA + TR + TEI) .................%11.1f\n',radar_rng(2,5));  
 S10 = sprintf('  TWO-WAY ATTENUATION THROUGH ENTIRE TROPOSPHERE, DB%8.1f\n',radar_rng(2,6));
 S12 = sprintf('  DETECTION THRESHOLD %11.2f\n',radar_rng(2,7));       
 S14 = '  SWERLING      SIGNAL-         TROPOSHERIC      RANGE,    \n';
 S15 = '  FLUCTUATION   TO-NOISE        ATTENUATION,     NAUTICAL  \n';  
 S16 = '  CASE          RATIO, DB       DECIBELS         MILES     \n';  
 S17 = '  ---------     ----------      -----------      --------  \n';

 SP10 = '          ';  
 SP05 = '     ';
 SRT = '\n'; 

 switch radar_rng(1,19)     
    case 0                               
        k = 0;
        STRN = sprintf('      %1d          %6.2f           %6.2f         %6.1f \n',k,radar_rng(2,9),radar_rng(2,10),radar_rng(2,11));
    case 1            
        k = 1;                              
        STRN = sprintf('      %1d          %6.2f           %6.2f         %6.1f \n',k,radar_rng(2,9),radar_rng(2,10),radar_rng(2,11));
    case 2      
        k = 2;
        STRN = sprintf('      %1d          %6.2f           %6.2f         %6.1f \n',k,radar_rng(2,9),radar_rng(2,10),radar_rng(2,11));
    case 3     
        k = 3;
        STRN = sprintf('      %1d          %6.2f           %6.2f         %6.1f \n',k,radar_rng(2,9),radar_rng(2,10),radar_rng(2,11));
    case 4        
        k = 4;
        STRN = sprintf('      %1d          %6.2f           %6.2f         %6.1f \n',k,radar_rng(2,9),radar_rng(2,10),radar_rng(2,11));
    case 5
        k0 = 0; 
        STRN0 = sprintf('      %1d          %6.2f           %6.2f         %6.1f \n',k0,radar_rng(2,9),radar_rng(2,10),radar_rng(2,11));
        k1 = 1;
        STRN1 = sprintf('      %1d          %6.2f           %6.2f         %6.1f \n',k1,radar_rng(2,12),radar_rng(2,13),radar_rng(2,14));
        k2 = 2;
        STRN2 = sprintf('      %1d          %6.2f           %6.2f         %6.1f \n',k2,radar_rng(2,15),radar_rng(2,16),radar_rng(2,17));
        k3 = 3;
        STRN3 = sprintf('      %1d          %6.2f           %6.2f         %6.1f \n',k3,radar_rng(2,18),radar_rng(2,19),radar_rng(2,20));
        k4 = 4;   
        STRN4 = sprintf('      %1d          %6.2f           %6.2f         %6.1f \n',k4,radar_rng(2,21),radar_rng(2,22),radar_rng(2,23));
    case 6
        formatSpec1 = '  RANGE = %6.1f N. MI.,  TROPOSPHERIC ATTENUATION =  %6.2f DB \n';
        formatSpec2 = '  FOR SPECIFIED SIGNAL-TO-NOISE RATIO = %6.2f DB \n';
        STRN6a = sprintf(formatSpec1, radar_rng(2,11),radar_rng(2,10));
        STRN6b = sprintf(formatSpec2, radar_rng(2,9));
    case 7 
        formatSpec1 = '  RANGE = %6.1f N. MI.,  TROPOSPHERIC ATTENUATION =  %6.2f DB \n';
        formatSpec2 = '  FOR SPECIFIED SIGNAL-TO-NOISE RATIO = %6.2f DB \n';
        STRN6a = sprintf(formatSpec1, radar_rng(2,11),radar_rng(2,10));
        STRN6b = sprintf(formatSpec2, radar_rng(2,9));
        STRN7a = sprintf(formatSpec1, radar_rng(2,14),radar_rng(2,13));
        STRN7b = sprintf(formatSpec2, radar_rng(2,12));
 end  

 if radar_rng(1,19) < 5         
    STRb = sprintf([SRT S0 SRT S1 SRT S3 SRT S5 S6 S7 S8 S9 SRT S10 SRT S14 S15 S16 S17 SRT STRN]);                
 end
    
 if radar_rng(1,19) == 5    
    STRb = sprintf([SRT S0 SRT S1 SRT S3 SRT S5 S6 S7 S8 S9 SRT S10 SRT S14 S15 S16 S17 SRT STRN0 SRT STRN1 SRT STRN2 SRT STRN3 SRT STRN4]);
 end     

 if radar_rng(1,19) == 6    
    STRb = sprintf([SRT S0 SRT S1 SRT S3 SRT S5 S6 S7 S8 S9 SRT S10 SRT SRT STRN6a SRT STRN6b]);  
 end

 if radar_rng(1,19) == 7    
     STRb = sprintf([SRT S0 SRT S1 SRT S3 SRT S5 S6 S7 S8 S9 SRT S10 SRT SRT STRN6a SRT STRN6b SRT SRT STRN7a SRT STRN7b]);
 end


if radar_rng(1,21) > 0  % check if input value error for PN, PD and FA
    disp('PN, PD or FA input value range error - calculation aborted')
else
    STRout = append(STRa,STRb);
    disp(STRout);
end
