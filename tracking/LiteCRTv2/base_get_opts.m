function opts = base_get_opts(varargin)

    gparams.verbose = false;
    gparams.useGpu = true;
    gparams.normTargetSize = 56;
    gparams.inputShape = 'proportional';
    gparams.searchPadding = 4;
    gparams.warmupTimes = 0;
    gparams.useDataAugmentation = true;
    [gparams, varargin] = vl_argparse(gparams, varargin);
    
    % augmentation opts
    aparams = struct();
    aparams(1).type = 'fliplr';
    aparams(1).param = [];
    aparams(2).type = 'rot';
    aparams(2).param = {5, -5, 10, -10, 20, -20, 30, -30, 45, -45, -60, 60};
    aparams(3).type = 'blur';
    aparams(3).param = {[2, 0.2], [0.2, 2], [3, 1], [1, 3], [2, 2]};
    aparams(4).type = 'shift';
    aparams(4).param = {[8, 8], [-8, 8], [8, -8], [-8, -8]};
    aparams(5).type = 'dropout';
    aparams(5).param = {1, 2, 3, 4, 5, 6, 7};
    [aparams, varargin] = vl_argparse(aparams, varargin);
    
    % backbone feature opts
    bparams.netPath = '';
    bparams.isDagNN = false;
    bparams.normalize = true;
    bparams.downsamplingFactor = 2;
    bparams.downsamplingMethod = 'avg';
    bparams.averageImage = single(reshape([122.6769, 116.67, 104.01], 1, 1, 3));
    [bparams, varargin] = vl_argparse(bparams, varargin);
    
    % online head opts
    hparams.headType = 'maskConv';
    hparams.maskSize = 5;
    hparams.alpha = 1;
    hparams.useProjection = true;
    hparams.projectInDims = 96;
    hparams.projectOuDims = 64;
    hparams.initUsePCA = true;
    [hparams, varargin] = vl_argparse(hparams, varargin);
    
    % tracking opts
    tparams.numScales = 5;
    tparams.scaleStep = 1.02;
    tparams.motionSigmaFactor = 0.7;
    tparams.scalePenalty = 0.98;
    tparams.scaleLr = 0.8;
    
    [tparams, varargin] = vl_argparse(tparams, varargin);
    
    % optimization opts
    oparams.outputSigmaFactor = 1/10;
    oparams.initLr = 1e-5;
    oparams.initMaxIters = 400;
    oparams.initMinIters = 100;
    oparams.updateLr = 1e-5;
    oparams.updateMaxIters = 2;
    oparams.numSamples = 5;
    oparams.intervals = 5;
    oparams.FIFO = true;
    oparams.verbose = gparams.verbose ;
    [oparams, varargin] = vl_argparse(oparams, varargin);
    
    % sample remove opts  
    opts.gparams = gparams;
    opts.aparams = aparams;
    opts.bparams = bparams;
    opts.hparams = hparams;
    opts.tparams = tparams;
    opts.oparams = oparams;  
end

