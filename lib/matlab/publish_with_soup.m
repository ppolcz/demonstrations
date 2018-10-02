function [ret] = publish_with_soup
%% Script publish_with_soup
%  
%  file:   publish_with_soup.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.08.05. Saturday, 01:28:25
%
%%

G = pglobals;


% Get active editor
active = matlab.desktop.editor.getActive;
f = pcz_resolvePath(active.Filename);

% Load persistent object from the base workspace
try c = evalin('base','persist'); catch; c = []; end
persist = pcz_persist(f.path, c);

% Publish options
opt.format = 'html';
opt.outputDir = persist.pub_absdir;
opt.stylesheet = [G.ROOT '/publish.xsl' ];

% mkdir(opt.outputDir);

% Publis + tidy html code
warning off
pub_output = publish(f.path, opt); 
warning on

% Backup script to publish directory
copyfile(persist.file.path, persist.pub_backup_script_path)

%system([ 'tidy -im ' pub_output])
fprintf('\ngenerated output: \n%s\n\n', pub_output)

php = [G.VIEW_SCRIPTS '/' persist.pub_dirname '.php'];
command = [ 
    G.SANITIZER ' ' ...
    persist.pub_absdir '/' f.bname '.html ' ...
    php ' ' ...
    persist.pub_backup_script_relpath ' ' ...
    f.dir
    ];
system(command)

fid = fopen(f.path);
tline = fgets(fid);
tline = fgets(fid);

% str = '<title>My Title</title><p class="lead">Here is some text.</p>';
% tline = '<html><p class="lead">Coordinate transformation, feedback linearization and zero dynamics.</p></html>'
[tokens,~] = regexp(tline,'<html><(\w+).*>(.*)</\1></html>','tokens','match');

if numel(tokens) > 0
    tokens = tokens{1};
end

dispname = f.bname;
if numel(tokens) > 1 && strcmp(tokens{1}, 'p') && ~isempty(tokens{2})
    dispname = tokens{2};
end

% Copy html code to clipboard
persist.pub_html = sprintf('<a class="" href="<?php echo base_url(''index.php/main/script/%s.php'') ?>">%s</a>', ...
    persist.pub_dirname, dispname);
clipboard('copy', persist.pub_html);

% Update persist object of the base workspace
persist.pub_output = pub_output;
assignin('base', 'persist', persist)

if (G.PUB_SUBL)
    subl(php)
end

if (G.PUB_WEBVIEW)
   web(sprintf('http://localhost/index.php/main/view/%s.php', persist.pub_dirname)) 
end

if (G.PUB_EDIT)
    edit(php)
end


% open(pub_output)


end