% open log file for deblocking for the time points of deblocking in a
% format:   t1_start    t1_end
%           t2_start    t2_end
%           ...
load('log_deblock.mat');
log_deblock = segments;

% sampling frequency is:
sr = 20000;

% list files to be deblocked:
list = dir;
% load each file and deblock it, then save it
for j = 1:24
    filename_in = list(j+2).name;
    filename_out = [filename_in(1:end-4) '_db.mat'];
    load(filename_in, 'data');
    % deblock file
    t_dp = 1:length(data);
    % t_sec = t_dp/sr;

    for i = size(log_deblock,1):-1:1
        % get start and endpoint for deblocking
        block_start = log_deblock(i,1);
        block_end = log_deblock(i,2);
        length_block = block_end-block_start;
        % disp(num2str(length_block));
        % deblock data
        length_data = length(data);
        data = [data(t_dp <= block_start);data(t_dp > block_end)];
        t_dp = t_dp(1:end-length_block);
        % disp(num2str(length_data - length(data)));
        % data(t_dp > block_start & t_dp < block_end) = 0;
    end
    save(filename_out,'data');
end


% check the results
%{
figure(1)
plot(t_sec(580<t_sec & t_sec<610), data(580<t_sec & t_sec<610));
ylim([min(data)*2,max(data)*2]);

figure(2)
plot(t_sec(1180<t_sec & t_sec<1320), data(1180<t_sec & t_sec<1320));
ylim([min(data)*2,max(data)*2]);
%}

