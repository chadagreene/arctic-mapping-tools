function h = greenland(varargin) 
% greenland plots a coastline of Greenland as a line or patch object. 
% 
%% Syntax
% 
%  greenland
%  greenland(LineSpec)
%  greenland(...,'PropertyName',PropertyValue,...) 
%  greenland(...,'km') 
%  greenland(...,'patch') 
%  greenland(...,'meridian',meridian') 
%  h = greenland(...) 
%
%% Description 
% 
% greenland plots an outline of Greenland in north polar stereographic meters. 
% 
% greenland(LineSpec) specifies line style just like you might with the plot function. 
% 
% greenland(...,'PropertyName',PropertyValue,...) specifies any number of line or patch properties. 
% 
% greenland(...,'km') plots in polar stereographic kilometers rather than meters. 
% 
% greenland(...,'patch') plots Greenland as a filled patch object. 
% 
% greenland(...,'meridian',meridian) specifies a meridian longitude in the 
% polar stereographic coordinate conversion. Default meridian is -45. 
% 
% h = greenland(...) returns a handle h of the plotted object. 
% 
%% Citing these tools 
% This function is built on Antarctic Mapping Tools for Matlab. If it's useful for you,
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
% This function was written by Chad A. Greene of the University of Texas Institute
% for Geophysics (UTIG). 
% 
% See also arcticborders and plotpsn. 


%% Parse inputs

% Set defaults: 
plotkm = false;    % by default, plot in meters 
patchplot = false; % Plot line by default. 
meridian = -45;

if nargin > 0
    tmp = strcmpi(varargin,'km'); 
    if any(tmp)
        plotkm = true; 
        varargin = varargin(~tmp); 
    end
    
    tmp = strcmpi(varargin,'patch'); 
    if any(tmp)
        patchplot = true; 
        varargin = varargin(~tmp); 
    end
   
   tmp = strcmpi(varargin,'meridian'); 
   if any(tmp)
      meridian = varargin{find(tmp)+1}; 
      assert(isscalar(meridian),'Error: meridian must be a scalar longitude.') 
      tmp(find(tmp)+1) = true; 
      varargin = varargin(~tmp); 
   end
end

%% Load data

B = load('greenland_coast.mat'); 

% Unproject and reproject if necessary: 
if meridian~=-45
   [lat,lon] = psn2ll(B.xx,B.yy); 
   [B.xx,B.yy] = ll2psn(lat,lon,'meridian',meridian); 
end
   
%% Get initial conditions 

da = daspect; 
da = [1 1 da(3)]; 
hld = ishold; 
hold on
ax = axis; 
if isequal(ax,[0 1 0 1])
    NewMap = true; 
else
    NewMap = false; 
end

%% Plot

if patchplot
   
      xk = B.xx'; 
      yk = B.yy'; 
      
      if plotkm
         xk = xk/1000; 
         yk = yk/1000; 
      end

      nanz = [0,find(isnan(xk))];

      for kk = 1:length(nanz)-1
         h(kk) = patch(xk(nanz(kk)+1:nanz(kk+1)-1),yk(nanz(kk)+1:nanz(kk+1)-1),.5*[1 1 1],varargin{:}); 
      end
else
   if plotkm
      h = plot(B.xx/1000,B.yy/1000,varargin{:}); 
   else
      h = plot(B.xx,B.yy,varargin{:}); 
   end
end

%% Put things back the way we found them: 

daspect(da)

if ~hld
   hold off
end

if ~NewMap
    axis(ax)
end

%% Clean up: 

if nargout==0
    clear h
end
