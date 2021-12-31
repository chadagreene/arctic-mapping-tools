function h = patchpsn(lat,lon,varargin)
% patchpsn works just like Matlab's patch function, but plots georeferenced
% data in Arctic polar stereographic coordinates (true latitude 70S, central
% meridian 45W).
%
%  patchpsn(lat,lon,'b') 
% 
% is equivalent to 
% 
%  [x,y] = ll2psn(lat,lon); 
%  patch(x,y,'b')
% 
%% Syntax
% 
%  patchpsn(lat,lon,cdata)
%  patchpsn(...,z,cdata)
%  patchpsn(...,'PropertyName',PropertyValue,...)
%  patchpsn(...,'km') 
%  patchpsn(...,'meridian',meridian)
%  h = patchpsn(...)
% 
%% Description 
% 
% patchpsn(lat,lon,cdata) creates a patch object with an outline given by arrays 
% georeferenced coordinates lat and lon. Patch objects are then plotted in north 
% polar stereographic eastings and northings. 
% 
% patchpsn(...,z,cdata) specifies line or marker style. 
% 
% patchpsn(...,'PropertyName',PropertyValue,...) specifies any number of
% patch properties. 
% 
% patchpsn(...,'km') plots in polar stereographic kilometers instead of the
% default meters. 
% 
% patchpsn(...,'meridian',meridian) specifies a meridian longitude in the 
% polar stereographic coordinate conversion. Default meridian is -45. 
% 
% h = patchpsn(...) returns a column vector of handles to patch objects. .
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
% This function was written by Chad A. Greene of the University of Texas
% Institute for Geophysics (UTIG), adapted from the Antarctic Mapping Tools
% function patchps in June 2017.
%
% See also: patch, patchm, plotpsn, pcolorpsn, and ll2psn. 

%% Input checks: 

assert(nargin>1,'The patchpsn function requires at least two input: lat and lon.') 
assert(isnumeric(lat)==1,'patchpsn requires numeric inputs first.') 
assert(isnumeric(lon)==1,'patchpsn requires numeric inputs first.') 

if any(lat(:)<0)
   warning('Some latitudes are in the southern hemisphere. Are you sure you want to use the Arctic Mapping Tools function, or do you want Antarctic Mapping Tools instead?') 
end
%% Parse inputs

plotkm = false; % by default, plot in meters 
meridian = -45; % Standard projection

% Has user requested plotting in kilometers? 
if nargin > 2
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

h = patch(x,y,varargin{:}); 
hold on

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

