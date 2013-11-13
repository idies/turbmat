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

function m = createSoapMessage(tns, methodname, data, style)
    
    % No default behavior for first 5 arguments 
    if nargin < 3
        error('Provide at least 4 arguments')
    end
    
    % Check message style, default to rpc
    if nargin > 3 && ~ strcmpi(style, 'document') && ~ strcmpi(style, 'rpc')
        error('Provide a valid XML style (rpc or document is supported)');
    elseif nargin <= 3
        style = 'rpc';
    end
    
    % Start the envelope
    m = '<?xml version="1.0" encoding="utf-8"?>';
    m = merge(m, '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
    switch style
        case 'document'
            m = merge(m, '>');
        case 'rpc'
            m = merge(m, sprintf(' xmlns:n="%s">', tns));
    end
    m = merge(m, '<soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">');
    switch style
        case 'document'
            m = merge(m, sprintf('<%s xmlns="%s">', methodname, tns));
        case 'rpc'
            m = merge(m, sprintf('<n:%s>', methodname));
    end
    
    % Add body
    m = merge(m, createXML(data));
    
    % End the envelope
    switch style
        case 'document'
            m = merge(m, sprintf('</%s>', methodname));
        case 'rpc'
            m = merge(m, sprintf('</n:%s>', methodname));
    end
    m = merge(m, '</soap:Body></soap:Envelope>');
end

%==========================================================================
function xml = createXML(data)

    xml = '';
    
    for n=1:numel(data)
        
        xmlStep = '';
        xmlParallel = '';
        
        [val, valClass, name, type, wrap, parallel] = checkData(data(n));
        switch valClass
            case 'struct'
                keys = fieldnames(val);
                for j=1:numel(keys)
                    key = keys{j};
                    xmlSub = createXML(val.(key));

                    if ~parallel || (size(xmlParallel,1) > 0 && size(xmlParallel, 1) ~= size(xmlSub, 1))
                        xmlSub = wrapXML(wrap, '', xmlSub);
                        xmlStep = merge(xmlStep, xmlSub);
                    else
                        xmlParallel = horzcat(xmlParallel, xmlSub);
                    end
                end

                if parallel
                    xmlParallel = wrapXML(wrap, '', xmlParallel);
                    xmlStep = merge(xmlStep, xmlParallel);
                end

                xml = merge(xml, wrapXML(name, type, xmlStep));

            case 'char'
                xml = [xml wrapXML(name, type, wrapXML(wrap, '', val))];

            case 'double'
                xml = [xml wrapXML(name, type, wrapXML(wrap, '', num2str(val(:), '%1.10f')))];

            case 'cell'
                for i=1:numel(val)
                    if isstruct(val{i})
                        valStep = val{i};
                    else
                        valStep = struct('val', val{i});
                    end
                    xmlStep = merge(xmlStep, wrapXML(wrap, '', createXML(valStep)));
                end
                xml = merge(xml, wrapXML(name, type, xmlStep));
        end
    end
end

%==========================================================================
function str = wrapXML(name, type, str)

    if name
        n = size(str,1);
        str = horzcat( repmat(sprintf('<%s%s>', name, checkType(type)), n, 1), ...
                       str, ...
                       repmat(sprintf('</%s>', name), n, 1));
    end

end

%==========================================================================
function xml = merge(varargin)

    optargin = size(varargin,2);
    if optargin < 2
        error('We need at least two arguments');
    end
    
    xml = '';
    for i=1:optargin
        s = varargin{i};
        if size(s,1) > 1
            xml = [xml reshape(transpose(varargin{i}), 1, numel(varargin{i}))];
        else
            xml = [xml s];
        end
    end
end

%==========================================================================
function [val, valClass, name, type, wrap, parallel] = checkData(data)
    
    %defaults
    val = ''; valClass = class(val);
    name = [];
    type = [];
    wrap = [];
    parallel = 0;

    keys = fieldnames(data);
    for i=1:numel(keys)
        key = keys{i};
        switch key
            case 'val'
                val = data.val;
                valClass = class(val);
                
            case 'type'
                type = data.type;
                
            case 'name'
                name = data.name;                
                
            case 'wrap'
                wrap = data.wrap;
                
            case 'parallel'
                parallel = data.parallel;
        end
    end
    
end

%==========================================================================
function string = checkType(type)
    if ~isempty(strmatch('{http://www.w3.org/2001/XMLSchema}',type))
        string = sprintf(' xsi:type="xs:%s"', type(35:end));
    else
        string = '';
    end
end