function [out1,out2,h] = coordpsn(varargin)
% coordpsn returns coordinates from mouse clicks. Returns north polar
% stereographic or geographic coordinates. 
% 
% After calling coordpsn, the current figure title will change to let you know
% you can start clicking.  Here are the commands: 
% 
%     Mouse click:   Places marker a marker and gets coordinates of the marker. 
%     Backspace:     Deletes previous marker like an Undo button. 
%     + or z:        Zooms in, centered on most recent click location (somewhat mediocre performance). 
%     - or x:        Zooms out, centered on most recent click location (somewhat mediocre performance).          
%     Escape key:    Terminates program without outputs. 
%     Return key:    Terminates program with data output.
%
%% Syntax
% 
%  coordpsn
%  [lat,lon] = coordpsn('geo')
%  [x,y] = coordpsn('xy') 
%  [...] = coordpsn(,...'MarkerProperty',MarkerValue)
%  [...] = coordpsn(...,'keep') 
%  [...,h] = coordpsn(...)
%
%% Description
% 
% coordpsn without any inputs prints coordinates of mouse clicks to the Command Window
% in a two-column format, [lat lon] or [x y].  Coordinates have the units of the 
% current axes unless 'geo' or 'xy' are specified.  
% 
% [lat,lon] = coordpsn('geo') specifies that you want outputs in geographic coordinates, 
% even if you are clicking around on a polar stereographic x/y map. 
% 
% [x,y] = coordpsn('xy') returns coordinates in polar stereographic (ps71) coordinates. 
% 
% [...] = coordpsn(,...'MarkerProperty',MarkerValue) specifies marker properties for 
% when you're clickin' around on the map.  
% 
% [...] = coordpsn(...,'keep') prevents coordpsn from automatically deleting markers upon
% exiting the user interface.  
% 
% [...,h] = coordpsn(...) returns a handle h of any plotted markers.   
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
% This function was written by Chad A. Greene of the University of 
% Texas at Austin's Institute for Geophysics (UTIG) in November 2015.  
% Come see me sometime at http://www.chadagreene.com. 
% 
% See also ginput and inputm.

%% Set defaults: 

keepPoints = false;   % delete points when user is finished. 
latlonout = false;    % Output in ps coordinates unless otherwise specified
latlonin = false;     % Assume input is in cartesian polar stereographic (71) unless we find that it is not.   

%% Get initial axis limits and whatnot: 

fig = gcf;            
ax = gca;
InitialAxes = axis; 
hold on
InitialNumberTitle = get(fig,'NumberTitle'); 
InitialName = get(fig,'Name'); 
set(fig,'NumberTitle','off','Name','Click to select points, Return to keep, or Esc to abort.')

%% Parse inputs 

% If current axes are map axes, then inputs are latlon:  
if license('test','map_toolbox')
    if ismap(ax) 
        latlonin = true; 
        latlonout = true; 
    end
end

% Did user request geo coordinates out? 
tmp = strcmpi(varargin,'geo'); 
if any(tmp)
    latlonout = true; 
    varargin = varargin(~tmp); 
end

% Did user request ps71 coordinates out? 
tmp = strcmpi(varargin,'xy'); 
if any(tmp)
    latlonout = false; 
    varargin = varargin(~tmp); 
end

% Determine whether markers should be kept on the figure:
tmp = strcmpi(varargin,'keep');
if any(tmp) 
    keepPoints = true; 
    varargin = varargin(~tmp); 
end

%% Run user interface:     

% Preallocate empty arrays of click locations:  
xi = []; 
yi = []; 

while true
    w = waitforbuttonpress; 
    switch w 
        case 1 % (keyboard press) 
            key = get(gcf,'currentcharacter'); 

            switch key
                case 8 % (backspace) delete most recent point. 
                    try
                        xi(end) = []; 
                        yi(end) = []; 
                        delete(h(end))
                        h(end) = []; 
                    end
                    
                case 13 % 13 is Return, 
                    if ~keepPoints
                        delete(h)
                    end
                    set(fig,'NumberTitle',InitialNumberTitle,'Name',InitialName); 
                    axis(InitialAxes)   
                    break % break out of the while loop
                    
                case 27 % 27 is the escape key
                    delete(h)
                    axis(InitialAxes)
                    set(fig,'NumberTitle',InitialNumberTitle,'Name',InitialName); 
                    return
                    
                case {122,90,43,61} % 122 and 90 are z and Z, 43 and 61 are + and =.  
                    lim = axis; % get current axis limits
                    pti=get(ax, 'CurrentPoint');  % get current cursor point
                    axis([pti(1,1)+diff(lim(1:2))/2*[-1 1] pti(1,2)+diff(lim(3:4))/2*[-1 1]]); % reset axis limits
                    zoom(2) % zoom in

                case {120,88,45} % lowercase x is 120, uppercase is 88 minus is 45
                    lim = axis; % get current axis limits
                    pti=get(ax, 'CurrentPoint');  % get current cursor point
                    axis([pti(1,1)+diff(lim(1:2))/2*[-1 1] pti(1,2)+diff(lim(3:4))/2*[-1 1]]); % reset axis limits
                    zoom(.5)
                    
                otherwise 
                  % Wait for a different command. 
            end
            
        case 0 % (mouse click)
            
            pta = get(gca,'CurrentPoint');
            newind = length(xi)+1; 
            
            xi(newind) = pta(1,1); 
            yi(newind) = pta(1,2); 
            
            h(newind) = plot(xi(end),yi(end),'yo','markerfacecolor','k',varargin{:}); 
            
     end
end

%% Perform coordinate conversions: 

xi = xi(:); 
yi = yi(:); 

if latlonin
    [lat,lon] = minvtran(xi,yi); 

    if latlonout
        out1 = lat; 
        out2 = lon; 
    else
        [out1,out2] = ll2psn(lat,lon); 
    end

else 
    if latlonout
        [out1,out2] = psn2ll(xi,yi); 
    else
        out1 = xi; 
        out2 = yi; 
    end
end
    
%% Organize outputs:     
    
% Reformat coordinates into two columns if 0 or 1 output is requested:  
if nargout<2
    out1 = [out1 out2]; 
end


end





