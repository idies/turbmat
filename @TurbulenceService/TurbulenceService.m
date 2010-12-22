function obj = TurbulenceService

obj.endpoint = 'http://turbulence.pha.jhu.edu/service/turbulence.asmx';
obj.wsdl = 'http://turbulence.pha.jhu.edu/service/turbulence.asmx?WSDL';

obj = class(obj,'TurbulenceService');

