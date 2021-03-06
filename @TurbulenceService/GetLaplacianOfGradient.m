function GetLaplacianOfGradientResult = GetLaplacianOfGradient(obj,authToken,dataset,field,time,spatialInterpolation,temporalInterpolation,points)
%GetLaplacianOfGradient(obj,authToken,dataset,field,time,spatialInterpolation,temporalInterpolation,points)
%
%   Retrieve the laplacian of the gradient of the specified field at a number of points for a given time. Development version, not intended for production use!
%   
%     Input:
%       authToken = (string)
%       dataset = (string)
%       field = (string)
%       time = (float)
%       spatialInterpolation = (SpatialInterpolation)
%       temporalInterpolation = (TemporalInterpolation)
%       points = (ArrayOfPoint3)
%   
%     Output:
%       GetLaplacianOfGradientResult = (ArrayOfVelocityGradient)

% Build up the argument lists.
values = { ...
   authToken, ...
   dataset, ...
   field, ...
   time, ...
   spatialInterpolation, ...
   temporalInterpolation, ...
   points, ...
   };
names = { ...
   'authToken', ...
   'dataset', ...
   'field', ...
   'time', ...
   'spatialInterpolation', ...
   'temporalInterpolation', ...
   'points', ...
   };
types = { ...
   '{http://www.w3.org/2001/XMLSchema}string', ...
   '{http://www.w3.org/2001/XMLSchema}string', ...
   '{http://www.w3.org/2001/XMLSchema}string', ...
   '{http://www.w3.org/2001/XMLSchema}float', ...
   '{http://turbulence.pha.jhu.edu/}SpatialInterpolation', ...
   '{http://turbulence.pha.jhu.edu/}TemporalInterpolation', ...
   '{http://turbulence.pha.jhu.edu/}ArrayOfPoint3', ...
   };

% Create the message, make the call, and convert the response into a variable.
soapMessage = createSoapMessage( ...
    'http://turbulence.pha.jhu.edu/', ...
    'GetLaplacianOfGradient', ...
    values,names,types,'document');
response = callSoapService( ...
    obj.endpoint, ...
    'http://turbulence.pha.jhu.edu/GetLaplacianOfGradient', ...
    soapMessage);
GetLaplacianOfGradientResult = parseSoapResponse(response);
