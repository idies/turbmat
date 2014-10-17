%
% Turbmat - a Matlab library for the JHU Turbulence Database Cluster
%   
% Sample code, part of Turbmat
%

%
% Written by:
%  
% Perry Johnson
% The Johns Hopkins University
% Department of Mechanical Engineering
% pjohns86@jhu.edu, johnson.perry.l@gmail.com
%

%
% This file is part of Turbmat.
% 
% Turbmat is free software: you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free
% Software Foundation, either version 3 of the License, or (at your option)
% any later version.
% 
% Turbmat is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
% more details.
% 
% You should have received a copy of the GNU General Public License along
% with Turbmat.  If not, see <http://www.gnu.org/licenses/>.
%

clear all;
close all;

authkey = 'edu.jhu.pha.turbulence.testing-201311';
dataset = 'channel';

% ---- Temporal Interpolation Options ----
NoTInt   = 'None' ; % No temporal interpolation
PCHIPInt = 'PCHIP'; % Piecewise cubic Hermit interpolation in time

% ---- Spatial Interpolation Flags for getVelocity &amp; getVelocityAndPressure ----
NoSInt = 'None'; % No spatial interpolation
Lag4   = 'Lag4'; % 4th order Lagrangian interpolation in space
Lag6   = 'Lag6'; % 6th order Lagrangian interpolation in space
Lag8   = 'Lag8'; % 8th order Lagrangian interpolation in space

% ---- Spatial Differentiation &amp; Interpolation Flags for getVelocityGradient &amp; getPressureGradient ----
FD4NoInt = 'None_Fd4' ; % 4th order finite differential scheme for grid values, no spatial interpolation
FD6NoInt = 'None_Fd6' ; % 6th order finite differential scheme for grid values, no spatial interpolation
FD8NoInt = 'None_Fd8' ; % 8th order finite differential scheme for grid values, no spatial interpolation
FD4Lag4  = 'Fd4Lag4'  ; % 4th order finite differential scheme for grid values, 4th order Lagrangian interpolation in space

%  Set time step to sample
time = 0.364;

% getPosition integration settings
startTime=0.364;
endTime=0.376;
lagDt=0.0004; 

% for thresholding
threshold_field = 'vorticity';
threshold = 10.0;
X = int32(0); 
Y = int32(0);
Z = int32(0);
Xwidth = int32(16);
Ywidth = int32(16);
Zwidth = int32(16);

npoints = 10;

points = zeros(3,npoints);
result1  = zeros(npoints);
result3  = zeros(3,npoints);
result4  = zeros(4,npoints);
result6  = zeros(6,npoints);
result9  = zeros(9,npoints);
result18 = zeros(18,npoints);

%  Set spatial locations to sample
for p = 1:npoints
  points(1,p) = 0.20 * p;
  points(2,p) = 0.05 * p;
  points(3,p) = 0.15 * p;
end

fprintf('\nCoordinates of 10 points where variables are requested:\n');
for p = 1:npoints
    fprintf(1,'%3i: %13.6e, %13.6e, %13.6e\n', p, points(1,p),  points(2,p),  points(3,p));
end

fprintf('\nRequesting velocity at %i points...\n',npoints);
result3 =  getVelocity (authkey, dataset, time, Lag6, NoTInt, npoints, points);
for p = 1:npoints
  fprintf(1,'%3i: %13.6e, %13.6e, %13.6e\n', p, result3(1,p),  result3(2,p),  result3(3,p));
end

fprintf('\nRequesting velocity and pressure at %i points...\n',npoints);
result4 = getVelocityAndPressure (authkey, dataset, time, Lag6, NoTInt, npoints, points);
for p = 1:npoints
  fprintf(1,'%3i: %13.6e, %13.6e, %13.6e, %13.6e\n', p, result4(1,p),  result4(2,p),  result4(3,p), result4(4,p));
end

fprintf('\nRequesting velocity gradient at %i points...\n',npoints);
result9 = getVelocityGradient (authkey, dataset, time,  FD4Lag4, NoTInt, npoints, points);
for p = 1:npoints
  fprintf(1,'%3i: duxdx=%13.6e, duxdy=%13.6e, duxdz=%13.6e, ', p, result9(1,p), result9(2,p), result9(3,p));
  fprintf(1,'duydx=%13.6e, duydy=%13.6e, duydz=%13.6e, ', result9(4,p), result9(5,p), result9(6,p));
  fprintf(1,'duzdx=%13.6e, duzdy=%13.6e, duzdz=%13.6e\n', result9(7,p), result9(8,p), result9(9,p));
end

fprintf('\nRequesting velocity hessian at %i points...\n',npoints);
result18 = getVelocityHessian (authkey, dataset, time, FD4Lag4, NoTInt, npoints, points);
for p = 1:npoints
  fprintf(1,'%3i: d2uxdxdx=%13.6e, d2uxdxdy=%13.6e, d2uxdxdz=%13.6e, ', p, result18(1,p), result18(2,p), result18(3,p));
  fprintf(1,'d2uxdydy=%13.6e, d2uxdydz=%13.6e, d2uxdzdz=%13.6e, ', result18(4,p), result18(5,p), result18(6,p));
  fprintf(1,'d2uydxdx=%13.6e, d2uydxdy=%13.6e, d2uydxdz=%13.6e, ', result18(7,p), result18(8,p), result18(9,p));
  fprintf(1,'d2uydydy=%13.6e, d2uydydz=%13.6e, d2uydzdz=%13.6e, ', result18(10,p), result18(11,p), result18(12,p));
  fprintf(1,'d2uzdxdx=%13.6e, d2uzdxdy=%13.6e, d2uzdxdz=%13.6e, ', result18(13,p), result18(14,p), result18(15,p));
  fprintf(1,'d2uzdydy=%13.6e, d2uzdydz=%13.6e, d2uzdzdz=%13.6e\n', result18(16,p), result18(17,p), result18(18,p));
end

fprintf('\nRequesting velocity laplacian at %i points...\n',npoints);
result3 =  getVelocityLaplacian (authkey, dataset, time, FD4Lag4, NoTInt, npoints, points);
for p = 1:npoints
  fprintf(1,'%3i: grad2ux=%13.6e, grad2uy=%13.6e, grad2uz=%13.6e\n', p, result3(1,p),  result3(2,p),  result3(3,p));
end

fprintf('\nRequesting pressure at %i points...\n',npoints);
result1 = getPressure (authkey, dataset, time, Lag6, NoTInt, npoints, points);
for p = 1:npoints
  fprintf(1,'%3i: %13.6e\n', p, result1(p));
end

fprintf('\nRequesting pressure gradient at %i points...\n',npoints);
result3 =  getPressureGradient (authkey, dataset, time, FD4Lag4, NoTInt, npoints, points);
for p = 1:npoints
  fprintf(1,'%3i: dpdx=%13.6e, dpdy=%13.6e, dpdz=%13.6e\n', p, result3(1,p),  result3(2,p),  result3(3,p));
end

fprintf('\nRequesting pressure hessian at %i points...\n',npoints);
result6 = getPressureHessian (authkey, dataset, time, FD4Lag4, NoTInt, npoints, points);
for p = 1:npoints
  fprintf(1,'%3i: d2pdxdx=%13.6e, d2pdxdy=%13.6e, d2pdxdz=%13.6e, ', p, result6(1,p), result6(2,p), result6(3,p));
  fprintf(1,'d2pdydy=%13.6e, d2pdydz=%13.6e, d2pdzdz=%13.6e\n', result6(4,p), result6(5,p), result6(6,p));
end

fprintf('\nRequesting vorticity threshold...\n');
threshold_array =  getThreshold (authkey, dataset, threshold_field, time, threshold, FD4NoInt, X, Y, Z, Xwidth, Ywidth, Zwidth);
for p = 1:length(threshold_array)
  fprintf(1,'(%3i, %3i, %3i): %13.6e\n', threshold_array(1,p),  threshold_array(2,p),  threshold_array(3,p), threshold_array(4,p));
end

% ///////////////////////////////////////////////////////////
% ////////////// GENERATE A SIMPLE CONTOUR PLOT /////////////
%////////////////////////////////////////////////////////////

%  Chose a random time step
time = 0.002 * randi(1024,1);
spacing = 3.0*pi/1536; % z-spacing = 1/2 x-spacing

% Set domain size and position
nx = 64;
nz = nx;
xoff = 2*spacing*randi([0,2048-nx]); 
yoff = -0.99; % y+ = 10
zoff = spacing*randi([0,1536-nz]);
npoints = nx*nz;

clear points;

% Create surface
x = linspace(0, (nx-1)*spacing, nx) + xoff;
z = linspace(0, (nz-1)*spacing, nz) + zoff;
[X Z] = meshgrid(x, z);
points(1,:) = X(:)';
points(3,:) = Z(:)';
points(2,:) = yoff;
    
% Get the velocity at each point
fprintf('\nRequesting velocity at (%ix%i) points for velocity contour plot...\n',nx,nz);
result3 = getVelocity(authkey, dataset, time, Lag4, NoTInt, npoints, points);

% Calculate x-velocity
y = result3(1,:);
Y = reshape(y, nx, nz);

% Plot x-velocity contours
contourf(X, Z, Y, 30, 'LineStyle', 'none');
set(gca, 'FontSize', 11)
title('x-velocity', 'FontSize', 13, 'FontWeight', 'bold');
xlabel('x', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('z', 'FontSize', 12, 'FontWeight', 'bold');
colorbar('FontSize', 12);
axis([xoff max(x) zoff max(z)]);
set(gca, 'TickDir', 'out', 'TickLength', [.02 .02],'XMinorTick', 'on', 'YMinorTick', 'on');

