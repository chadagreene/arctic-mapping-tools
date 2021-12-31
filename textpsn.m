function h = textpsn(lat,lon,string,varargin)
% textpsn works just like Matlab's text or textm functions, but plots georeferenced
% data in Arctic polar stereographic coordinates (true latitude 70S, central
% meridian 45W). For example, 
% 
%  textpsn(lat,lon,'My text') 
% 
% is equivalent to: 
% 
%  [x,y] = ll2psn(lat,lon); 
%  text(x,y,'My text') 
% 
%% Syntax
% 
%  textpsn(lat,lon,'string')
%  textpsn(...,'PropertyName',PropertyValue,...)
%  textpsn(...,'km')
%  textpsn(...,'meridian',meridian)
%  h = textpsn(...)
% 
%% Description 
% 
% textpsn(lat,lon,'string') adds the string in quotes to the location specified 
% by the point (lat,lon) polar stereographic eastings and northings. 
% 
% textpsn(...,'PropertyName',PropertyValue,...) formats the string with any
% name-value pairs of text properties. 
% 
% textpsn(...,'km') plots in polar stereographic kilometers instead of the
% default meters. 
% 
% textpsn(...,'meridian',meridian) specifies a meridian longitude in the 
% polar stereographic coordinate conversion. Default meridian is -45. 
% 
% h = textpsn(...) returns a column vector of handles to text objects, one handle 
% per object.
% 
%% Example 1: A single label:  
% 
% textpsn(69.167,-49.833,'Jakobshavn Glacier')
% 
%% Example 2: Multiple labels, formatted real pretty: 
% If you have a long list of locations to label, do 'em all at once: 
% 
% lat = [66.3, 80.75]; 
% lon = [-38.2 -65.75]; 
% places = {'Helheim Glacier';'Petermann Glacier'}; 
% 
% textpsn(lat,lon,places,'fontangle','italic','fontsize',30,'color','red')
% 
%% Citing Antarctic Mapping Tools
% If thi function is useful for you, please cite the following paper: 
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
% Institute for Geophysics (UTIG), adapted from Antarctic Mapping Tools
% June 2017. 
%
% See also: text, textm, ll2psn, and plotpsn. 

%% Input checks: 

assert(nargin>2,'The textpsn function requires at least three inputs: lat, lon, and a text string.') 
assert(isnumeric(lat)==1,'textpsn requires numeric inputs first.') 
assert(isnumeric(lon)==1,'textpsn requires numeric inputs first.') 

if any(lat(:)<0)
   warning('Some latitudes are in the southern hemisphere. Are you sure you want to use the Arctic Mapping Tools function, or do you want Antarctic Mapping Tools instead?') 
end
%% Parse inputs

plotkm = false; % by default, plot in meters 
meridian = -45; % Standard projection

% Has user requested plotting in kilometers? 
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

h = text(x,y,string,'horiz','center',varargin{:}); 

set(h,'clipping','on')
hold on; 

%% Put things back the way we found them: 

daspect(da)

if ~hld
   hold off
end


%% Clean up: 

if nargout==0
    clear h
end

end

