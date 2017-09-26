function [ret] = pmlx(mlxfn)
%% Script publish_with_soup_2017b
%  
%  file:   publish_with_soup_2017b.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. September 23.
%
%%

suffix = '_plain.m';

mlxfparts = pcz_resolvePath(mlxfn);
mfn = [ mlxfparts.dir '/' mlxfparts.bname suffix ];
matlab.internal.liveeditor.openAndConvert(mlxfn,mfn);

G = pglobals;

% Load persistent object from the base workspace
try c = evalin('base','persist'); catch; c = []; end
persist = pcz_persist(mfn, c);

% Publish options
opt.format = 'html';
opt.outputDir = persist.pub_absdir;
opt.stylesheet = [G.ROOT '/publish.xsl' ];


% mkdir(opt.outputDir);

edit(mfn);

% Publish
warning off
pub_output = publish(mfn, opt);
warning on

backup_mlx_path = strrep(persist.pub_backup_script_path, suffix, '.mlx');
backup_mlx_relpath = strrep(persist.pub_backup_script_relpath, suffix, '.mlx');

html_path = strrep(persist.pub_backup_script_path, suffix, '.html');
html_relpath = strrep(persist.pub_backup_script_relpath, suffix, '.html');

% Backup script to publish directory
copyfile(mfn, persist.pub_backup_script_path)
copyfile(mlxfn, backup_mlx_path)
matlab.internal.liveeditor.openAndConvert(mlxfn,html_path);

php = [G.VIEW_SCRIPTS '/' persist.pub_dirname '.php'];
command = [ ...
    G.SANITIZER ' ' ...
    pub_output ' ' ...
    php ' ' ...
    persist.pub_backup_script_relpath ' ' ...
    backup_mlx_relpath ' ' ...
    html_relpath ' ' ...
    ];
system(command);

% Copy html code to clipboard
persist.pub_html = sprintf('<a class="" href="<?php echo base_url(''index.php/main/script/%s.php'') ?>">%s</a>', ...
    persist.pub_dirname, mlxfparts.bname);
clipboard('copy', persist.pub_html);

% Update persist object of the base workspace
persist.pub_output = pub_output;
assignin('base', 'persist', persist);

subl(php);
% open(pub_output)

end