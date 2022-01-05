function h = label_greenland_glaciers(varargin)
% label_greenland_glaciers places text labels on a map of Greenland. 
%
%% Syntax
% 
%  label_greenland_glaciers
%  label_greenland_glaciers('TextProperty',TextValue,...)
%  label_greenland_glaciers(...'shadow')
%  h = label_greenland_glaciers
% 
%% Description
% 
% label_greenland_glaciers labels Greenland glaciers. 
%
% label_greenland_glaciers('TextProperty',TextValue,...) applies any text
% formatting such as fontsize, fontangle, color, etc. 
% 
% label_greenland_glaciers(...'shadow') places a "shadow" behind the text
% to make labels more visible atop a busy background. Matlab doesn't
% actually allow shadow or outline text, so this is just a clunky solution
% that creates eight white slightly offset text labels below the main label. 
%
% h = label_greenland_glaciers(...) returns handles h of the plotted text
% objects. If shadowing is applied, the first column of h is the main text,
% and columns 2 through 9 are the shadow text. To change the shadow text
% color to red, for example you may type this after applying the label: 
% set(h(:,2:9),'color','r').
% 
%% Example 
% Plot an outline of Greenland and apply labels: 
% 
% figure
% greenland
% label_greenland_glaciers
% 
%% Reference
% The glacier names and locations in this dataset are taken from Rignot
% & Mouginot, 2012. https://doi.org/10.1029/2012GL051634
%
%% Author Info 
% Chad A. Greene, NASA/JPL, December 2021. 

D = load('greenland_glacier_names.mat'); 

tmp = strcmpi(varargin,'shadow'); 
if any(tmp)
   varargin = varargin(~tmp); 
   
   %pos = getpixelposition(gca);
   x0 = [-1 0 1 1 1 0 -1 -1]*diff(xlim)/5000;
   y0 = [-1 -1 -1 0 1 1 1 0]*diff(xlim)/5000;
   
   for k=1:8
      h(:,k+1) = text(D.x+x0(k),D.y+y0(k),D.name,...
         'horiz','center',...
         'vert','middle',...
         'fontsize',6,...
         'fontangle','italic',...
         'clipping','on',...
         varargin{:}); 
      
   end
   set(h(:,2:end),'color','w')
   
end

h(:,1) = text(D.x,D.y,D.name,...
   'horiz','center',...
   'vert','middle',...
   'fontsize',6,...
   'fontangle','italic',...
   'clipping','on',...
   varargin{:}); 

if nargout==0
   clear h
end

end