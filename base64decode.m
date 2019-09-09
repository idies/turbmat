function res = base64decode(str)
% base64decode Perform Base 64 decoding of a string 
%   RES = base64decode(V) decodes a string that was encoded using Base 64 encoding as
%   documented in RFC 4648, <a href="http://tools.ietf.org/html/rfc4648#section-4">section 4</a> and returns the
%   decoded byte array.  This encoding is used in a number of contexts in Internet
%   messages where arbitrary data must be transmitted in the form of ASCII
%   characters.
%
%   In the input string, any characters not in the set of 65 characters defined for
%   Base 64 encoding are ignored.  Decoding stops at the end of string or the first
%   occurrence of a '=' character.  
%
%   If you know that the encoded data was a character string, you can convert it back
%   to a string using native2unicode(RES), using the user default encoding in effect
%   at the time the string was encoded.
%
% See also base64encode, native2unicode

% Copyright 2016 The MathWorks, Inc.

    if isstring(str)
        str = char(str);
    end
    if isempty(str)
        res = uint8.empty;
    else
        validateattributes(str, {'char'}, {'vector'}, mfilename, 'string');
        len = length(str);
        res(ceil(len*3/4)) = uint8(0);
        bx = 1;
        i = 1;
        j = 0;
        out = uint8(0);
        while i <= len && j < 4
            ch = str(i);
            i = i + 1;
            if ch >= 'A' && ch <= 'Z'
                code = uint8(ch - 'A');
            elseif ch >= 'a' && ch <= 'z'
                code = uint8(26) + (ch - 'a');
            elseif ch >= '0' && ch <= '9'
                code = uint8(52) + (ch - '0');
            else
                switch ch
                    case '+'
                        code = uint8(62);
                    case '/'
                        code = uint8(63);
                    case '='
                        res(bx:end)=[];
                        break;
                    otherwise
                        continue;
                end
            end
            switch j
                case 0
                    out = bitshift(code,2);
                    j = j + 1;
                case 1
                    res(bx) = out + bitshift(code,-4);
                    bx = bx + 1;
                    out = bitshift(code,4);
                    j = j + 1;
                case 2
                    res(bx) = out + bitshift(code,-2);
                    bx = bx + 1;
                    out = bitshift(code,6);
                    j = j + 1;
                case 3
                    res(bx) = out + code;
                    bx = bx + 1;
                    j = 0;
            end
        end
    end
end