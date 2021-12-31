function h = mapzoompsn(varargin)
% mapzoompsn zooms a north polar stereographic map to a specified location and extent
% and/or places an inset map of Greenland for spatial context. 
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
%% Syntax
% 
% mapzoompsn
% mapzoompsn(lat,lon) 
% mapzoompsn(x,y)
% mapzoompsn(...,'size',mapsizekm)
% mapzoompsn(...,InsetLocation)
% mapzoompsn(...,'insetsize',sizefraction)
% mapzoompsn(...,'frame','off')
% mapzoompsn(...,'km')
% h = mapzoompsn(...) 
% 
%% Description 
% 
% mapzoompsn(lat,lon) centers a 500 km wide map about the georeferenced 
% location given by lat, lon. 
% 
% mapzoompsn(x,y) centers a 500 km wide map about the polar stereographic 
% eastings and northings x and y. 
% 
% mapzoompsn(...,'size',mapsizekm) specifies size of the map in kilometers given 
% mapsizekm, which can be a scalar to create a square map or a two-element array
% for a rectangular map in the form [mapwidthkm mapheightkm], where mapwidthkm and
% mapheightkm are the dimensions of the map in kilometers. 
%
% mapzoompsn(...,InsetLocation) creates an inset map at the location InsetLocation,
% which can be 
%           'southeast' or 'se'  lower right corner 
%           'northwest' or 'nw'  upper left corner
%           'northeast' or 'ne'  upper right corner
%           'southwest' or 'sw'  lower left corner
%
% mapzoompsn(...,'insetsize',sizefraction) specifies size of the inset as a
% fraction of the width of the current map. Default sizefraction is 0.25. 
%
% mapzoompsn(...,'frame','off') removes frame from the inset. 
%
% mapzoompsn(...,'km') is for plots in polar stereographic kilometers rather than the default meters.
% 
% h = mapzoompsn(...) returns a handle h of inset map axes. 
% 
%% Example 1 
% Zoom in on Petermann Glacier like this: 
% 
%   greenland
%   mapzoompsn(80.75,-65.75,'ne')
%
%% Author Info 
% This function and supporting documentation were written by Chad A. Greene of the 
% University of Texas at Austin's Institute for Geophysics (UTIG), June 2017. 
% Feel free to contact me if you have any questions or comments. 
% http://www.chadagreene.com
% 
% See also scarloc, scarlabel, scarclick, and scalebarpsn. 

%% Set defaults: 

inset = false; 
insetsize = 0.25; 
frameon = true; 
location = 'northeast'; 
usekm = false; 
if nargin==0 
   UseCurrentExtents = true; 
else
   UseCurrentExtents = false; 
   mapsize = [500 500]; % sets default map size to 500 km by 500 km
end

%% Parse inputs: 

% Inset location: 
tmp = strcmpi(varargin,'southwest')|strcmpi(varargin,'northwest')|...
      strcmpi(varargin,'southeast')|strcmpi(varargin,'northeast')|...
      strcmpi(varargin,'sw')|strcmpi(varargin,'nw')|...
      strcmpi(varargin,'se')|strcmpi(varargin,'ne'); 
if any(tmp)
   inset = true; 
   location = varargin{tmp}; 
   if tmp(1)
      UseCurrentExtents = true; 
   end
end

% Check for inset size declaration: 
tmp = strcmpi(varargin,'insetsize'); 
if any(tmp) 
   inset = true; 
   insetsize = varargin{find(tmp)+1}; 
   if tmp(1)
      UseCurrentExtents = true; 
   end
end
   
% Check for frame declaration: 
tmp = strcmpi(varargin,'frame');
if any(tmp)
   inset = true; 
   if strcmpi(varargin{find(tmp)+1},'off')||strcmpi(varargin{find(tmp)+1},'none');
      frameon = false; 
   if tmp(1)
      UseCurrentExtents = true; 
   end
   end
end

% Map width: 
tmp = strcmpi(varargin,'size')|strcmpi(varargin,'mapsize')|strcmpi(varargin,'mapwidth')|strcmpi(varargin,'mapwidthkm')|strcmpi(varargin,'width'); 
if any(tmp)
   mapsize = varargin{find(tmp)+1}; 
   assert(isnumeric(mapsize)==1,'Map size must be numeric.'); 
   if isscalar(mapsize) 
      mapsize = [mapsize mapsize]; 
   end
   assert(numel(mapsize)==2,'Map size must be a one- or two-element numeric value.') 
end

% Polar stereographic kilometers or meters? 
tmp = strcmpi(varargin,'km'); 
if any(tmp) 
   usekm = true; 
   if tmp(1)
      UseCurrentExtents = true; 
   end
end
   

% Center location declaration: 
if ~UseCurrentExtents

  % User has entered location by coordinates: 
  if islatlon(varargin{1},varargin{2})
     [xc,yc] = ll2psn(varargin{1},varargin{2}); 
  else
     xc = varargin{1}; 
     yc = varargin{2}; 
  end
   
end

%% Set axes of map: 

% Find and delete old inset if one exists:
try
   hinsetmap = findobj(gcf,'tag','insetmap'); 
   delete(hinsetmap); 
end

gcah = gca; % handle of initial plot

if UseCurrentExtents
   ax = axis; 
else
   axis equal xy
   ax = [xc-mapsize(1)*500 xc+mapsize(1)*500 yc-mapsize(2)*500 yc+mapsize(2)*500]; 
   axis(ax); 
end

% Define x,y coordinates of axis perimeter: 
axx = [ax(1) ax(2) ax(2) ax(1) ax(1)];
axy = [ax(3) ax(3) ax(4) ax(4) ax(3)]; 
   
%% Place an inset map: 

if inset
      
    gp = plotboxpos(gca); 
    
    insetwidth = insetsize*gp(3); 
    insetheight = insetsize*gp(4); % just changed this to 4 (was 3 for a year or so? ) 
    
    switch lower(location)
        case {'southwest','sw'}
            insetx = gp(1);
            insety = gp(2);   
            
        case {'northeast','ne'}
            insetx = gp(1) + gp(3) - insetwidth;
            insety = gp(2) + gp(4) - insetheight; 
            
        case {'northwest','nw'}
            insetx = gp(1); 
            insety = gp(2) + gp(4) - insetheight; 
            
        case {'southeast','se'}
            insetx = gp(1) + gp(3) - insetwidth;
            insety = gp(2);            
            
        otherwise 
            error('Unrecognized inset location.')
    end
    

   % Create new set of axes for inset map: 
   h = axes('position',[insetx insety insetwidth insetheight],'tag','insetmap');
   hold on
   
  
   % Plot greenland: 
   greenland('patch','facecolor',0.75*[1 1 1],'linewidth',0.2)
   
   % Plot red box:
   if usekm
      plot(axx*1000,axy*1000,'r-','linewidth',1); 
   else
      plot(axx,axy,'r-','linewidth',1); 
   end
      
   axis equal tight
   
   
   % Set final dimensions after plotting the inset: 
   gpinset = plotboxpos(gca); 
   insetwidth = gpinset(3); 
   insetheight = gpinset(4); % just changed this to 4 (was 3 for a year or so? ) 
    
    switch lower(location)
        case {'southwest','sw'}
            insetx = gp(1);
            insety = gp(2);   
            
        case {'northeast','ne'}
            insetx = gp(1) + gp(3) - insetwidth;
            insety = gp(2) + gp(4) - insetheight; 
            
        case {'northwest','nw'}
            insetx = gp(1); 
            insety = gp(2) + gp(4) - insetheight; 
            
        case {'southeast','se'}
            insetx = gp(1) + gp(3) - insetwidth;
            insety = gp(2);            
            
        otherwise 
            error('Unrecognized inset location.')
    end
   
   
   % Format inset axes: 
   set(gca,'xtick',[],'ytick',[],'position',[insetx insety insetwidth insetheight])
   if frameon
      box on
   else
      axis off
   end
   
  
   % Make the original map axes current: 
   axes(gcah); 
   
   % Ensure inset map is on top of the stack: 
   uistack(gcah,'down');
   
   
  % Clean up: 
  if nargout==0 
     clear h
  end
end




%% Kelly Kearney's plotboxpos function: 

function pos = plotboxpos(h)
%PLOTBOXPOS Returns the position of the plotted axis region
%
% pos = plotboxpos(h)
%
% This function returns the position of the plotted region of an axis,
% which may differ from the actual axis position, depending on the axis
% limits, data aspect ratio, and plot box aspect ratio.  The position is
% returned in the same units as the those used to define the axis itself.
% This function can only be used for a 2D plot.  
%
% Input variables:
%
%   h:      axis handle of a 2D axis (if ommitted, current axis is used).
%
% Output variables:
%
%   pos:    four-element position vector, in same units as h

% Copyright 2010 Kelly Kearney

% Check input

if nargin < 1
    h = gca;
end

if ~ishandle(h) || ~strcmp(get(h,'type'), 'axes')
    error('Input must be an axis handle');
end

% Get position of axis in pixels

currunit = get(h, 'units');
set(h, 'units', 'pixels');
axisPos = get(h, 'Position');
set(h, 'Units', currunit);

% Calculate box position based axis limits and aspect ratios

darismanual  = strcmpi(get(h, 'DataAspectRatioMode'),    'manual');
pbarismanual = strcmpi(get(h, 'PlotBoxAspectRatioMode'), 'manual');

if ~darismanual && ~pbarismanual
    
    pos = axisPos;
    
else

    dx = diff(get(h, 'XLim'));
    dy = diff(get(h, 'YLim'));
    dar = get(h, 'DataAspectRatio');
    pbar = get(h, 'PlotBoxAspectRatio');

    limDarRatio = (dx/dar(1))/(dy/dar(2));
    pbarRatio = pbar(1)/pbar(2);
    axisRatio = axisPos(3)/axisPos(4);

    if darismanual
        if limDarRatio > axisRatio
            pos(1) = axisPos(1);
            pos(3) = axisPos(3);
            pos(4) = axisPos(3)/limDarRatio;
            pos(2) = (axisPos(4) - pos(4))/2 + axisPos(2);
        else
            pos(2) = axisPos(2);
            pos(4) = axisPos(4);
            pos(3) = axisPos(4) * limDarRatio;
            pos(1) = (axisPos(3) - pos(3))/2 + axisPos(1);
        end
    elseif pbarismanual
        if pbarRatio > axisRatio
            pos(1) = axisPos(1);
            pos(3) = axisPos(3);
            pos(4) = axisPos(3)/pbarRatio;
            pos(2) = (axisPos(4) - pos(4))/2 + axisPos(2);
        else
            pos(2) = axisPos(2);
            pos(4) = axisPos(4);
            pos(3) = axisPos(4) * pbarRatio;
            pos(1) = (axisPos(3) - pos(3))/2 + axisPos(1);
        end
    end
end

% Convert plot box position to the units used by the axis

temp = axes('Units', 'Pixels', 'Position', pos, 'Visible', 'off', 'parent', get(h, 'parent'));
set(temp, 'Units', currunit);
pos = get(temp, 'position');
delete(temp);
        