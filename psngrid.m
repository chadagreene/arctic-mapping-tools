function [out1,out2] = psngrid(varargin)
% psngrid creates a grid of specified spatial resolution in north polar
% stereographic coordinates. 
% 
%% Syntax
% 
%  [lat,lon] = psngrid(CenterLat,CenterLon,width_km,resolution_km)
%  [lat,lon] = psngrid(CenterX,CenterY,width_km,resolution_km)
%  [x,y] = psngrid(...,'xy')
% 
%% Description 
% 
% [lat,lon] = psngrid(CenterLat,CenterLon,width_km,resolution_km) returns
% a grid of width_km width in kilometers, resolution_km resolution in
% kilometers, centered on the location given by CenterLat, CenterLon.
% If width_km is a two-element vector, the first element is interpreted as 
% width and the second element is height. If resolution_km is a two element vector, 
% the first element is interpreted as horizontal resolution and the second
% element is interpreted as vertical resolution. 
%
% [lat,lon] = psngrid(CenterX,CenterY,width_km,resolution_km) centers the
% grid on polar stereographic coordinate (CenterX,CenterY) in meters. Polar 
% stereographic meters assumed if absolute values exceed normal values of geo 
% coordinates. 
%
% [x,y] = psngrid(...,'xy') returns a grid in polar stereographic meters (ps70). 
%  
%% Example 
% For a 200 km wide grid centered on Petermann Glacier, 3 km resolution: 
% 
%  [lat,lon] = psngrid(80.75,-65.75,200,3); 
%  
%  greenland('patch')
%  plotpsn(lat,lon,'k.') 
%  mapzoompsn(80.75,-65.75,'mapwidth',200,'nw')
%  axis off
%  scalebarpsn('location','se')
%
%% Citing Antarctic Mapping Tools
% This function was developed for Antarctic Mapping Tools for Matlab (AMT). If AMT is useful for you,
% please cite our paper: 
% 
% Greene, C. A., Gwyther, D. E., & Blankenship, D. D. Antarctic Mapping Tools for Matlab. 
% Computers & Geosciences. 104 (2017) pp.151-157. 
% http://dx.doi.org/10.1016/j.cageo.2016.08.003
% 
% @article{amt,
%   title={{Antarctic Mapping Tools for \textsc{Matlab}}},
%   author={Greene, Chad A and Gwyther, David E and Blankenship, Donald D},
%   journal={Computers \& Geosciences},
%   year={2017},
%   volume={104},
%   pages={151--157},
%   publisher={Elsevier}, 
%   doi={10.1016/j.cageo.2016.08.003}, 
%   url={http://www.sciencedirect.com/science/article/pii/S0098300416302163}
% }
%   
%% Author Info 
% This function was written by Chad A. Greene of the University of Texas at
% Austin's Institute for Geophysics (UTIG). Adapted from the Antarctic
% Mapping Tools function psgrid, June 2017.
% 
% See also psn2ll, ll2psn, and meshgrid. 


%% Error checks: 

narginchk(3,5) 
assert(nargout==2,'psngrid requires exactly two outputs--either lat and lon or polar stereographic x and y.') 

%% Parse Inputs: 

% If first input is numeric, assume it's lat or x:  
if isnumeric(varargin{1})
    assert(isnumeric(varargin{2})==1,'If the first input to psngrid is not a location name, the first two inputs must be lat and lon or polar sterographic x and y.')
    assert(isscalar(varargin{1})==1,'Input coordinates must be scalar.') 
    assert(isscalar(varargin{2})==1,'Input coordinates must be scalar.') 
    
    if islatlon(varargin{1},varargin{2})
        [centerx,centery] = ll2psn(varargin{1},varargin{2}); 
    else
        centerx = varargin{1}; 
        centery = varargin{2}; 
    end
    
    % If coordinates are defined, grid width and resolution are inputs 3 and 4: 
    width_km = varargin{3}; 
    resolution_km = varargin{4}; 
   
else % If first input is not numeric, assume it's a place name: 
%     [centerx,centery] = scarloc(varargin{1},'xy'); 
    
    % If location name is defined, grid width and resolution are inputs 2 and 3: 
    width_km = varargin{2}; 
    resolution_km = varargin{3};  
end

% Define x and y values for grid width: 
switch numel(width_km)
    case 1
        widthx = width_km*1000; % The *1000 bit converts from km to meters. 
        widthy = width_km*1000; 

    case 2
        widthx = width_km(1)*1000; 
        widthy = width_km(2)*1000; 
        
    otherwise
        error('I must have misinterpreted something. As I understand it, you have requested a grid width with more than two elements. Check inputs and try again.') 
end
        
% Define x and y values for resolution: 
switch numel(resolution_km)
    case 1
        resx = resolution_km*1000; % The *1000 bit converts from km to meters. 
        resy = resolution_km*1000; 

    case 2
        resx = resolution_km(1)*1000; 
        resy = resolution_km(2)*1000; 
        
    otherwise
        error('I must have misinterpreted something. As I understand it, you have requested a grid resolution with more than two elements. Check inputs and try again.') 
end

% Verify that resolution is not greater than width: 
assert(widthx>resx,'It looks like there''s an input error in psngrid because the grid width should be bigger than the grid resolution. Check inputs and try again.') 
assert(widthy>resy,'It looks like there''s an input error in psngrid because the grid width should be bigger than the grid resolution. Check inputs and try again.') 
assert(resx>0,'Grid resolution must be greater than zero.') 
assert(resy>0,'Grid resolution must be greater than zero.') 
assert(widthx>0,'Grid width must be greater than zero.') 
assert(widthy>0,'Grid width must be greater than zero.') 

% Should outputs be polar stereographic? 
if any(strcmpi(varargin,'xy'))
    outputps = true; 
else 
    outputps = false;
end

%% Build grid: 

x = centerx-widthx/2 : resx : centerx+widthx/2; 
y = centery-widthy/2 : resy : centery+widthy/2; 

[X,Y] = meshgrid(x,y); 

%% Convert coordinates if necessary: 

if outputps
    out1 = X; 
    out2 = Y; 
else
    [out1,out2] = psn2ll(X,Y); 
end

end

