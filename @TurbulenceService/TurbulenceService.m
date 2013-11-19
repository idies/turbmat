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


function obj = TurbulenceService

thisPath = regexprep(fileparts(which('TurbulenceService')), '@TurbulenceService', '', 'ignorecase');
a = dir(thisPath);
set = 0;
for i = 1:numel(a)
    if a(i).isdir && ~isempty(regexpi(a(i).name, '^matlab.fast.soap'))
        addpath(sprintf('%s/%s', thisPath, a(i).name));
        set = 1;
        break;
    end
end

if ~set
    error('Could not find Matlab-Fast-SOAP package. PMake sure to include a copy of Matlab-Fast-SOAP in the Turbmat path.');
end


obj.endpoint = 'http://turbulence.pha.jhu.edu/service/turbulence.asmx';
obj.wsdl = 'http://turbulence.pha.jhu.edu/service/turbulence.asmx?WSDL';

obj = class(obj,'TurbulenceService');
