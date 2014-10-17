%
% Turbmat - a Matlab library for the JHU Turbulence Database Cluster
%   
% get*.m, part of Turbmat
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

function result = getThreshold(authToken,dataset,field,time,threshold, ...
                               spatialInterpolation,X,Y,Z, ...
                               Xwidth,Ywidth,Zwidth)
%
%     Retrieve the grid locations with norms for the specified field above 
%     the given threshold for the given time.
%   
%     Input:
%       authToken = (string)
%       dataset = (string)
%       field = (string)
%       time = (float)
%       threshold = (float)
%       spatialInterpolation = (SpatialInterpolation)
%       X = (int)
%       Y = (int)
%       Z = (int)
%       Xwidth = (int)
%       Ywidth = (int)
%       Zwidth = (int)
%   
%     Output:
%       result = (ArrayOfThresholdInfo)
%       

% Get the TurbulenceService object
obj = TurbulenceService;

resultStruct =  GetThreshold (obj, authToken, dataset, field, time, ...
                              threshold, spatialInterpolation, ...
                              X, Y, Z, ...
                              Xwidth, Ywidth, Zwidth);

result = getVector(resultStruct.GetThresholdResult.ThresholdInfo);

return
