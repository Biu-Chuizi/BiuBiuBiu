net = googlenet;

analyzeNetwork(net)

digitDatasetPath = 'D:\Polyp\data\20181029\test\20181101groupaugmen';
images           = imageDatastore(digitDatasetPath, 'IncludeSubFolders', true, 'FileExtensions', '.tif', 'LabelSource', 'foldernames')
[trainingImages,validationImages] = splitEachLabel(images,0.9,'randomized')
numTrainImages   = numel(trainingImages.Labels);
idx              = randperm(numTrainImages,16);
figure
for i = 1:16
    subplot(4,4,i)
    I = readimage(trainingImages,idx(i));
    imshow(I)
end

net.Layers(1)
imageSize = net.Layers(1).InputSize;

if isa(net,'SeriesNetwork') 
  lgraph = layerGraph(net.Layers); 
else
  lgraph = layerGraph(net);
end 

[learnableLayer,classLayer] = findLayersToReplace(lgraph);

numClasses = numel(categories(trainingImages.Labels));

if isa(learnableLayer,'nnet.cnn.layer.FullyConnectedLayer')
    newLearnableLayer = fullyConnectedLayer(numClasses, ...
        'Name','new_fc', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
    
elseif isa(learnableLayer,'nnet.cnn.layer.Convolution2DLayer')
    newLearnableLayer = convolution2dLayer(1,numClasses, ...
        'Name','new_conv', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
end

lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer);

newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);

figure('Units','normalized','Position',[0.3 0.3 0.4 0.4]);
plot(lgraph)
ylim([0,10])

layers = lgraph.Layers;
connections = lgraph.Connections;

layers(1:10) = freezeWeights(layers(1:10));
lgraph = createLgraphUsingConnections(layers,connections);

pixelRange = [-30 30];
scaleRange = [0.9 1.1];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandRotation', [-180 180], ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange, ...
    'RandXScale',scaleRange, ...
    'RandYScale',scaleRange);
% augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
%     'DataAugmentation',imageAugmenter);

augtrainingImages = augmentedImageDatastore(imageSize, trainingImages,'DataAugmentation',imageAugmenter);
augvalidationImages = augmentedImageDatastore(imageSize, validationImages,'DataAugmentation',imageAugmenter);
miniBatchSize = 20;
numIterationsPerEpoch = floor(numel(trainingImages.Labels)/miniBatchSize);

options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',50, ...
    'InitialLearnRate',3e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augvalidationImages, ...
    'ValidationFrequency',numIterationsPerEpoch , ...
    'Verbose',false, ...
    'Plots','training-progress');

netTransfer = trainNetwork(augtrainingImages,lgraph,options);