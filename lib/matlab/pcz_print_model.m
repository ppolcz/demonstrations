function [ret] = pcz_print_model(modelname, varargin)
%% pcz_print_model
%  
%  File: pcz_print_model.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. August 13.
%

%%

opts.dirname = 'fig';
opts.density = 120;
opts.quality = 100;
opts.format = 'png';
opts.margins = 10;
opts.simulate = false;
opts = parsepropval(opts, varargin{:});

open_system(modelname)
print('-dpdf', [opts.dirname '/' modelname '.pdf'], ['-s' modelname]);

% pdfcrop --margins 10 fig/Isidori_Example414_PID.pdf
cmd_pdfcrop = [
    'pdfcrop --margins ' num2str(opts.margins) ' ' ...
    opts.dirname '/' modelname '.pdf'
    ];

% convert -trim -density 200 fig/Isidori_Example414_PID-crop.pdf -quality
% 100 fig/Isidori_Example414_PID.png
cmd_convert = [
    'convert -density ' num2str(opts.density) ' ' ... 
    opts.dirname '/' modelname '-crop.pdf ' ...
    '-quality 100 ' ...
    opts.dirname '/' modelname '.' opts.format
    ];

system(cmd_pdfcrop);
system(cmd_convert);

if(opts.simulate)
    evalin('caller', ['sim ' modelname]);
end

end