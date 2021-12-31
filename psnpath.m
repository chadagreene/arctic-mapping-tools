function [out1,out2] = psnpath(lat_or_x,lon_or_y,spacing,varargin)
% psnpath returns coordinates a path with equal spacing in polar stereographic 
% coordinates. This function might be used to find even spacing for common 
% interpolation points along a satellite ground track. 
% 
%% Syntax
% 
%  [lati,loni] = psnpath(lat,lon,spacing) 
%  [xi,yi] = psnpath(x,y,spacing) 
%  [...] = psnpath(...,'method',InterpolationMethod) 
% 
%% Description 
% 
% [lati,loni] = psnpath(lat,lon,spacing) connects the geographic points lat,lon 
% by a path whose points lati,loni are separated by spacing meters. If input
% coordinates are geo coordinates, output coodinates are also geo coordinates. 
% 
% [xi,yi] = psnpath(x,y,spacing) connects the polar stereographic points x,y 
% by a path whose points xi,yi are separated by spacing meters. If input
% coordinates are polar stereographic coordinates, output coodinates are also 
% polar stereographic coordinates. 
% 
% [...] = psnpath(...,'method',InterpolationMethod) specifies an interpolation 
% method for path creation. Default is 'linear'. 
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
% This function was created by Chad A. Greene of the University of Texas at Austin
% Institute for Geophysics (UTIG), April 2016. 
% 
% See also: psngrid and pathdistpsn.  

%% Initial error checks: 

narginchk(3,inf) 
nargoutchk(2,2) 
assert(isvector(lat_or_x)==1,'Input error: input coordinates must be vectors of matching dimensions.') 
assert(isequal(size(lat_or_x),size(lon_or_y))==1,'Input error: dimensions of input coordinates must match.') 
assert(isscalar(spacing)==1,'Input error: spacing must be a scalar.') 

%% Input parsing: 

% Determine input coordinates:
if islatlon(lat_or_x,lon_or_y) 
   geoin = true; 
   [x,y] = ll2psn(lat_or_x,lon_or_y); 
else
   geoin = false; 
   x = lat_or_x; 
   y = lon_or_y; 
end

% Did user specify an interpolation method? 
tmp = strncmpi(varargin,'method',4); 
if any(tmp) 
   method = varargin{find(tmp)+1}; 
else
   method = 'linear'; 
end   

%% Mathematics: 

% Calculate distance along the path given by input coordinates:  
d = pathdistpsn(x,y); 

% Interpolate xi and yi values individually to common spacing along the path: 
xi = interp1(d,x,0:spacing:d(end),method); 
yi = interp1(d,y,0:spacing:d(end),method); 

%% Package outputs: 

% Columnate xi,yi for consistent behavior: 
xi = xi(:); 
yi = yi(:); 

% Transpose outputs if inputs were row vectors: 
if isrow(lat_or_x) 
   xi = xi'; 
   yi = yi'; 
end

% Convert to geo coordinates if inputs were geo coordinates: 
if geoin
   [out1,out2] = ps2ll(xi,yi); 
else
   out1 = xi; 
   out2 = yi;
end


end