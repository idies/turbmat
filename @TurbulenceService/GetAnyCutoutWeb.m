%
% Turbmat - a Matlab library for the JHU Turbulence Database Cluster
%   
% Get*.m, part of Turbmat
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

function GetAnyCutoutWebResult = GetAnyCutoutWeb(obj, authToken, dataset, field, T,...
    x_start, y_start, z_start,...
    x_end, y_end, z_end, x_step, y_step, z_step, filter_width)
%GetAnyCutoutWeb(obj, authToken, dataset, field, T,...
%    x_start, y_start, z_start,...
%    x_end, y_end, z_end, x_step, y_step, z_step, filter_width)
%
%   Retrieve the raw data.
%   
%     Input:
%       authToken = (string)
%       dataset = (string)
%       field = (string)
%       T = (int)
%       x_start = (int)
%       y_start = (int)
%       z_start = (int)
%       x_end = (int)
%       x_end = (int)
%       x_end = (int)
%       x_step = (int)
%       x_step = (int)
%       x_step = (int)
%       filter_width = (int)
%   
%     Output:
%       GetThresholdResult = (base64Binary)

% Build up the argument lists.
data.val.authToken.name = 'authToken';
data.val.authToken.val = authToken;
data.val.authToken.type = '{http://www.w3.org/2001/XMLSchema}string';
data.val.dataset.name = 'dataset';
data.val.dataset.val = dataset;
data.val.dataset.type = '{http://www.w3.org/2001/XMLSchema}string';
data.val.field.name = 'field';
data.val.field.val = field;
data.val.field.type = '{http://www.w3.org/2001/XMLSchema}string';
data.val.T.name = 'T';
data.val.T.val = T;
data.val.T.type = '{http://www.w3.org/2001/XMLSchema}int';
data.val.x_start.name = 'x_start';
data.val.x_start.val = x_start;
data.val.x_start.type = '{http://www.w3.org/2001/XMLSchema}int';
data.val.y_start.name = 'y_start';
data.val.y_start.val = y_start;
data.val.y_start.type = '{http://www.w3.org/2001/XMLSchema}int';
data.val.z_start.name = 'z_start';
data.val.z_start.val = z_start;
data.val.z_start.type = '{http://www.w3.org/2001/XMLSchema}int';
data.val.x_end.name = 'x_end';
data.val.x_end.val = x_end;
data.val.x_end.type = '{http://www.w3.org/2001/XMLSchema}int';
data.val.y_end.name = 'y_end';
data.val.y_end.val = y_end;
data.val.y_end.type = '{http://www.w3.org/2001/XMLSchema}int';
data.val.z_end.name = 'z_end';
data.val.z_end.val = z_end;
data.val.z_end.type = '{http://www.w3.org/2001/XMLSchema}int';
data.val.x_step.name = 'x_step';
data.val.x_step.val = x_step;
data.val.x_step.type = '{http://www.w3.org/2001/XMLSchema}int';
data.val.y_step.name = 'y_step';
data.val.y_step.val = y_step;
data.val.y_step.type = '{http://www.w3.org/2001/XMLSchema}int';
data.val.z_step.name = 'z_step';
data.val.z_step.val = z_step;
data.val.z_step.type = '{http://www.w3.org/2001/XMLSchema}int';
data.val.filter_width.name = 'filter_width';
data.val.filter_width.val = filter_width;
data.val.filter_width.type = '{http://www.w3.org/2001/XMLSchema}int';

% Create the message, make the call, and convert the response into a variable.
soapMessage = createSoapMessage( ...
    'http://turbulence.pha.jhu.edu/', ...
    'GetAnyCutoutWeb', ...
    data,'document');
response = callSoapService( ...
    obj.endpoint, ...
    'http://turbulence.pha.jhu.edu/GetAnyCutoutWeb', ...
    soapMessage);
GetAnyCutoutWebResult = parseSoapResponse(response);

% Fault message handling
if isfield(GetAnyCutoutWebResult, 'faultstring')
    error('faultcode: %s\nfaultstring: %s\n', ...
        GetAnyCutoutWebResult.faultcode, ...
        GetAnyCutoutWebResult.faultstring);
end
