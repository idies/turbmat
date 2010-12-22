%
% Turbulence Database sample Matlab client code
%

clear all;
close all;

authkey = 'edu.jhu.jgraha34-857fbf6f';
dataset = 'isotropic1024coarse';

%createClassFromWsdl('http://turbulence.pha.jhu.edu/service/turbulence.asmx?WSDL')
%obj = TurbulenceService;

% ---- Temporal Interpolation Options ----
% NoTInt   % No temporal interpolation
% PCHIPInt % Piecewise cubic Hermit interpolation in time
% 
% % ---- Spatial Interpolation Flags for getVelocity &amp; getVelocityAndPressure ----
% NoSInt % No spatial interpolation
% Lag4   % 4th order Lagrangian interpolation in space
% Lag6   % 6th order Lagrangian interpolation in space
% Lag8   % 8th order Lagrangian interpolation in space
% 
% % ---- Spatial Differentiation &amp; Interpolation Flags for getVelocityGradient &amp; getPressureGradient ----
% FD4NoInt % 4th order finite differential scheme for grid values, no spatial interpolation
% FD6NoInt % 6th order finite differential scheme for grid values, no spatial interpolation
% FD8NoInt % 8th order finite differential scheme for grid values, no spatial interpolation
% FD4Lag4  % 4th order finite differential scheme for grid values, 4th order Lagrangian interpolation in space

%  Chose a random time step
timestep = randi(182,1,1);
time = 0.002 * timestep;

nx = 32;
ny = nx;

dx = 2.0*pi/1024;
dy = dx;

npoints = nx*ny;

points = zeros(3,npoints);
result3 = zeros(3,npoints);

indx=0;
for j=1:ny
    yt = dy*(j-1);
  for i=1:nx
    indx=indx+1;
    points(1,indx) = dx*(i-1);
    points(2,indx) = yt;
  end
end

% Choose a random z-plane
points(3,:) = 2.*pi * rand;
    
fprintf('\nRequesting velocity at %i points...\n',npoints);
result3 =  getVelocity (authkey, dataset, time, 'Lag4', 'None', npoints, points);

clear points

x = (0.0:dx:(nx-1)*dx);
y = (0.0:dy:(ny-1)*dy);

%  Roll up u-velocity 
vel_mag = zeros(nx,ny);
indx=0;
for j=1:ny
    for i=1:nx
        indx=indx+1;
        vel = result3(:,indx);
        vel_mag(i,j) = sqrt(sum(vel.*vel));
    end
end

clear result3;
contourf(x,y,vel_mag,'LineStyle','none');







