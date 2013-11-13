Matlab-Fast-SOAP - a faster Matlab replacement for the default SOAP functions
See the end of the file for license conditions.

Written by:

Edo Frederix
The Johns Hopkins University / Eindhoven University of Technology
Department of Mechanical Engineering
edofrederix@jhu.edu, edofrederix@gmail.com


---- Summary -----------------------------------------------------------------

Matlab-Fast-SOAP is a library that replaces the original Matlab SOAP functions
createSoapMessage(), callSoapService() and parseSoapResponse() with more
efficient alternatives.

The reason for replacement is straightforward: speed. The native SOAP
functions make use of a Document Object Model (DOM) approach. This is very
slow for a large set of elements, as process time scales somewhat
exponentially with the number of elements in the DOM. By using simple string
operations, creating the SOAP message, as well as parsing the SOAP message,
will take less time.

This modification and the gain in speed of course comes with a payoff: the
flexibility of the DOM approach is completely lost. Therefore, these fast SOAP
functions are rigid and only useful to people who do not need this
flexibility. Also, the benefit of a non-DOM approach will only become
noticeable for very large XML documents with many repetitive elements.


---- Credits -----------------------------------------------------------------

All code in this package is written by:

  Edo Frederix
  The Johns Hopkins University / Eindhoven University of Technology
  Department of Mechanical Engineering
  edofrederix@jhu.edu, edofrederix@gmail.com

This package is shipped under the terms of the GNU General Public License
version 3 or any later version. A copy of the GNU GPL v3 resides in this
package. A more formal statement can be found at the bottom of this file.

---- Documentation -----------------------------------------------------------

This library comes with three function files: createSoapMessage.m,
callSoapService.m and parseSoapResponse.m. Compared to the original versions
of these files, all three functions take differently structured input
variables, and produce differently structured output. This turned out to be a
requirement for speeding up the process.

---- createSoapMessage ----

--  Syntax --

char message = createSoapMessage(char namespace, char method, struct data, ...
                                 char type);

-- Description --

createSoapMessage creates a SOAP message based on the values you provide for
the arguments. 'message' is a character string, rathar than a Sun Java DOM. To
send message to the Web service, use it with callSoapService. The arguments
taken by createSoapMessage are:

namespace:  Location of the Web service in the form of a valid Uniform
            Resource Identifier (URI).
  
method:     Name of the Web service operation you want to run.
  
data:       Structure of input you need to provide for the method.

style:      Style for structuring the SOAP message, either 'document' or
            'rpc'. Specifying style is optional; when you do not include the
            argument, MATLAB uses rpc. Use a style supported by the service
            you specified in namespace.
            
-- data argument --

The data argument is a Matlab structure. A structure in the data argument
represents an XML element, and always contains the following fields:

val         The content of this XML element, enclosed by XML tags. This may be
            a double or char array, cell or another structure. If class(val)
            equals char or double, the content of 'val' will be written to the
            content of the XML element.
            In case of a structure, all the fields in var will be treated as a
            new XML element. This means that every structure field within
            'val' should again have a field 'val' and optionally a field
            'name', 'type, and so on.
            In the last case, 'val' may be a cell. Every field in the cell can
            either become a new value (in case of a char or double) or a new
            element in case of a structure.
name        (Optional) The tag name of the XML element, which will wrap the
            content. If this field is not set, the content will not be wrapped
            by an XML tag. The field name of the structure parent (in which
            'name' is in) does not determine the tag name. The 'name' field
            does.
type        (Optional) The XML xsi:type element attribute value, determined by
            reference to the appropriate schema component.
wrap        (Optional) You may assign an extra XML wrapper which will wrap
            every element in the 'val' field.
parallel    (Optional) If this field is set to 1, createSoapMessage will try
            to build the content of this element in a parallel way, rather
            than consecutively.

-- Example --

This example makes use of all features in the new createSoapMessage function:

  data.name = 'GetStockPrice';
  data.val.StockName.name = 'StockName';
  data.val.StockName.val = 'IBM';
  data.val.Points.name = 'Points';
  data.val.Points.val.x.val = rand(1,3);
  data.val.Points.val.x.name = 'x';
  data.val.Points.val.y.val = rand(1,3);
  data.val.Points.val.y.name = 'y';
  data.val.Points.wrap = 'points2d';
  data.val.Points.parallel = 1;
  data.val.Extra.name = 'Extra';
  data.val.Extra.val = {10, 'ten', struct('val', 20, 'name', 'tag')};
  data.val.Extra.wrap = 'Item';

  soapMessage = createSoapMessage( ...
      'http://www.example.com/', ...
      'GetRandomInfo', ...
      data, 'document');

The result stored in soapMessage is a string of chars, without any line
breaks. If we feed the content of soapMessage to a XML tidy() function, we
get:

  <?xml version="1.0" encoding="utf-8"?>
  <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <soap:Body 
    soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
      <GetRandomInfo xmlns="http://www.example.com/">
        <GetStockPrice>
          <StockName>IBM</StockName>
          <Points>
            <points2d>
              <x>0.2510838580</x>
              <y>0.3516595071</y>
            </points2d>
            <points2d>
              <x>0.6160446761</x>
              <y>0.8308286279</y>
            </points2d>
            <points2d>
              <x>0.4732888489</x>
              <y>0.5852640912</y>
            </points2d>
          </Points>
          <Extra>
            <Item>10.0000000000</Item>
            <Item>ten</Item>
            <Item>
              <tag>20.0000000000</tag>
            </Item>
          </Extra>
        </GetStockPrice>
      </GetRandomInfo>
    </soap:Body>
  </soap:Envelope>

We see that we have specified parallel tags within the Points XML element. The
result is that we get separate rows of <x> and <y> sets, while we have
specified the input only in two vectors (rand(1,3) and rand(1,3)). If we would
not specify the parallel behavior, our output for the <Points> element would
look like:

  <Points>
    <points2d>
      <x>0.5497236083</x>
    </points2d>
    <points2d>
      <x>0.9171936638</x>
    </points2d>
    <points2d>
      <x>0.2858390188</x>
    </points2d>
    <points2d>
      <y>0.7572002291</y>
    </points2d>
    <points2d>
      <y>0.7537290943</y>
    </points2d>
    <points2d>
      <y>0.3804458470</y>
    </points2d>
  </Points>


---- callSoapService ----

--  Syntax --

char response = callSoapService(char url, char action, char message);

-- Description --

callSoapService uses a stripped down version of the original callSoapService
to create a connection the the web server, send the XML and receive the
response. In case of an error, callSoapService will catch and report this.
Otherwise, the XML response will be returned in a char string. The arguments
taken by callSoapService are:

url:        Location of the Web service in the form of a valid Uniform
            Resource Identifier (URI).
  
action:     URI to the Web service operation you want to run.
  
message:    Valid Soap XML message string.

-- Example --

In addition to the example in the createSoapMessage example, we can execute
the following Matlab routine to send the XML message to the server, and catch
the XML response:

  response = callSoapService( ...
      'http://www.example.com/service/getinfo.asmx', ...
      'http://www.example.com/GetInfo', ...
      soapMessage);


---- parseSoapResponse ----

-- Syntax --

struct structure = parseSoapResponse(char response);

-- Description --

The parseSoapResponse function tries to efficiently convert the supplied
string, containing a valid XML document, into a structure containing all body
elements. To this end, simple string operations are used, in contrast to the
traditional DOM approach. parseSoapResponse tries to convert XML elements with
floating point numbers into arrays of doubles, using the fast sscanf() Matlab
function. The arguments taken by callSoapService are:

response:   An XML response in a string char format.

-- Example --

A random response received with callSoapService may look like:

  <?xml version="1.0" encoding="utf-8"?>
  <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <soap:Body>
      <GetInfoResponse xmlns="http://www.example.com/">
        <GetInfoResult>
          <Points2>
            <x>-17.9194431</x>
            <y>-0.251039922</y>
          </Points2>
          <Points2>
            <x>-17.8687267</x>
            <y>-0.270278633</y>
          </Points2>
          <Points2>
            <x>-13.6408911</x>
            <y>-0.02318016</y>
          </Points2>
          <tag>Some more information</tag>
          <tag>Even more</tag>
        </GetInfoResult>
      </GetInfoResponse>
    </soap:Body>
  </soap:Envelope>

  
This result, being stored in a char string 'response' can then be converted to
a structure using parseSoapResponse with the Matlab code:

  responseStruct = parseSoapResponse(response);
  
The resulting structure will look like (written out):

  responseStruct = 
    GetInfoResult: [1x1 struct] =
      Points2: [1x1 struct]
          tag: [1x1 struct]
        
  s.GetInfoResult.Points2 = 
    x: [3x1 double]
    y: [3x1 double]

  s.GetInfoResult.tag =
    Some more information
    Even more


---- Example.m: test case ----------------------------------------------------

This package comes with an example.m Matlab file. This example script nicely
illustrates the power of Matlab-Fast-SOAP.

The script connects to the Johns Hopkins University Turbulence Database
Cluster. The JHU turbulence database provides access to a direct numerical
simulation (DNS) of forced isotropic turbulence. It contains a very large
dataset of 1024^3 nodes and 1024 time steps. For more information regarding
the database, visit http://turbulence.pha.jhu.edu/.

The turbulence database uses SOAP web services to enable users to perform
database queries for datasets of any size. For large datasets, we need to be
able to quickly build large XML files, and to quickly parse the XML response
of the database. The included example will try to fetch the 9-component
velocity gradient of a surface of 64^2 points.

The example.m file can be run as is. The output - depending on your bandwidth
and routing to the JHU Turbulence Database Cluster and local CPU - will look
like:

  Fetching 9 velocity gradient components for 64x64 points (36864 XML entries)
  Creating the SOAP message: 0.164388 s
  Sending SOAP message and receiving SOAP response: 3.285216 s
  Parsing SOAP response (into responseStruct): 0.192808 s
  
We can also run the example.m file for even larger datasets, for example a
256^2 surface. With the original DOM approach, this would require a super
computer with a very fast CPU and a large amount of memory. With the new
approach, the result will look like (again, depending on bandwidth and CPU):

  Fetching 9 velocity gradient components for 256x256 points (589824 XML
  entries)
  Creating the SOAP message: 0.630183 s
  Sending SOAP message and receiving SOAP response: 21.680725 s
  Parsing SOAP response (into responseStruct): 3.404503 s
  
And the resulting structure will contain the vectors:

  responseStruct.GetVelocityGradientResult.VelocityGradient =
      duxdx: [65536x1 double]
      duxdy: [65536x1 double]
      duxdz: [65536x1 double]
      duydx: [65536x1 double]
      duydy: [65536x1 double]
      duydz: [65536x1 double]
      duzdx: [65536x1 double]
      duzdy: [65536x1 double]
      duzdz: [65536x1 double]

Note: in order to perform large requests on the JHU turbulence database (more
that 4096 points), you will need a different authentication token. Please
visit http://turbulence.pha.jhu.edu/help/authtoken.html for more information
on this.


---- License -----------------------------------------------------------------

This file is part of Matlab-Fast-SOAP.

Matlab-Fast-SOAP is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

Matlab-Fast-SOAP is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
details.

You should have received a copy of the GNU General Public License along with
Turbmat. If not, see <http://www.gnu.org/licenses/>.