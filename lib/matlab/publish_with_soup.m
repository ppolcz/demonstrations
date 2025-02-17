function [ret] = publish_with_soup
%% Script publish_with_soup
%  
%  file:   publish_with_soup.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.08.05. Saturday, 01:28:25
%  Major review on 2020. October 09. (2020b)
%
%%

global PUB_RUN_ID

% Get active editor
active = matlab.desktop.editor.getActive;
script_path_repo = active.Filename;

if isempty(PUB_RUN_ID)
    % Workspace wase cleared, new session is started.
    PUB_RUN_ID = pcz_runID(script_path_repo);
end

setenv('RUN_ID', num2str(PUB_RUN_ID))
logger = LoggerP(script_path_repo);

% TMP_vcUXzzrUtfOumvfgWXDd = pcz_dispFunctionName;
% pcz_dispFunction2('Run ID = %s', getenv('RUN_ID'));

G = pglobals;

rawhtml_dir = [G.WWW filesep G.WWW_FILES filesep logger.logname];
script_path_WWW = [rawhtml_dir logger.basename '.m'];
php_file = [G.WWW filesep G.WWW_HTMLS filesep logger.logname '.php'];


% Publish options
opt.format = 'html';
opt.outputDir = rawhtml_dir;
opt.stylesheet = G.STYLESHEET;

% mkdir(opt.outputDir);

% Publis + tidy html code
warning off
rawhtml_file = publish(script_path_repo, opt); 
warning on

% Backup script to publish directory
copyfile(script_path_repo, script_path_WWW);

%system([ 'tidy -im ' pub_output])
fprintf('\ngenerated output: \n%s\n\n', rawhtml_file)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% BEGIN
%
% - abs. path of sanitizer: 
% - abs. path of 
% 
% Call sanitizer script

command = [ 
    G.SANITIZER ' ' ...
    rawhtml_file ' ' ...
    php_file ' ' ...
    script_path_WWW ' ' ...
    logger.dir
    ];

system(command)

fid = fopen(logger.fullpath);
tline = fgets(fid);
tline = fgets(fid);

% str = '<title>My Title</title><p class="lead">Here is some text.</p>';
% tline = '<html><p class="lead">Coordinate transformation, feedback linearization and zero dynamics.</p></html>'
[tokens,~] = regexp(tline,'<html><(\w+).*>(.*)</\1></html>','tokens','match');

if numel(tokens) > 0
    tokens = tokens{1};
end

dispname = logger.basename;
if numel(tokens) > 1 && strcmp(tokens{1}, 'p') && ~isempty(tokens{2})
    dispname = tokens{2};
end

% Copy html code to clipboard
logger.pub_html = sprintf('<a class="" href="<?php echo base_url(''index.php/main/script/%s.php'') ?>">%s</a>', ...
    logger.logname, dispname);
clipboard('copy', logger.pub_html);

% Update persist object of the base workspace
logger.pub_output = rawhtml_file;

if (G.PUB_SUBL)
    subl(php_file)
end

if (G.PUB_WEBVIEW)
   web(sprintf('http://localhost/index.php/main/view/%s.php', logger.logname)) 
end

if (G.PUB_EDIT)
    edit(php_file)
end

%%% END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



end