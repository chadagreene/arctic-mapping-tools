function h = scatterpsn(lat,lon,varargin)
% scatterpsn works just like Matlab's scatter function, but plots georeferenced
% data in Arctic polar stereographic coordinates (true latitude 70S, central
% meridian 45W). For example, 
% 
%  scatterpsn(lat,lon,S,C) 
% 
% is equivalent to 
% 
%  [x,y] = ll2psn(lat,lon); 
%  scatter(x,y,S,C)
% 
%% Syntax
% 
%  scatterpsn(lat,lon,S,C)
%  scatterpsn(lat,lon)
%  scatterpsn(lat,lon,S)
%  scatterpsn(...,markertype)
%  scatterpsn(...,'filled')
%  scatterpsn(...,'PropertyName',PropertyValue)
%  scatterpsn(...,'km')
%  scatterpsn(...,'meridian',meridian)
%  h = scatterpsn(...)
% 
%% Description 
% 
% scatterpsn(lat,lon,S,C) displays colored circles at the locations specified by 
% the vectors lat and lon (which must be the same size), plotted in north 
% polar stereographic eastings and northings. S can be a vector the same length 
% as lat and lon or a scalar. If S is a scalar, MATLAB draws all the markers the 
% same size. If S is empty, the default size is used.
% 
% scatterpsn(lat,lon) draws the markers in the default size and color.
% 
% scatterpsn(lat,lon,S) draws the markers at the specified sizes (S) with a single 
% color. This type of graph is also known as a bubble plot.
% 
% scatterpsn(...,markertype) uses the marker type specified instead of 'o' (see 
% LineSpec for a list of marker specifiers).
%
% scatterpsn(...,'filled') fills the markers. 
% 
% scatterpsn(...,'km') plots in polar stereographic kilometers instead of the
% default meters. 
% 
% scatterpsn(...,'meridian',meridian) specifies a meridian longitude in the 
% polar stereographic coordinate conversion. Default meridian is -45. 
% 
% h = scatterpsn(...) returns the handle of the scattergroup object created.
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
% Institute for Geophysics (UTIG), June 2017 2015. Adapted from scatterps
% in the Antarctic Mapping Tools package. 
%
% See also: scatter, scatterm, ll2psn, pcolorpsn, and plotpsn. 

%% Input checks: 

assert(nargin>1,'The scatterpsn function requires at least two input: lat and lon.') 
assert(isnumeric(lat)==1,'scatterpsn requires numeric inputs first.') 
assert(isnumeric(lon)==1,'scatterpsn requires numeric inputs first.') 

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

h = scatter(x,y,varargin{:}); 

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

