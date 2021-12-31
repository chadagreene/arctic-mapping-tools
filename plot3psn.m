function h = plot3psn(lat,lon,z,varargin)
% plot3psn works just like Matlab's plot3 function,  but plots georeferenced
% data in Arctic polar stereographic coordinates (true latitude 70S, central
% meridian 45W).
% 
%  plot3psn(lat,lon,z) 
% 
% is equivalent to: 
% 
%  [x,y] = ll2psn(lat,lon); 
%  plot3(x,y,z) 
% 
%% Syntax
% 
%  plot3psn(lat,lon,z)
%  plot3psn(...,LineSpec)
%  plot3psn(...,'PropertyName',PropertyValue,...)
%  plot3psn(...,'km')
%  plot3psn(...,'meridian',meridian)
%  h = plot3psn(...)
% 
%% Description 
% 
% plot3psn(lat,lon,z) plots georeferenced data in north polar stereographic
% eastings and northings. 
% 
% plot3psn(...,LineSpec) specifies line or marker style. 
% 
% plot3psn(...,'PropertyName',PropertyValue,...) specifies any number of
% line or marker properties. 
% 
% plot3psn(...,'km') plots in polar stereographic kilometers instead of the
% default meters. 
% 
% plot3psn(...,'meridian',meridian) specifies a meridian longitude in the 
% polar stereographic coordinate conversion. Default meridian is -45. 
% 
% h = plot3psn(...) returns a column vector of handles to lineseries objects, 
% one handle per line.
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
% Institute for Geophysics (UTIG), June 2017, adapted from plot3ps in the
% Antarctic Mapping Tools package. 
% 
% See also: plot3, plot3m, and surfpsn. 

%% Input checks: 

assert(nargin>2,'The plot3psn function requires at least three inputs: lat, lon, and z.') 
assert(islatlon(lat,lon)==1,'I suspect you have entered silly data into plot3psn because some of the lats or lons fall outside the normal range of geo coordinates.') 

if any(lat(:)<0)
   warning('Some latitudes are in the southern hemisphere. Are you sure you want to use the Arctic Mapping Tools function, or do you want Antarctic Mapping Tools instead?') 
end
%% Parse inputs

plotkm = false; % by default, plot in meters 
meridian = -45; % Standard projection

% Has user requested plot3ting in kilometers? 
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

%% Convert units and plot3: 

[x,y] = ll2psn(lat,lon,'meridian',meridian); 

% Convert to kilometers if user requested:
if plotkm
    x = x/1000; 
    y = y/1000; 
end

h = plot3(x,y,z,varargin{:}); 
axis tight
set(gca, 'DataAspectRatio', [diff(get(gca, 'XLim')) diff(get(gca, 'XLim')) diff(get(gca, 'ZLim'))])
hold on; 

%% Clean up: 

if nargout==0
    clear h
end

end

