function result = getVelocity(authToken,dataset,time,spatialInterpolation, ...
                                             temporalInterpolation,npoints, points)
%GetVelocity(obj,authToken,dataset,time,spatialInterpolation,temporalInterpolation,points)
%
%   Spatially interpolate the velocity at a number of points for a given time.
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
%       GetVelocityResult = (float array 3xN)
%       rc = (integer)

%rc = 0;

if( size(points,1) ~= 3 | size(points,2) ~= npoints)
    
  error('Points not specified correctly.');

end

% Get the TurbulenceService object created from:
%createClassFromWsdl('http://turbulence.pha.jhu.edu/service/turbulence.asmx?WSDL');
obj = TurbulenceService;

%struct_points = {};
struct_points = cell(npoints,1);

for i = 1:npoints
  Point3.x = points(1,i);
  Point3.y = points(2,i);
  Point3.z = points(3,i);
  struct_points{i} = Point3;
end

result3 =  GetVelocity (obj, authToken, dataset, time, ...
		spatialInterpolation, ...
		temporalInterpolation, ...
		cell2struct({struct_points},{'Point3'}));
   
clear struct_points;

result = cellfun(@str2num,struct2cell(result3.Vector3));

return
