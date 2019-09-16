%
% Turbmat - a Matlab library for the JHU Turbulence Database Cluster
%   
% get*.m, part of Turbmat
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

function result = getCutout(authToken, dataset, field, T, x_start, y_start, z_start,...
    x_end, y_end, z_end, x_step, y_step, z_step, filter_width)
%
%     Retrieve velocity and pressure for specified 'time' and 'points'
%   
%     Input:
%       authToken = (string)
%       dataset = (string)
%       time = (float)
%       spatialInterpolation = (string)
%       temporalInterpolation = (string)
%       npoints = (integer)
%       points = (float array 3xN)
%   
%     Output:
%       result = (float array N)
%       

% if( size(points,1) ~= 3 || size(points,2) ~= npoints)
%     
%   error('Points not specified correctly.');
% 
% end

% Get the TurbulenceService object 
obj = TurbulenceService;

resultStruct =  GetAnyCutoutWeb (obj, authToken, dataset, field, int32(T),...
    int32(x_start), int32(y_start), int32(z_start),...
    int32(x_end), int32(y_end), int32(z_end),...
    int32(x_step), int32(y_step), int32(z_step), int32(filter_width));

%result = getVector(resultStruct.GetAnyCutoutWebResult);
result = typecast(base64decode(resultStruct.GetAnyCutoutWebResult), 'single');

return
