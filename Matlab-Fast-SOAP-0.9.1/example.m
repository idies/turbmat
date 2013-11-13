%
% Matlab-Fast-SOAP - a faster Matlab replacement for the default SOAP
% functions
%   
% parseSoapResponse, part of Matlab-Fast-SOAP
%

%
% Written by:
% 
% Edo Frederix The Johns Hopkins University / Eindhoven University of
% Technology Department of Mechanical Engineering edofrederix@jhu.edu,
% edofrederix@gmail.com
%

%
% This file is part of Matlab-Fast-SOAP.
% 
% Matlab-Fast-SOAP is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by the
% Free Software Foundation, either version 3 of the License, or (at your
% option) any later version.
% 
% Matlab-Fast-SOAP is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.
% 
% You should have received a copy of the GNU General Public License along
% with Matlab-Fast-SOAP. If not, see <http://www.gnu.org/licenses/>.
%

clear all;
close all;
clc;

% Choose parameters
authToken = 'edu.jhu.pha.turbulence.testing-201104';
dataset = 'isotropic1024coarse';
time = 0.002 * randi(1024,1);
spatialInterpolation = 'Fd4Lag4';
temporalInterpolation = 'None';
spacing = 2.0*pi/1023;

% Set domain size
nx = 64;
ny = nx;
xoff = 2*pi*rand; 
yoff = 2*pi*rand;
zoff = 2*pi*rand;

% Preallocate
npoints = nx*ny;
points = zeros(3, npoints);
result9 = zeros(3, npoints);

% Create surface
x = linspace(0, (nx-1)*spacing, nx) + xoff;
y = linspace(0, (ny-1)*spacing, ny) + yoff;
[X Y] = meshgrid(x, y);
points(1:2,:) = [X(:)'; Y(:)'];
points(3,:) = zoff;

data.val.authToken.name = 'authToken';
data.val.authToken.val = authToken;
data.val.authToken.type = '{http://www.w3.org/2001/XMLSchema}string';
data.val.dataset.name = 'dataset';
data.val.dataset.val = dataset;
data.val.dataset.type = '{http://www.w3.org/2001/XMLSchema}string';
data.val.time.name = 'time';
data.val.time.val = time;
data.val.time.type = '{http://www.w3.org/2001/XMLSchema}float';
data.val.spatialInterpolation.name = 'spatialInterpolation';
data.val.spatialInterpolation.val = spatialInterpolation;
data.val.spatialInterpolation.type = '{http://turbulence.pha.jhu.edu/}SpatialInterpolation';
data.val.temporalInterpolation.name = 'temporalInterpolation';
data.val.temporalInterpolation.val = temporalInterpolation;
data.val.temporalInterpolation.type = '{http://turbulence.pha.jhu.edu/}TemporalInterpolation';
data.val.points.name = 'points';
data.val.points.wrap = 'Point3';
data.val.points.parallel = 1;
data.val.points.val.x.name = 'x';
data.val.points.val.x.val = points(1,:);
data.val.points.val.y.name = 'y';
data.val.points.val.y.val = points(2,:);
data.val.points.val.z.name = 'z';
data.val.points.val.z.val = points(3,:);

timer = zeros(1,3);

fprintf('Fetching 9 velocity gradient components for %ix%i points (%i XML entries)\n', nx, ny, 9*npoints);

% Create the SOAP message
tic;
soapMessage = createSoapMessage( ...
    'http://turbulence.pha.jhu.edu/', ...
    'GetVelocityGradient', ...
    data, 'document');
timer(1) = toc;

fprintf('Creating the SOAP message: %1.6f s\n', timer(1));

% Call the SOAP service
tic;
response = callSoapService( ...
    'http://turbulence.pha.jhu.edu/service/turbulence.asmx', ...
    'http://turbulence.pha.jhu.edu/GetVelocityGradient', ...
    soapMessage);
timer(2) = toc;

fprintf('Sending SOAP message and receiving SOAP response: %1.6f s\n', timer(2));

% Parse the SOAP response
tic;
responseStruct = parseSoapResponse(response);
timer(3) = toc;
fprintf('Parsing SOAP response (into responseStruct): %1.6f s\n', timer(3));