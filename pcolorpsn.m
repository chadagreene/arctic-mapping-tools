function h = pcolorpsn(lat,lon,Z,varargin)
% pcolorpsn works just like Matlab's pcolor function, but plots georeferenced
% data in Arctic polar stereographic coordinates (true latitude 70S, central
% meridian 45W).
% 
%% Syntax
% 
%  pcolorpsn(lat,lon,Z)
%  pcolorpsn(...,'PropertyName',PropertyValue,...)
%  pcolorpsn(...,'km') 
%  pcolorpsn(...,'meridian',meridian)
%  h = pcolorpsn(...)
% 
%% Description 
% 
% pcolorpsn(lat,lon,Z) constructs a surface to represent the data grid Z 
% corresponding to a georeferenced lat,lon grid in South polar stereographic
% eastings and northings. 
% 
% pcolorpsn(...,'PropertyName',PropertyValue,...) specifies any number of
% surface properties. 
% 
% pcolorpsn(...,'km') plots in polar stereographic kilometers instead of the
% default meters. 
% 
% pcolorpsn(...,'meridian',meridian) specifies a meridian longitude in the 
% polar stereographic coordinate conversion. Default meridian is -45. 
%     
% h = pcolorpsn(...) returns a column vector of handles to surface objects.
% 
%% Citing Antarctic Mapping Tools
% This function was adapted from Antarctic Mapping Tools for Matlab (AMT). If it's useful for you,
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
% This function was written by Chad Greene of the University of Texas
% Institute for Geophysics (UTIG), June 2017. It was adapted from 
% Antarctic Mapping Tools for Matlab. 
%
% See also: plotps, pcolor, pcolorm, surf, surface, patchps, and ll2psn. 

%% Input checks: 

assert(nargin>2,'The pcolorpsn function requires at least three inputs: lat, lon, and Z.') 
assert(isnumeric(lat)==1,'pcolorpsn requires numeric inputs first.') 
assert(isnumeric(lon)==1,'pcolorpsn requires numeric inputs first.') 

if any(lat(:)<0)
   warning('Some latitudes are in the southern hemisphere. Are you sure you want to use the Arctic Mapping Tools function, or do you want Antarctic Mapping Tools instead?') 
end
%% Parse inputs

plotkm = false; % by default, plot in meters 
meridian = -45; % Standard projection

% Has user requested plotting in kilometers? 
if nargin > 3
    tmp = strcmpi(varargin,'km'); 
    if any(tmp)
        plotkm = true; 
        varargin = varargin(~tmp); 
    end
   
   tmp = strcmpi(varargin,'meridian'); 
   if any(tmp)
      meridian = varargin{find(tmp)+1}; 
      assert(isscalar(meridian)==1,'Error: meridian must be a scalar longitude.') 
      tmp(find(tmp)+1) = true; 
      varargin = varargin(~tmp); 
   end
end

%% Get initial conditions 

da = daspect; 
da = [1 1 da(3)]; 
hld = ishold; 
hold on

%% Convert units and plot: 

[x,y] = ll2psn(lat,lon,'meridian',meridian); 

% Convert to kilometers if user requested:
if plotkm
    x = x/1000; 
    y = y/1000; 
end

h = pcolor(x,y,Z,varargin{:}); 
shading flat
hold on; 

%% Put things back the way we found them: 

daspect(da)

if ~hld
   hold off
end

%% Clean up: 

if nargout==0
    clear h
end

end