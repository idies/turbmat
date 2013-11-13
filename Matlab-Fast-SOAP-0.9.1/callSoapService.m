%
% Matlab-Fast-SOAP - a faster Matlab replacement for the default SOAP
% functions
%   
% parseSoapResponse, part of Matlab-Fast-SOAP
%

%
% Written by:
% 
% Edo Frederix The Johns Hopkins University / Eindhoven University of
% Technology Department of Mechanical Engineering edofrederix@jhu.edu,
% edofrederix@gmail.com
%

%
% This file is part of Matlab-Fast-SOAP.
% 
% Matlab-Fast-SOAP is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by the
% Free Software Foundation, either version 3 of the License, or (at your
% option) any later version.
% 
% Matlab-Fast-SOAP is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.
% 
% You should have received a copy of the GNU General Public License along
% with Matlab-Fast-SOAP. If not, see <http://www.gnu.org/licenses/>.
%

function response = callSoapService(url, action, message)

    % Java
    import java.io.*;
    import java.net.*;
    import com.mathworks.mlwidgets.io.InterruptibleStreamCopier;
    
    % Prep message
    m = java.lang.String(message).getBytes('UTF8');
    
    % Proxy
    com.mathworks.mlwidgets.html.HTMLPrefs.setProxySettings
    mwtcp = com.mathworks.net.transport.MWTransportClientPropertiesFactory.create();
    proxy = mwtcp.getProxy();   

    % Connection
    url = URL(url); 
    if isempty(proxy)
        c = url.openConnection();
    else
        c = url.openConnection(proxy);
    end
    c.setRequestProperty('Content-Type','text/xml; charset=utf-8');
    c.setRequestProperty('SOAPAction',action);
    c.setRequestMethod('POST');
    c.setDoOutput(true);
    c.setDoInput(true);

    try
        % Send
        s = c.getOutputStream;
        s.write(m);
        s.close;
        
    catch e
        error(e.message);
        
    end

    try
        % Receive
        inputStream = c.getInputStream;
        byteArrayOutputStream = java.io.ByteArrayOutputStream;
        isc = InterruptibleStreamCopier.getInterruptibleStreamCopier;
        isc.copyStream(inputStream, byteArrayOutputStream);
        inputStream.close;
        byteArrayOutputStream.close;

    catch e
        error(e.message);
        
    end

    % Make response readable
    response = char(byteArrayOutputStream.toString('UTF-8'));
end
