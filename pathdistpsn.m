function d = pathdistpsn(lat_or_x,lon_or_y,varargin)
% pathdistpsn returns the cumulative distance along a path in polar stereographic 
% coordinates (true lat 70 N, central meridian 45 W). 
% 
%% Syntax
% 
%  d = pathdistpsn(lat,lon)
%  d = pathdistpsn(x,y)
%  d = pathdistpsn(...,'km')
%  d = pathdistpsn(...,'ref',[reflat reflon])
%  d = pathdistpsn(...,'ref',[refx refy])
% 
%% Description 
% 
% d = pathdistpsn(lat,lon) returns the cumulative distance d in meters along the path 
% specified by geo coordinates lat,lon. Coordinates must be vectors of equal size. 
%
% d = pathdistpsn(x,y) returns the cumulative distance d in meters along the path 
% specified by polar stereographic coordinates x,y where x and y are vectors of equal
% size in ps70 meters.  
%
% d = pathdistpsn(...,'km') simply divides output by 1000 to give distance in kilometers. 
% 
% d = pathdistpsn(...,'ref',[reflat reflon]) references the output to the track coordinate
% nearest to the location given by a two-element vector [reflat reflon].  This might be 
% useful when analyzing distance along a satellite ground track relative to a point of 
% interest such as a grounding line. 
% 
% d = pathdistpsn(...,'ref',[refx refy]) references the output as above, but using polar
% stereogprahic (ps70) coordinates. 
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
% This function was written by Chad A. Greene of the University of Texas
% at Austin Institute for Geophysics (UTIG), April 2016. 
% http://www.chadagreene.com
% 
% See also: pathdist, pspath, and cumsum. 

%% Initial error checks: 

narginchk(2,inf) 
assert(isvector(lat_or_x)==1,'Input Error: input coordinates must be vectors.') 
assert(isequal(size(lat_or_x),size(lon_or_y))==1,'Input error: Dimensions of input coordinates must agree.') 

%% Set defaults: 

kmout = false; 
ref = false; 

%% Parse inputs: 

% Convert geo coordinates to ps71 if necessary: 
if islatlon(lat_or_x,lon_or_y)
   [x,y] = ll2psn(lat_or_x,lon_or_y); 
else
   x = lat_or_x; 
   y = lon_or_y; 
end

% Does the user want output in kilometers? 
if any(strcmpi(varargin,'km'))
   kmout = true; 
end

% Does the user want the output distances in reference to some location?  
tmp = strcmpi(varargin,'ref'); 
if any(tmp)
   ref = true; 
   refcoord = varargin{find(tmp)+1}; 
   assert(numel(refcoord)==2,'Input Error: Reference coordinate must be a two-element vector.') 
   if islatlon(refcoord(1),refcoord(2))
      [refx,refy] = ll2psn(refcoord(1),refcoord(2)); 
   else
      refx = refcoord(1); 
      refy = refcoord(2); 
   end
end
   

%% Perform mathematics: 

% Cumulative sum of distances: 
if isrow(x)
   d = [0,cumsum(hypot(diff(x),diff(y)))]; 
else
   d = [0;cumsum(hypot(diff(x),diff(y)))];
end

% Reference to a location: 
if ref
   dist2refpoint = hypot(x-refx,y-refy); 
   [~,mind] = min(dist2refpoint); 
   d = d - d(mind(1)); 
end

% Convert to kilometers if user wants it that way: 
if kmout
   d = d/1000; 
end


end