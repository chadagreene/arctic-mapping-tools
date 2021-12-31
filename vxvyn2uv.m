function [u,v] = vxvyn2uv(lat_or_x,lon_or_y,vx,vy)
% vxvyn2uv transforms north polar stereographic vector components to
% georeferenced (zonal and meridional) vector components. 
% 
% This function assumes north polar stereographic coordinates 
% with the standard central meridian at 45 W. 
% 
%% Syntax
% 
%  [U,V] = vxvyn2uv(lat,lon,vx,vy)
%  [U,V] = vxvyn2uv(x,y,vx,vy)
% 
%% Description 
% 
% [U,V] = vxvyn2uv(lat,lon,vx,vy) transforms north polar stereographic vector
% components vx, vy referenced to the geographic locations in lat and lon to
% geographic zonal and meridional components. 
% 
% [U,V] = vxvyn2uv(x,y,vx,vy) transforms north polar stereographic vector
% components vx, vy referenced to the polar stereographic locations in x and y to
% geographic zonal and meridional components. Polar stereographic
% coordinates are automatically determined if any value in the first two
% inputs of vxvyn2uv exceed normal geographic coordinate values. 
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
% Austin's Institute for Geophysics (UTIG). September 2015.  
% http://www.chadagreene.com
% 
% See also uv2vxvyn, ll2psn, psn2ll, and psngrid. 

%% Input Checks: 

narginchk(4,4) 
nargoutchk(2,2) 
assert(isnumeric(lat_or_x)==1,'All inputs for vxvyn2uv must be numeric.') 
assert(isnumeric(lon_or_y)==1,'All inputs for vxvyn2uv must be numeric.') 
assert(isnumeric(vx)==1,'All inputs for vxvyn2uv must be numeric.') 
assert(isnumeric(vy)==1,'All inputs for vxvyn2uv must be numeric.') 
assert(isequal(size(lat_or_x),size(lon_or_y),size(vx),size(vy))==1,'All inputs to vxvyn2uv must be of equal dimensions.') 

%% Parse inputs: 

% Determine whether inputs are geo coordinates or polar stereographic meters 
if islatlon(lat_or_x,lon_or_y)
    lon = lon_or_y; % lat is really just a placeholder to make the function a little more intuitive to use. It is not necessary for calculation. 
else
    [~,lon] = psn2ll(lat_or_x,lon_or_y); 
end

%% Perform coordinate transformations 

% Assume central meridian 45W: 
lon = lon+45; 

u = vx .* cosd(lon) + vy.* sind(lon);
v = vy .* cosd(lon) - vx.* sind(lon);


end