function [vx,vy] = uv2vxvyn(lat_or_x,lon_or_y,u,v) 
% uv2vxvyn transforms georeferenced (zonal and meridional) vector
% components to cartesian (polar stereographic) coordinate components. 
% This function is for the northern hemisphere. 
% 
% This function assumes north polar stereographic coordinates 
% with the standard central meridian at 45 W. 
% 
%% Syntax
% 
%  [vx,vy] = uv2vxvyn(lat,lon,U,V)
%  [vx,vy] = uv2vxvyn(x,y,U,V)
% 
%% Description 
% 
% [vx,vy] = uv2vxvyn(lat,lon,U,V) transforms zonal U and meridional V
% components of a vector field to cartesian horizontal vx and vertical
% vy components. Inputs lat and lon define locations of each point in
% U and V. 
% 
% [vx,vy] = uv2vxvyn(x,y,U,V)  transforms zonal U and meridional V
% components of a vector field to cartesian horizontal vx and vertical
% vy components. Inputs lat and lon define locations of each point in
% vx and vy. Polar stereographic coordinates are automatically determined 
% if any value in the first two inputs of uv2vxvyn exceed normal geographic 
% coordinate values. 
% 
%% Citing Antarctic Mapping Tools
% If this function is useful for you, please cite the following paper: 
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
% Mapping Tools function uv2vxvy June 2017. 
% http://www.chadagreene.com
% 
% See also vxvyn2uv, ll2psn, psn2ll, and psngrid. 

%% Input Checks: 

narginchk(4,4) 
nargoutchk(2,2) 
assert(isnumeric(lat_or_x)==1,'All inputs for uv2vxvyn must be numeric.') 
assert(isnumeric(lon_or_y)==1,'All inputs for uv2vxvyn must be numeric.') 
assert(isnumeric(u)==1,'All inputs for uv2vxvyn must be numeric.') 
assert(isnumeric(v)==1,'All inputs for uv2vxvyn must be numeric.') 
assert(isequal(size(lat_or_x),size(lon_or_y),size(u),size(v))==1,'All inputs to uv2vxvyn must be of equal dimensions.') 

%% Parse inputs: 

% Determine whether inputs are geo coordinates or polar stereographic meters 
if islatlon(lat_or_x,lon_or_y)
    lon = lon_or_y; % lat is really just a placeholder to make the function a little more intuitive to use. It is not necessary for calculation. 
else
    [~,lon] = psn2ll(lat_or_x,lon_or_y); 
end

%% Perform calculation: 

% Assume central meridian 45 W: 
lon = lon + 45; 

vx = u.*cosd(lon) - v.*sind(lon); 
vy = u.*sind(lon) + v.*cosd(lon); 


end
