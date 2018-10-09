function [fig_wavelet_coeff_time] = plot_raster_wavelet_coeff(inspk, cluster_class, dim_coeff, segments, coloring)
%% Initialize:
log_deblock = segments; % in datapoints (sr = 20000 Hz)
srate = 20000;
log_deblock_ms = log_deblock/20; % in ms
c_wavelet = inspk(:,dim_coeff);
times_db = cluster_class(:,2); %in ms
no_cluster = cluster_class(:,1); % # of cluster

%% Reconstruct the real timepoint of the spike-times using log_deblock
times = times_db;
for i = 1:size(log_deblock_ms,1)
        % get start and endpoint for deblocking
        block_start = log_deblock_ms(i,1);
        block_end = log_deblock_ms(i,2);
        length_block = block_end-block_start;
        times = [times(times <= block_start); times(times > block_start) + length_block];
end
% disp(num2str(times_db(end) + sum(log_deblock_ms(:,2)-log_deblock_ms(:,1))));
% disp(num2str(times(end)));

%% Plot coeff_{wavelet}_i as a function of time:
fig_wavelet_coeff_time = figure('Name', 'C_w (t)','units','normalized','outerposition',[0 0 1 1]);
%{
fig_wavelet_coeff_time = figure('Name', 'C_w (t)');%,'units','normalized','outerposition',[0 0 1 1]);
pause(0.00001);
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1);
%}
time_scale = 100000;
times_100_sec = times/time_scale;
hold on 
% plot the rejected spikes with black:
scatter(times_100_sec(no_cluster == 0),c_wavelet(no_cluster == 0),10,[0 0 0],'filled');
xlabel('t', 'FontSize',12,'FontWeight','bold');
ylabel(['coeff #' num2str(dim_coeff)], 'FontSize',12,'FontWeight','bold'); 
%scatter(min(times(no_cluster == 0)),min(c_wavelet(no_cluster == 0)),10,[0 0 0],'filled');
%scatter(max(times(no_cluster == 0)),max(c_wavelet(no_cluster == 0)),10,[0 0 0],'filled');


switch coloring
    % plot the clustered spikes with the same color used in the wave_clus:
    case 'wave_clus'
        clus_colors = [ [0.0 0.0 1.0];
                        [1.0 0.0 0.0];
                        [0.0 0.5 0.0];
                        [0.620690 0.0 0.0];
                        [0.413793 0.0 0.758621];
                        [0.965517 0.517241 0.034483];
                        [0.448276 0.379310 0.241379];
                        [1.0 0.103448 0.724138];
                        [0.545 0.545 0.545];
                        [0.586207 0.827586 0.310345];
                        [0.965517 0.620690 0.862069];
                        [0.620690 0.758621 1.]  ]; 
        set(0,'DefaultAxesColorOrder',clus_colors);

        for i = 1:max(no_cluster)
            cluster_times = times_100_sec(no_cluster == i);
            cluster_c_wavelet = c_wavelet(no_cluster == i);
            scatter(cluster_times,cluster_c_wavelet,10,'filled');
        %     disp(num2str(length(cluster_times)));
        end
        
    % the old colormap (better for overviewing different clusters):
    case 'matlab'
        if max(no_cluster) > 5
             colormap(jet);
        else
            mymap = [0 0 0; % black
                 0 1 1; % cyan
                 1 0 0; % red
                 1 0 1; % magenta
                 0 0 1; % blue
                 0 1 0]; % green
             colormap(mymap);
        end

        scatter(times_100_sec,c_wavelet,10,no_cluster,'filled');
    
     % all clusters with grey ('blinded' scatter plot):
    case 'grey'
        color = [0.3, 0.3, 0.3];
        scatter(times_100_sec,c_wavelet,10,color,'filled');
end

% plot vertical lines between each epoch
yl = ylim;
for i = 1:15
    plot([i,i], yl,'--', 'Color', [0.4 0.4 0.4]);
end

% plot areas of segments to indicate where spike sorting hasn't been performed 
for i = 1:size(log_deblock_ms,1)
    block_start = log_deblock_ms(i,1)/time_scale;
    block_end = log_deblock_ms(i,2)/time_scale;
    length_block = block_end-block_start;
    rectangle('Position',[block_start,yl(1),length_block,(yl(2)-yl(1))],...
        'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8]);
end
