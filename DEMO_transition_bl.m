%
% Turbmat - a Matlab library for the JHU Turbulence Database Cluster
%   
% Sample code, part of Turbmat
%

%
% Written by:
%  
% Zhao Wu
% The Johns Hopkins University
% Department of Mechanical Engineering
% zhao.wu@jhu.edu
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

authkey = 'edu.jhu.pha.turbulence.testing-201406';
dataset = 'transition_bl';

% ---- Temporal Interpolation Options ----
NoTInt   = 'None' ; % No temporal interpolation
PCHIPInt = 'PCHIP'; % Piecewise cubic Hermit interpolation in time

% ---- Spatial Interpolation Flags for getVelocity & getVelocityAndPressure ----
NoSInt = 'None'; % No spatial interpolation
Lag4   = 'Lag4'; % 4th order Lagrangian interpolation in space

% ---- Spatial Differentiation & Interpolation Flags for getVelocityGradient & getPressureGradient ----
FD4NoInt = 'None_Fd4' ; % 4th order finite differential scheme for grid values, no spatial interpolation
FD4Lag4  = 'Fd4Lag4'  ; % 4th order finite differential scheme for grid values, 4th order Lagrangian interpolation in space

%  Set time step to sample
time = 0.364;

% getPosition integration settings
startTime=0.364;
endTime=2.864;
lagDt=0.25; 

% for thresholding
threshold_field = 'vorticity';
threshold = 1.76;
x_start = int32(1); 
y_start = int32(1);
z_start = int32(1);
x_end = int32(16); 
y_end = int32(16);
z_end = int32(16);

npoints = 10;

points = zeros(3,npoints);
result1  = zeros(npoints);
result2  = zeros(2,npoints);
result3  = zeros(3,npoints);
result4  = zeros(4,npoints);
result6  = zeros(6,npoints);
result9  = zeros(9,npoints);
result18 = zeros(18,npoints);

%  Set spatial locations to sample
for p = 1:npoints
  points(1,p) = 0.20 * p + 30.21850;
  points(2,p) = 0.05 * p;
  points(3,p) = 0.15 * p;
end

fprintf('\nCoordinates of 10 points where variables are requested:\n');
for p = 1:npoints
    fprintf(1,'%3i: %13.6e, %13.6e, %13.6e\n', p, points(1,p),  points(2,p),  points(3,p));
end

fprintf('\nRequesting velocity at %i points...\n',npoints);
result3 =  getVelocity (authkey, dataset, time, Lag4, NoTInt, npoints, points);
for p = 1:npoints
  fprintf(1,'%3i: %13.6e, %13.6e, %13.6e\n', p, result3(1,p),  result3(2,p),  result3(3,p));
end

fprintf('\nRequesting velocity and pressure at %i points...\n',npoints);
result4 = getVelocityAndPressure (authkey, dataset, time, Lag4, NoTInt, npoints, points);
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
result1 = getPressure (authkey, dataset, time, Lag4, NoTInt, npoints, points);
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

fprintf('\nRequesting position at %i points, starting at time %f and ending at time %f...\n',npoints,startTime,endTime);
result3 = getPosition(authkey, dataset, startTime, endTime, lagDt, Lag4, npoints, points);
fprintf('\nCoordinates of 10 points at startTime:\n');
for p = 1:npoints
    fprintf(1,'%3i: %13.6e, %13.6e, %13.6e\n', p, points(1,p),  points(2,p),  points(3,p));
end
fprintf('\nCoordinates of 10 points at endTime:\n');
for p = 1:npoints
  fprintf(1,'%3i: %13.6e, %13.6e, %13.6e\n', p, result3(1,p),  result3(2,p),  result3(3,p));
end

fprintf('\nRequesting vorticity threshold...\n');
threshold_array =  getThreshold (authkey, dataset, threshold_field, time, threshold, FD4NoInt, x_start, y_start, z_start, x_end, y_end, z_end);
for p = 1:length(threshold_array)
  fprintf(1,'(%3i, %3i, %3i): %13.6e\n', threshold_array(1,p),  threshold_array(2,p),  threshold_array(3,p), threshold_array(4,p));
end

fprintf('\nRequesting invariant at %i points...\n',npoints);
result2 =  getInvariant (authkey, dataset, time, FD4Lag4, NoTInt, npoints, points);
for p = 1:npoints
  fprintf(1,'%3i: S2=%13.6e, O2=%13.6e\n', p, result2(1,p),  result2(2,p));
end

% ///////////////////////////////////////////////////////////
% ////////////// GENERATE A SIMPLE CONTOUR PLOT /////////////
%////////////////////////////////////////////////////////////

%  Chose a random time step
time = 0.25 * randi(4700,1);
spacing = 0.1;

% Set domain size and position
nx = 128;
nz = 32;
xoff = 3*spacing*randi([0,3300-nx]) + 30.21850; 
yoff = 2;
zoff = spacing*randi([0,2048-nz]);
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
Y = reshape(y, nz, nx);

% Plot x-velocity contours
contourf(X, Z, Y, 30, 'LineStyle', 'none');
set(gca, 'FontSize', 11)
title('x-velocity', 'FontSize', 13, 'FontWeight', 'bold');
xlabel('x', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('z', 'FontSize', 12, 'FontWeight', 'bold');
colorbar('FontSize', 12);
axis([xoff max(x) zoff max(z)]);
set(gca, 'TickDir', 'out', 'TickLength', [.02 .02],'XMinorTick', 'on', 'YMinorTick', 'on');

