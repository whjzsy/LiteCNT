function [result, fps, trkMemory, nreset] = tracker_OPE(cfg, opts) 
    % fix rand seed for OTB dataset to reproduce our results
    tprocess.time.all = 0;
    tprocess.time.det = 0;
    tprocess.time.dup = 0;
    
    state = opts.state_initialize(read_img(cfg.img_files{1}), cfg.ground_truth(1, :), opts);
    
    state = opts.state_warmup(state);
    
    for f = 1:numel(cfg.img_files)
        img = read_img(cfg.img_files{f});
        
        time_all = tic;
        
        if opts.gparams.useGpu
            img = gpuArray(single(img));
        else
            img = single(img);
        end
        
        if f == 1
            % do nothing
            state = opts.initialize(state, img);
        else
            time_det = tic;
            state = opts.track(state, img);
            tprocess.time.det = tprocess.time.det + toc(time_det);
            
            time_dup = tic;
            state = opts.update(state, img);
            tprocess.time.dup = tprocess.time.dup + toc(time_dup);  
        end
                
        time_tmp = toc(time_all);
        tprocess.time.all = tprocess.time.all + time_tmp;
        
        if state.gparams.verbose
            if state.currFrame == 1
                 videoPlayer = vision.VideoPlayer('Position', [100 100 [size(img, 2), size(img, 1)]+30]);
            end
            
            img = gather(single(img))/255;
            img = insertShape(img, 'Rectangle', state.result(f, :), 'LineWidth', 4, 'Color', 'green');
            img = insertText(img, [10 10], ['FPS: ' num2str(1/time_tmp)], 'TextColor', 'y', ...
                'FontSize', 20, 'BoxColor', 'black', 'BoxOpacity', 0.8);
            % Display the annotated video frame using the video player object.
            step(videoPlayer, img);
        end
    end
    
    state = opts.release(state);
    
    nreset = 0;
    result = state.result;
    trkMemory.modelSize = state.paramSize;
    
    fps.all = (numel(cfg.img_files)) / tprocess.time.all;
    fps.det = (numel(cfg.img_files)) / tprocess.time.det;
    fps.dup = (numel(cfg.img_files)) / tprocess.time.dup;
end