%% Setup
% vgg16()
% pretrainedURL = 'https://www.mathworks.com/supportfiles/vision/data/segnetVGG16CamVid.mat';
% pretrainedFolder = fullfile(tempdir,'pretrainedSegNet');
% pretrainedSegNet = fullfile(pretrainedFolder,'segnetVGG16CamVid.mat'); 
% %% Download CamVid Dataset
% if ~exist(pretrainedFolder,'dir')
%     mkdir(pretrainedFolder);
%     disp('Downloading pretrained SegNet (107 MB)...');
%     websave(pretrainedSegNet,pretrainedURL);
% end
% imageURL = 'http://web4.cs.ucl.ac.uk/staff/g.brostow/MotionSegRecData/files/701_StillsRaw_full.zip';
% labelURL = 'http://web4.cs.ucl.ac.uk/staff/g.brostow/MotionSegRecData/data/LabeledApproved_full.zip';
% 
% outputFolder = fullfile(tempdir,'CamVid');
% 
% if ~exist(outputFolder, 'dir')
%    
%     mkdir(outputFolder)
%     labelsZip = fullfile(outputFolder,'labels.zip');
%     imagesZip = fullfile(outputFolder,'images.zip');   
%     
%     disp('Downloading 16 MB CamVid dataset labels...'); 
%     websave(labelsZip, labelURL);
%     unzip(labelsZip, fullfile(outputFolder,'labels'));
%     
%     disp('Downloading 557 MB CamVid dataset images...');  
%     websave(imagesZip, imageURL);       
%     unzip(imagesZip, fullfile(outputFolder,'images'));    
% end
%% Load CamVid Images
data_download = 'C:\Users\guozh\AppData\Local\Temp\CamVid'
% imgDir = fullfile(data_download,'images','701_StillsRaw_full');
imgDir = fullfile(data_download,'images','a');
imds = imageDatastore(imgDir);
I = readimage(imds,1);
I = histeq(I);
imshow(I)
%% Load CamVid Pixel-Labeled Images
% classes = [
%     "Sky"
%     "Building"
%     "Pole"
%     "Road"
%     "Pavement"
%     "Tree"
%     "SignSymbol"
%     "Fence"
%     "Car"
%     "Pedestrian"
%     "Bicyclist"
%     ];
classes = [
    "polyp"
    "normal"
    ];
labelIDs = camvidPixelLabelIDs();
% labelDir = fullfile(data_download,'labels');
labelDir = fullfile(data_download,'labelss');
pxds = pixelLabelDatastore(labelDir,classes,labelIDs);
C = readimage(pxds,1);

cmap = camvidColorMap;

B = labeloverlay(I,C,'ColorMap',cmap);
imshow(B)
pixelLabelColorbar(cmap,classes);
%% Analyze Dataset Statistics
tbl = countEachLabel(pxds)
frequency = tbl.PixelCount/sum(tbl.PixelCount);

bar(1:numel(classes),frequency)
xticks(1:numel(classes)) 
xticklabels(tbl.Name)
xtickangle(45)
ylabel('Frequency')
%% Resize CamVid Data
% imageFolder = fullfile(data_download,'imagesResized',filesep);
imageFolder = fullfile(data_download,'imagessResized',filesep);
imds = resizeCamVidImages(imds,imageFolder);

% labelFolder = fullfile(data_download,'labelsResized',filesep);
labelFolder = fullfile(data_download,'labelssResized',filesep);
pxds = resizeCamVidPixelLabels(pxds,labelFolder);
%% Prepare Training and Test Sets
[imdsTrain,imdsTest,pxdsTrain,pxdsTest] = partitionCamVidData(imds,pxds);
numTrainingImages = numel(imdsTrain.Files)
numTestingImages = numel(imdsTest.Files)
%% Create the Network
imageSize = [360 480 3];
numClasses = numel(classes);
lgraph = segnetLayers(imageSize,numClasses,'vgg16');
%% Balance Classes Using Class Weighting
% imageFreq = tbl.PixelCount ./ tbl.ImagePixelCount;
% classWeights = median(imageFreq) ./ imageFreq
classWeights = [0.85; 0.9];
pxLayer = pixelClassificationLayer('Name','labels','Classes',tbl.Name,'ClassWeights',classWeights)
lgraph = removeLayers(lgraph,'pixelLabels');
lgraph = addLayers(lgraph, pxLayer);
lgraph = connectLayers(lgraph,'softmax','labels');
%% Select Training Options
options = trainingOptions('sgdm', ...
    'Momentum',0.9, ...
    'InitialLearnRate',1e-3, ...
    'L2Regularization',0.0005, ...
    'MaxEpochs',100, ...  
    'MiniBatchSize',4, ...
    'Shuffle','every-epoch', ...
    'CheckpointPath', tempdir, ...
    'VerboseFrequency',2);
%% Data Augmentation
augmenter = imageDataAugmenter('RandXReflection',true,...
    'RandXTranslation',[-10 10],'RandYTranslation',[-10 10]);
%% Start Training
pximds = pixelLabelImageDatastore(imdsTrain,pxdsTrain, ...
    'DataAugmentation',augmenter);
% doTraining = false;
doTraining = true;
if doTraining    
    [net, info] = trainNetwork(pximds,lgraph,options);
else
%     data = load(pretrainedSegNet);
    a = "C:\Users\guozh\AppData\Local\Temp\pretrainedSegNet\segnetVGG16CamVid.mat"
    data = load(a)
    net = data.net;
end
%% Test Network on One Image
I = read(imdsTest);
C = semanticseg(I, net);
B = labeloverlay(I,C,'Colormap',cmap,'Transparency',0.4);
imshow(B)
pixelLabelColorbar(cmap, classes);
B = labeloverlay(I,C,'Colormap',cmap,'Transparency',0.4);
imshow(B)
pixelLabelColorbar(cmap, classes);
expectedResult = read(pxdsTest);
actual = uint8(C);
expected = uint8(expectedResult);
imshowpair(actual, expected)
iou = jaccard(C,expectedResult);
table(classes,iou)
%% Evaluate Trained Network
pxdsResults = semanticseg(imdsTest,net, ...
    'MiniBatchSize',4, ...
    'WriteLocation',tempdir, ...
    'Verbose',false);
metrics = evaluateSemanticSegmentation(pxdsResults,pxdsTest,'Verbose',false);
metrics.DataSetMetrics
metrics.ClassMetrics
