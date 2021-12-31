function h = arcticborders(varargin)
% This function plots national borders for an arctic polar stereographic map, 
% with true latitude 70 N and 45 W as the meridian.  This function does
% *not* require Matlab's Mapping Toolbox. Data are compiled from 2013 US 
% Census Bureau 500k data and thematicmapping.org TM World Borders 0.3 dataset. 
% https://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html
% http://thematicmapping.org/downloads/world_borders.php
% 
%% Syntax 
% 
%  arcticborders
%  arcticborders(LineProperty,LineValue)
%  arcticborders(PatchProperty,PatchValue)
%  h = arcticborders(...)
% 
%% Description 
% 
% arcticborders plots national borders. 
%
% arcticborders(...,LineProperty,LineValue) specifies linestyle or markerstyle.
% 
% arcticborders(...,PatchProperty,PatchValue) outlines nations as patch objects if any property begins
% with 'face', (e.g., 'facecolor','red'). Note that plotting all countries as patches can be a bit slow.  
%
% h = arcticborders(...) returns a handle h of plotted object(s). 
%
%% * * * E X A M P L E S * * *
% 
% % To plot all national borders, just type borders: 
% 
%    arcticborders
% 
% % Borders as black dotted outlines: 
% 
%    arcticborders('k:')
% 
% % Make land areas tan (rgb = [0.82 0.7 0.44]) with a red outline: 
% 
%    arcticborders('facecolor',[0.82 0.7 0.44],'edgecolor','r')
% 
%% Author Info
% This function was written by Chad A. Greene of the University of Texas at Austin
% Institute for Geophysics (UTIG).  It was adapted from my borders function in May 2016. 
% 
% See also plot and patch. 

%% Parse inputs: 

% Plot as line/marker data or patches with faces? 
if any(strncmpi(varargin,'face',4))
   faceplot = true; 
else
   faceplot = false; 
end

%% Load data 

load('arcticborderdata.mat'); 

%% Get initial conditions 

da = daspect; 
da = [1 1 da(3)]; 
hld = ishold; 
hold on
ax = axis; 
if isequal(ax,[0 1 0 1])
   MapWasOpen = false; 
else 
   MapWasOpen = true; 
end

%% Plot

hold on
if faceplot
   n = 1; 
   for k = 1:177
      xk = x{k}; 
      yk = y{k}; 

      nanz = [0,find(isnan(xk))];

      for kk = 1:length(nanz)-1
         h(n) = patch(xk(nanz(kk)+1:nanz(kk+1)-1),yk(nanz(kk)+1:nanz(kk+1)-1),.5*[1 1 1],varargin{:}); 
         n=n+1; 
      end

   end
else
      h = plot(cell2mat(x),cell2mat(y),varargin{:}); 
end
%% Put things back the way we found them: 

daspect(da)

if ~hld
   hold off
end

if MapWasOpen
   axis(ax)
end

%% Clean up 

if nargout == 0 
   clear h
end

end

