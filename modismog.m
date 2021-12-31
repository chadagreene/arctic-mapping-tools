function h = modismog(varargin)
% modismog initializes a MODIS Mosaic of Greenland (MOG) image or adds a MODIS 
% MOG to an existing map. This function does NOT require Matlab's Mapping Toolbox. 
% 
%% First, get the data! 
%
% Get the mog100_2015_hp1_v02.tif file here: https://nsidc.org/data/nsidc-0547
% 
%% Syntax
% 
%  modismog
%  modismog(...,'contrast',ContrastOption)
%  modismog(...'clearocean',true_or_false) 
%  modismoaps(...'km') 
%  h = modismog(...)
% 
%% Description 
% 
% modismog fills a current map with a MODIS MOG image. If a map is not already open, 
% modismog initializes a continent-wide map.
% 
% modismog(...,'contrast',ContrastOption)specifies contrast, or the axis
% limits of the color scale. Following the contrast options described in the
% web-based <http://nsidc.org/data/moa/users_guide.html MOA map users'
% guide>, ContrastOption may be:
% 
% * 'uhc'     (ultra-high contrast [15875 16125])
% * 'vhc'  	(very high contrast [15800 16200])
% * 'hc'  	(high contrast [15500 16500])
% * 'moa'  	(nominal contrast [15000 17000])
% * 'lc'   	(low contrast [12000 20000])
% * 'vlc'  	(very low contrast [9000 23000])
% * 'ulc'   	(ultra-low contrast [1 32000])
% * 'white'  (good for semitransparent color overlay [1 17000])
% * NumericRange (any two-element range) 
% 
% modismog(...'clearocean',true_or_false) makes open-ocean image data transparent. 
% The results are not very pretty because sea ice remains, but no mask is distributed
% with the MODIS MOG datasets.  
% 
% modismoaps(...'km') plots in polar stereographic kilometers rather than meters.  
%
% h = modismog(...) returns a handle for plotted image or line data. 
% 
%% Example 1: Continent-wide image: 
% This may take a few seconds because the image is so dang large
% 
% modismog 
% 
%% Example 2: Small region image: 
% Zooming to a small region before calling modismog is much faster than 
% loading and plotting the entire dataset. 
% 
% figure
% mapzoompsn(64.4,-49.8,'se','frame','off')
% modismog('contrast','white') 
% scalebarps('color','white')
% 
%% Citing these Data
% When citing MODIS MOA data, please cite the following: 
% 
% Haran, T., J. Bohlander, T. Scambos, T. Painter, and M. Fahnestock. 2018. 
% MEaSUREs MODIS Mosaic of Greenland (MOG) 2005, 2010, and 2015 Image Maps, 
% Version 2. [Indicate subset used]. Boulder, Colorado USA. NSIDC: National 
% Snow and Ice Data Center. doi: https://doi.org/10.5067/9ZO79PHOTYE5. 
%
% Greene, C.A., Gwyther, D.E. and Blankenship, D.D., 2016. Antarctic Mapping Tools for Matlab. 
% Computers & Geosciences.  http://dx.doi.org/10.1016/j.cageo.2016.08.003
% 
%% Author Info
% This function was written by Chad A. Greene, Feb2020, adapted
% from modismoaps. 
% http://www.chadagreene.com
% 
% See also scalebarpsn, graticulepsn, and mapzoompsn. 

%% Set defaults:

year = 2015;         % no other years currently supported
datatype = 'image';  % no other options
hld = 1;             % hold state of image
imagefilename = 'mog100_2015_hp1_v02.tif'; 
BrightnessRange = [15000 17000];
clearocean = false; 
plotkm = false; % ps meters by default

%% Parse inputs:

% Contrast for MOA image: 
tmp = strncmpi(varargin,'contrast',4);
if any(tmp)
   BrightnessRange = varargin{find(tmp)+1}; 
   
   % User-defined brightness range? 
   if isnumeric(BrightnessRange) 
      BrightnessRange = varargin{find(tmp)+1};
      assert(isnumeric(BrightnessRange)==1,'Invalid contrast range. Must be a string (e.g., ''vhc'') or numeric range (e.g. [15800 16200]).')
      assert(numel(BrightnessRange)==2,'Invalid contrast range. Must be a string (e.g., ''vhc'') or numeric range (e.g. [15800 16200]).')

   else    
      % Or use NSIDC's brightness ranges: 
      switch lower(BrightnessRange)
         case {'moa_uhc','uhc','uh','ultra high'} 
            BrightnessRange = [15875 16125]; 
         case {'moa_vhc','vhc','vh','very high'}
            BrightnessRange = [15800 16200]; 
         case {'moa_hc','hc','h','high'}
            BrightnessRange = [15500 16500]; 
         case {'moa','default'}
            BrightnessRange = [15000 17000];
         case {'moa_lc','lc','l','low'}
            BrightnessRange = [12000 20000];
         case {'moa_vlc','vlc','vl','very low'}
            BrightnessRange = [9000 23000];
         case {'moa_ulc','ulc','ul','ultra low'} 
            BrightnessRange = [1 32000];
         case {'white'}
            BrightnessRange = [1 17000]; % white-ish
         otherwise
            error('Invalid contrast range. Must be a string (e.g., ''vhc'') or numeric range (e.g. [15800 16200]).')
      end
   end
        
   tmp(find(tmp)+1) = 1; 
   varargin = varargin(~tmp); 
end

% Make open water pixels transparent? 
tmp = strncmpi(varargin,'clearocean',5);
if any(tmp)
   clearocean = varargin{find(tmp)+1}; 
   assert(islogical(clearocean)==1,'Input error: clearocean option must be true or false.') 
   tmp(find(tmp)+1) = 1; 
   varargin = varargin(~tmp); 
end

% Plot in ps kilometers?  
tmp = strcmpi(varargin,'km'); 
if any(tmp)
   plotkm = true; 
   varargin = varargin(~tmp); 
end

%% Get initial conditions of the figure: 

% Aspect ratio and hold state: 
da = daspect; 
da = [1 1 da(3)]; 
hld = ishold; 
hold on

axlim = axis; 

% Is a map already open? 
if isequal(axlim,[0 1 0 1])
   axlim = [-1199950 899950 -3399950  -600050]; 
else
   if plotkm
      axlim = axlim*1000; 
   end
end

%% Coordinates:

x = -1199950:100:899950; 
y = (-600050:-100:-3399950)';

%% Load data

assert(exist(imagefilename,'file')==2,'Error: cannot find the image file. Make sure you have  and Matlab can find the data.') 

% Find indices corresponding to axis limits: 
xind = find(x>=axlim(1) & x<=axlim(2)); 
yind = find(y>=axlim(3) & y<=axlim(4)); 

% Clip the arrays: 
x = x(xind); 
y = y(yind); 

% Load image:  
moa = imread(imagefilename, 'PixelRegion', {[yind(1) yind(end)],[xind(1) xind(end)]});

% Convert grayscale values to RGB image: 
RGB = mat2im(moa,gray(256),BrightnessRange); 
      
%% Plot data 

if plotkm 
   x = x/1000; 
   y = y/1000; 
end

h = image(x,y,RGB); 
axis xy

if clearocean
   set(h,'alphadata',moa>0)
end

% Push image to bottom of the stack: 
uistack(h,'bottom') 
      
%% Clean up: 

axis xy 
daspect(da)

if plotkm
   axis(axlim/1000)
else
   axis(axlim)
end

if ~hld
   hold off
end

if nargout==0
   clear h
end
end


function im=mat2im(mat,cmap,limits)
% mat2im - convert to rgb image
%
% function im=mat2im(mat,cmap,maxVal)
%
% PURPOSE
% Uses vectorized code to convert matrix "mat" to an m-by-n-by-3
% image matrix which can be handled by the Mathworks image-processing
% functions. The the image is created using a specified color-map
% and, optionally, a specified maximum value. Note that it discards
% negative values!
%
% INPUTS
% mat     - an m-by-n matrix  
% cmap    - an m-by-3 color-map matrix. e.g. hot(100). If the colormap has 
%           few rows (e.g. less than 20 or so) then the image will appear 
%           contour-like.
% limits  - by default the image is normalised to it's max and min values
%           so as to use the full dynamic range of the
%           colormap. Alternatively, it may be normalised to between
%           limits(1) and limits(2). Nan values in limits are ignored. So
%           to clip the max alone you would do, for example, [nan, 2]
%          
%
% OUTPUTS
% im - an m-by-n-by-3 image matrix  
%
%
% Example 1 - combine multiple color maps on one figure 
% clf, colormap jet, r=rand(40);
% subplot(1,3,1),imagesc(r), axis equal off , title('jet')
% subplot(1,3,2),imshow(mat2im(r,hot(100))) , title('hot')
% subplot(1,3,3),imshow(mat2im(r,summer(100))), title('summer')
% colormap winter %changes colormap in only the first panel
%
% Example 2 - clipping
% p=peaks(128); J=jet(100);
% subplot(2,2,1), imshow(mat2im(p,J)); title('Unclipped')
% subplot(2,2,2), imshow(mat2im(p,J,[0,nan])); title('Remove pixels <0')
% subplot(2,2,3), imshow(mat2im(p,J,[nan,0])); title('Remove pixels >0')
% subplot(2,2,4), imshow(mat2im(p,J,[-1,3])); title('Plot narrow pixel range')
%
% Rob Campbell - April 2009
%
% See Also: ind2rgb, imadjust


%Check input arguments

if ~isa(mat, 'double')
    mat = double(mat)+1;    % Switch to one based indexing
end

if ~isnumeric(cmap)
    error('cmap must be a colormap, such as jet(100)')
end


%Clip if desired
L=length(cmap);
if nargin==3 && length(limits)==1
    warning('limits should be vector of length of 2. Assuming a max value was specified.')
    limits=[nan,limits];
end


if nargin==3
    minVal=limits(1);
    if isnan(minVal), minVal=min(mat(:)); end    
    mat(mat<minVal)=minVal;
    
    maxVal=limits(2);
    if isnan(maxVal), maxVal=max(mat(:)); end
    mat(mat>maxVal)=maxVal;        
else
minVal=min(mat(:));
maxVal=max(mat(:));
end


%Normalise 
mat=mat-minVal;
mat=(mat/(maxVal-minVal))*(L-1);
mat=mat+1;


%convert to indecies 
mat=round(mat); 


%Vectorised way of making the image matrix 
im=reshape(cmap(mat(:),:),[size(mat),3]);
end