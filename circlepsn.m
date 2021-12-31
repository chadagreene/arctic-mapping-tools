function h = circlepsn(lat_or_x,lon_or_y,radius_km,varargin)
% circlepsn plots circles of given radii in north polar stereographic 
% projection map. Latitude of true scale is 70N, central meridian 45 W. 
% 
%% Syntax 
%
%  circlepsn(lat,lon,radius_km)
%  circlepsn(x,y,radius_km)
%  circlepsn(...,'PropertyName',PropertyValue)
%  circlepsn(...,'km')
%  circlepsn(...,'meridian',meridian)
%  h = circlepsn(...)
% 
%% Description
% 
% circlepsn(lat,lon,radius_km) plots circle(s) of specified radius in kilometers centered at points 
% given by geo coordinates lat and lon.  
% 
% circlepsn(x,y,radius_km) lets you input coordinates as polar stereographic meters. Coordinates are 
% automatically determined by the islatlon function. 
% 
% circlepsn(...,'PropertyName',PropertyValue) specifies patch or fill properties 
% such as 'facecolor' or 'linewidth'. 
%
% circlepsn(...,'km') plots in polar stereographic kilometers rather than meters. 
% 
% circlepsn(...,'meridian',meridian) specifies a meridian longitude in the 
% polar stereographic coordinate conversion. Default meridian is -45. 
% 
% h = circlepsn(...) returns the handle(s) h of the plotted circle(s). 
% 
%% Examples: 
% Given these three places:
% 
%   lat = [66.3, 80.75 69.167]; 
%   lon = [-38.2 -65.75 -49.833]; 
% 
% Plot circles of 100 km radius centered on each glacier:
% 
%   circlepsn(lat,lon,1000)
% 
% Make them blue filled circles with thick red outlines--and give them
% different radii: 
% 
%   circlepsn(lat,lon,[150 278 300],'facecolor','b','edgecolor','r','linewidth',4)
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
% Austin's Institute for Geophysics (UTIG). October 2016. Adapted into 
% a northern hemisphere version June 2017.
% http://www.chadagreene.com
% 
% See also plotpsn, patchpsn, and pathdistpsn. 

%% Check inputs: 

narginchk(3,inf) 
assert(isequal(size(lat_or_x),size(lon_or_y))==1,'Input error: Coordinate dimensions do not match.') 
assert(isnumeric(radius_km)==1,'Input error: Make sure radius_km is numeric.') 
if ~isscalar(radius_km) 
   assert(isequal(size(lat_or_x),size(radius_km))==1,'Input error: Circle radius declaration must either be a scalar value or its dimensions must match the dimensions of the circle center coordinates.') 
end

%% Set defaults: 

NOP = 1000; % number of points per circle. 
meridian = -45; % Standard projection

%% Parse inputs: 

tmp = strcmpi(varargin,'meridian'); 
if any(tmp)
meridian = varargin{find(tmp)+1}; 
assert(isscalar(meridian)==1,'Error: meridian must be a scalar longitude.') 
tmp(find(tmp)+1) = true; 
varargin = varargin(~tmp); 
end

% Check input coordinates: 
if islatlon(lat_or_x,lon_or_y)
   [x,y] = ll2psn(lat_or_x,lon_or_y,'meridian',meridian); 
else
   x = lat_or_x; 
   y = lon_or_y; 
end

% Be forgiving if the user enters "color" instead of "facecolor"
tmp = strcmpi(varargin,'color');
if any(tmp)
    varargin{tmp} = 'facecolor'; 
end

% Plot in meters or kilometers? 
tmp = strcmpi(varargin,'km'); 
if any(tmp)
   varargin = varargin(~tmp); 
   x = x/1000; 
   y = y/1000;
   r = radius_km; 
else
   r = radius_km*1000; 
end
   
%% Begin operations:

% Make inputs column vectors: 
x = x(:); 
y = y(:);
r = r(:); 

if isscalar(r)
   r = repmat(r,size(x)); 
end

% Define an independent variable for drawing circle(s):
t = 2*pi/NOP*(1:NOP); 

%% Get initial figure conditions:  

% aspect ratio: 
da = daspect; 
da = [1 1 da(3)]; 

% Query original hold state:
holdState = ishold; 
hold on; 

%% Plot 

% Preallocate object handle: 
h = NaN(size(x)); 

% Plot circles singly: 
for n = 1:numel(x)
    h(n) = fill(x(n)+r(n).*cos(t), y(n)+r(n).*sin(t),'','facecolor','none',varargin{:});
end

%% Clean up: 

if ~holdState
   hold off
end

daspect(da) 

% Delete object handles if not requested by user: 
if nargout==0 
    clear h 
end

end

