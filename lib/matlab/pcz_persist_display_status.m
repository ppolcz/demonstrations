function [ret] = pcz_persist_display_status(persist,msg)
%% Script pcz_persist_display_status
%
%  file:   pcz_persist_display_status.m
%  author: Peter Polcz <ppolcz@gmail.com>
%
%  Created on 2017.08.25. Friday, 12:21:36
%
%%

if isfield(persist, 'file')
    pcz_dispFunction('Persistence for `%s` %s [run ID: %d, %s]', ...
        persist.file.bname, msg, persist.runID, persist.fdate);
else
    pcz_dispFunction('Persistence - empty %s [run ID: %d, %s]', ...
        msg, persist.runID, persist.fdate);
end

end