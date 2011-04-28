%
%  Written by:
%  
%  Jason Graham
%  The Johns Hopkins University
%  Department of Mechanical Engineering
%  jgraha8@gmail.com
%

function result = getVelocityGradient(authToken,dataset,time,spatialInterpolation, ...
                                      temporalInterpolation,npoints, points)			     
%
%     Retrieve velocity gradient for specified 'time' and 'points'
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
%       result = (float array 9xN)
%       

if( size(points,1) ~= 3 | size(points,2) ~= npoints)
    
  error('Points not specified correctly.');

end

% Get the TurbulenceService object
obj = TurbulenceService;

% Create points struct
struct_points = cell(npoints,1);
for i = 1:npoints
  Point3.x = points(1,i);
  Point3.y = points(2,i);
  Point3.z = points(3,i);
  struct_points{i} = Point3;
end

resultStruct =  GetVelocityGradient (obj, authToken, dataset, time, ...
		spatialInterpolation, ...
		temporalInterpolation, ...
		cell2struct({struct_points},{'Point3'}));
   
clear struct_points;

result = cellfun(@str2num,struct2cell(resultStruct.VelocityGradient));

return
