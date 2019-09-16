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
%close all;

authkey = 'edu.jhu.pha.turbulence.testing-201406';
dataset = 'isotropic1024coarse';
field='u';
x_start=int32(1); y_start=int32(1); z_start=int32(1);
x_end=int32(64);  y_end=int32(64);    z_end=int32(1);
x_step=int32(1);  y_step=int32(1);    z_step=int32(1);
t=int32(1);      filter_width=int32(1); 

result =  getCutout (authkey, dataset, field,...
    t, x_start, y_start, z_start, x_end, y_end, z_end, x_step, y_step, z_step, filter_width);

result = reshape(result,[3, length([x_start:x_step:x_end]), length([y_start:y_step:y_end]), length([z_start:z_step:z_end])]);

figure;
contourf(squeeze(result(1,:,:,1)));