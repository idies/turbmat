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

function s = parseSoapResponse(response)

    body = regexpi(response, '<soap:Body[^>]*>(?<content>.*)</soap:Body>', 'names');
    
    if ~isempty(body)
        
        resp = regexpi(body.content, '<(?<method>[a-z0-9:]*)response[^>]*>(?<content>.*)</(?:\1)response>', 'names');
        fault = regexpi(body.content, '<soap:Fault[^>]*>(?<content>.*)</soap:Fault>', 'names');
        
        s = struct();
        if ~isempty(resp)
            s = fetchXML(resp.content);
        end
        
        if ~isempty(fault)
            s = mergeAll(s, fetchXML(fault.content));
        end
    else
        error('No valid SOAP message received (could not find soap:Body element).');
    end
    
end

%==========================================================================
function s = fetchXML(xml)

    regex = '<(?<tag>[a-z0-9:]*)[^>]*>(?<val>.*?)</\1>';
    [match matches] = regexpi(xml, regex, 'match', 'names');
    
    if isempty(matches)
        s = xml;
    else 
        % Check tags
        s = struct();
        if numel(matches) == 1
            s.(matches.tag) = fetchXML(matches.val); 
        else
            % Check footprint
            fp1 = footprint(match{1});
            fp2 = footprint(match{2});
            if strcmp(fp1, fp2)
                sfp = swapStruct(regexpi(xml, fp1, 'names'));
                if isfield(sfp, matches(1).tag)
                    s = mergeAll(s, sfp);
                else
                    s.(matches(1).tag) = sfp;
                end
                
                % Check for remainder
                xml = regexprep(xml, fp1, '', 'ignorecase');
                if ~isempty(xml)
                    s = mergeAll(s, fetchXML(xml));
                end 

            else
                for i=1:numel(matches)
                    s = mergeAll(s, struct(matches(i).tag, fetchXML(matches(i).val)));
                end
            end
        end       
    end
    
end

%==========================================================================
function fp = footprint(xml)
    tok = regexpi(xml, '<([a-z0-9:]*)[^>]*>(.*?)<[/]\1>', 'tokens');
    
    if isempty(tok)
        fp = 'value';
    else 
        fp = '';
        for i=1:numel(tok)        
            new = footprint(tok{i}{2});
            if strcmp(new, 'value')
                new = sprintf('(?<%s>.*?)', tok{i}{1});
            end
            fp = sprintf('%s<%s>%s</%s>', fp, tok{i}{1}, new, tok{i}{1});
        end
    end
end

%==========================================================================
function obj = mergeAll(obj1, obj2)
    c1 = class(obj1); c2 = class(obj2);
    if strcmp(c1, c2)
        switch c1
            case 'cell'
                obj = vertcat(obj1(:), obj2(:));
                
            case 'char'
                obj = char({obj1; obj2});
                
            case 'double'
                obj = [obj1; obj2];
                
            case 'struct'
                if numel(obj1) ~= numel(obj2)
                    obj = {obj1; obj2};
                else
                    % Merge obj2 into obj1;
                    keys = fieldnames(obj2);
                    for i = 1:numel(keys)
                        key = keys{i};
                        for j = 1:numel(obj1)
                            if isfield(obj1, key)
                                obj1(j).(key) = mergeAll(obj1(j).(key), obj2(j).(key));
                            else
                                obj1(j).(key) = obj2(j).(key);
                            end
                        end
                    end
                    obj = obj1;
                end
                
            otherwise
                obj = {obj1; obj2};
        end
    else
        if strcmp(c1, 'cell')
            obj = vertcat(obj1(:), {obj2});
        elseif strcmp(c2, 'cell')
            obj = vertcat({obj1}, obj2(:));
        else
            obj = {obj1; obj2};
        end
    end
    
    % Combine structs of same size in cell
    if iscell(obj)
        info = [];
        objNew = {};
        for i = 1:numel(obj)
            if isstruct(obj{i})
                info = vertcat(info, [i numel(obj{i})]);
            else
                objNew{end+1} = obj{i};
            end
        end
        
        if size(info, 1) > 1
        	sizes = unique(info(:,2));
            for i = 1:numel(sizes)
                ind = info(info(:,2)==i);
                if numel(ind) > 1
                    objNew{end+1} = obj{ind(1)};
                    for j=2:numel(ind)
                        objNew{end} = mergeAll(objNew{end}, obj{ind(j)});
                    end
                else
                    objNew{end+1} = obj{ind};
                end
            end
            obj = objNew;
        end
    end
end

%==========================================================================
function s2 = swapStruct(s1)

    keys = fieldnames(s1);
    cl = cell(numel(keys), numel(s1));
    for i = 1:numel(s1)
        cl(:,i) = struct2cell(s1(i));
    end
    
    s2 = struct();
    for i = 1:numel(keys)
        c = char(cl(i,:));
        if isnan(str2double(cl{1,1}))
            s2.(keys{i}) = c;
        else
            % Assuming numbers
            s2.(keys{i}) = sscanf(c', strcat('%', num2str(size(c,2)), 'f'));
        end
    end
end