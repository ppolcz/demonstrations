function [ret] = ptikz(varargin)
%%
%
%  file:   ptikz.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2016.04.02. Saturday, 13:05:38
%
%     externalData: 1
%       standalone: 1
%         filename: '/home/ppolcz/Dropbox/PhD/Dokumentaciok/_fig/fig_18/fig.tex'

FIG_ROOT = '/home/ppolcz/Dropbox/Peti/PhD/Dokumentaciok/_fig';

figdir = @(i) [FIG_ROOT '/fig_' num2str(i)];

i = 1;
while exist(figdir(i),'file'), i = i+1; end;

ip.externalData = true;
ip.standalone = true;
ip.filename = [figdir(i) '/fig.tex'];

if mod(nargin,2) == 1
    varargin = [ {'filename'} varargin ];
end

ip = parsepropval(ip, varargin{:});
ip.externalData = parse_bool(ip.externalData);
ip.standalone = parse_bool(ip.standalone);

disp(ip)

% IGY IS LEHETNE, MELLESLEG
% ip = inputParser;
% ip.KeepUnmatched = true;
% ip.addParamValue('externalData', true, @islogical);
% ip.addParamValue('standalone', true,  @islogical);
% ip.addParamValue('filename', '', @validate_linestyle);
% parse(ip, varargin{:})


[pathstr,~,~] = fileparts(ip.filename);
if ~exist(pathstr, 'dir'), mkdir(pathstr); end

set(gcf,'Units','pixels');
matlab2tikz(ip.filename, 'externalData', ip.externalData, 'standalone', ip.standalone);

subl(ip.filename)


function bool = parse_bool(bool_string)
if ischar(bool_string)
    if strcmp(bool_string, 'true')
        bool = true;
    elseif strcmp(bool_string, 'false')
        bool = false;
    end
else
    bool = bool_string;
end

