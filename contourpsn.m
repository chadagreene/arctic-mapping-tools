function [C,h] = contourpsn(lat,lon,Z,varargin)
% contourpsn works just like Matlab's contour function, but plots georeferenced
% data in Arctic polar stereographic coordinates (true latitude 70S, central
% meridian 45W). For example, 
% 
%  contourpsn(lat,lon,Z) 
% 
% is equivalent to 
% 
%  [x,y] = ll2psn(lat,lon); 
%  contour(x,y,Z) 
% 
%% Syntax
% 
%  contourpsn(lat,lon,Z)
%  contourpsn(lat,lon,Z,n)
%  contourpsn(lat,lon,Z,v)
%  contourpsn(...,LineSpec)
%  contourpsn(...,'km')
%  contourpsn(...,'meridian',meridian)
%  [C,h] = contourpsn(...)
% 
%% Description 
% 
% contourpsn(lat,lon,Z) draws contours of Z at gridded locations lat,
% lon. 
% 
% contourpsn(lat,lon,Z,n) specifies a number of contour levels n if n is a scalar. 
% 
% contourpsn(lat,lon,Z,v) draws a contour plot of matrix Z with contour lines at the 
% data values specified in the monotonically increasing vector v. The number of contour 
% levels is equal to length(v). To draw a single contour of level i, use v = [i i]; 
% 
% contourpsn(...,LineSpec) draws the contours using the line type and color specified 
% by LineSpec. contour ignores marker symbols.
% 
% contourpsn(...,'km') plots in polar stereographic kilometers instead of the
% default meters. 
% 
% contourpsn(...,'meridian',meridian) specifies a meridian longitude in the 
% polar stereographic coordinate conversion. Default meridian is -45. 
% 
% [C,h] = contourpsn(...) returns contourpsn matrix C and handle h of the contour object created.
% 
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
% Institute for Geophysics (UTIG), June 2017, adapted from contourps in 
% Antarctic Mapping Tools for Matlab. 
%
% See also: scatter, scatterm, ll2psn, pcolorpsn, and plotpsn. 

%% Input checks: 

assert(nargin>2,'The contourpsn function requires at least three input: lat and lon and Z.') 
assert(isnumeric(lat)==1,'contourpsn requires numeric inputs first.') 
assert(isnumeric(lon)==1,'contourpsn requires numeric inputs first.') 
assert(isnumeric(Z)==1,'contourpsn requires numeric Z input.') 
assert(isvector(lat)==0,'lat must be 2D grid.') 
assert(isvector(lon)==0,'lon must be 2D grid.') 
assert(isvector(Z)==0,'Z must be 2D grid.') 

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

[C,h] = contour(x,y,Z,varargin{:}); 
hold on; 

%% Put things back the way we found them: 

daspect(da)

if ~hld
   hold off
end

%% Clean up: 

if nargout==0
    clear C h
end

end

