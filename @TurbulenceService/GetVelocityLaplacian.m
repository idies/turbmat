%
% Turbmat - a Matlab library for the JHU Turbulence Database Cluster
%   
% Get*.m, part of Turbmat
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


function GetVelocityLaplacianResult = GetVelocityLaplacian(obj,authToken,dataset,time,spatialInterpolation,temporalInterpolation,points)
%GetVelocityLaplacian(obj,authToken,dataset,time,spatialInterpolation,temporalInterpolation,points)
%
%   Retrieve the velocity laplacian at a fixed location
%   
%     Input:
%       authToken = (string)
%       dataset = (string)
%       time = (float)
%       spatialInterpolation = (SpatialInterpolation)
%       temporalInterpolation = (TemporalInterpolation)
%       points = (ArrayOfPoint3)
%   
%     Output:
%       GetVelocityLaplacianResult = (ArrayOfVector3)

% Build up the argument lists.
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

% Create the message, make the call, and convert the response into a variable.
soapMessage = createSoapMessage( ...
    'http://turbulence.pha.jhu.edu/', ...
    'GetVelocityLaplacian', ...
    data,'document');
response = callSoapService( ...
    obj.endpoint, ...
    'http://turbulence.pha.jhu.edu/GetVelocityLaplacian', ...
    soapMessage);
GetVelocityLaplacianResult = parseSoapResponse(response);

% Fault message handling
if isfield(GetVelocityLaplacianResult, 'faultstring')
    error('faultcode: %s\nfaultstring: %s\n', ...
        GetVelocityLaplacianResult.faultcode, ...
        GetVelocityLaplacianResult.faultstring);
end