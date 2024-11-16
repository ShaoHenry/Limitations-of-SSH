% The following script allows you to run simulations with different setups
% and then record the error curve.
% 
% Copyright © Shaoheng Xu (shaoheng.xu@anu.edu.au)
% Last modified on: 18 May 2023

close all;  clear;  clc;

% ----------------------------------------------------------------------- %
% -------------------------- Set Parameters ----------------------------- %
% ----------------------------------------------------------------------- %

% Set the range of the radius of the reproduction plane.
ReprodRad = 1 : 0.1 : 2;

%%
% ----------------------------------------------------------------------- %
% -------------------------- Run Simulation ----------------------------- %
% ----------------------------------------------------------------------- %

% Initialize the App.
myapp = SSH_simulation_interior();
% Stop MATLAB execution temporarily for a few seconds, allowing MATLAB to
% open the App window.
pause(3);

% Create an empty vector to store the error curve.
noOfIter = numel(ReprodRad);
errCurve = NaN(1, noOfIter);

% Initialize the waitbar.
wb = waitbar(0, 'Please wait...');

for irad = 1 : noOfIter
    % Update the waitbar
    waitbar(irad/noOfIter, wb, 'Simulating...');

    % Update the radius of the reproduction plane.
    myapp.rtgt = ReprodRad(irad);
    
    % Run simulation.
    Step1_obtain_inputs(myapp);
    Step2_get_parameters(myapp);
    Step3_set_up_planes(myapp);
    Step4_reproduce_soundfield(myapp);
    Step5_plotting(myapp);

    % Save the error data.
    errCurve(irad) = myapp.avgErrdB;
end

% ----------------------------------------------------------------------- %

% Close the waitbar.
close(wb);
% Close the App.
myapp.delete;

%%
% ----------------------------------------------------------------------- %
% -------------------------- Plot Error Curve --------------------------- %
% ----------------------------------------------------------------------- %

figure;
plot(ReprodRad, errCurve);
xlabel('The Radius of Reproduction Plane');
ylabel('The Averaged Error (in dB)');
title('The Averaged Error of the Reproduction Plane with Different Radius');
grid on;

%%
% ----------------------------------------------------------------------- %
% -------------------------- Save Error Curve --------------------------- %
% ----------------------------------------------------------------------- %

foldername = [datestr(now, 'mm-dd-yy HH-MM-SS'), ' Error Curve'];
mkdir(foldername);
filename = [foldername, '\Error Curve.mat'];
save(filename, 'errCurve');
