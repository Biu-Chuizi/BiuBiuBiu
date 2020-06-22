% https://ww2.mathworks.cn/help/vision/examples/object-detection-using-faster-r-cnn-deep-learning.html
%% Load Dataset
% Load vehicle data set
data = load('20170824.mat');
vehicleDataset =data.vehicleTrainingData;

%%
% Display first few rows of the data set.
% vehicleDataset(1:2:10,:)

%%
% Display one of the images from the data set to understand the type of
% images it contains.

% Add fullpath to the local vehicle data folder.
dataDir = ''%%fullfile(toolboxdir('vision'),'visiondata');
vehicleDataset.imageFilename = fullfile(dataDir, vehicleDataset.imageFilename);

% % Read one of the images.
% I = imread(vehicleDataset.imageFilename{10});
% 
% % Insert the ROI labels.
% I = insertShape(I, 'Rectangle', vehicleDataset.vehicle{10});
% 
% % Resize and display image.
% I = imresize(I, 3);
% figure
% imshow(I)

%%
% Split data into a training and test set.
% idx = floor(0.6 * height(vehicleDataset));
trainingData = vehicleDataset(1:15,:);
testData = vehicleDataset(16:17,:);

%% Create a Convolutional Neural Network (CNN)
% Create image input layer.
inputLayer = imageInputLayer([1920 1080 3]);

%%
% Define the convolutional layer parameters.
filterSize = [30 30];
numFilters = 32;

% Create the middle layers.
middleLayers = [
                
    convolution2dLayer(filterSize, numFilters, 'Padding', 1)   
    reluLayer()
    convolution2dLayer(filterSize, numFilters, 'Padding', 1)  
    reluLayer() 
    maxPooling2dLayer(3, 'Stride',2)    
    
    convolution2dLayer(filterSize, numFilters, 'Padding', 1)   
    reluLayer()
    convolution2dLayer(filterSize, numFilters, 'Padding', 1)  
    reluLayer() 
    maxPooling2dLayer(3, 'Stride',2)   
    
    ];
%%
finalLayers = [
    
    % Add a fully connected layer with 64 output neurons. The output size
    % of this layer will be an array with a length of 64.
    fullyConnectedLayer(64)

    % Add a ReLU non-linearity.
    reluLayer()

    fullyConnectedLayer(width(vehicleDataset))

    % Add the softmax loss layer and classification layer. 
    softmaxLayer()
    classificationLayer()
];

%%
% Combine the input, middle, and final layers.
layers = [
    inputLayer
    middleLayers
    finalLayers
    ]

%% Configure Training Options
% Options for step 1.
optionsStage1 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'InitialLearnRate', 1e-5, ...
    'CheckpointPath', tempdir);

% Options for step 2.
optionsStage2 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'InitialLearnRate', 1e-5, ...
    'CheckpointPath', tempdir);

% Options for step 3.
optionsStage3 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'InitialLearnRate', 1e-6, ...
    'CheckpointPath', tempdir);

% Options for step 4.
optionsStage4 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'InitialLearnRate', 1e-6, ...
    'CheckpointPath', tempdir);

options = [
    optionsStage1
    optionsStage2
    optionsStage3
    optionsStage4
    ];

%% Train Faster R-CNN
doTrainingAndEval = true;

if doTrainingAndEval
    % Set random seed to ensure example training reproducibility.
    rng(0);
    
    % Train Faster R-CNN detector. Select a BoxPyramidScale of 1.2 to allow
    % for finer resolution for multiscale object detection.
    detector = trainFasterRCNNObjectDetector(trainingData, layers, options, ...
        'NegativeOverlapRange', [0 0.3], ...
        'PositiveOverlapRange', [0.6 1], ...
        'BoxPyramidScale', 1.2);
else
    % Load pretrained detector for the example.
    detector = data.detector;
end

%% 
% To quickly verify the training, run the detector on a test image.

% Read a test image.
I = imread('56.tiff');

% Run the detector.
[bboxes, scores] = detect(detector, I);

% Annotate detections in the image.
I = insertObjectAnnotation(I, 'rectangle', bboxes, scores);
figure
imshow(I)

%% Evaluate Detector Using Test Set
if doTrainingAndEval
    % Run detector on each image in the test set and collect results.
    resultsStruct = struct([]);
    for i = 1:height(testData)
        
        % Read the image.
        I = imread(testData.imageFilename{i});
        
        % Run the detector.
        [bboxes, scores, labels] = detect(detector, I);
        
        % Collect the results.
        resultsStruct(i).Boxes = bboxes;
        resultsStruct(i).Scores = scores;
        resultsStruct(i).Labels = labels;
    end
    
    % Convert the results into a table.
    results = struct2table(resultsStruct);
else
    % Load results from disk.
    results = data.results;
end

% Extract expected bounding box locations from test data.
expectedResults = testData(:, 2:end);

% Evaluate the object detector using Average Precision metric.
[ap, recall, precision] = evaluateDetectionPrecision(results, expectedResults);

%%
% Plot precision/recall curve
figure
plot(recall, precision)
xlabel('Recall')
ylabel('Precision')
grid on
title(sprintf('Average Precision = %.1f', ap))