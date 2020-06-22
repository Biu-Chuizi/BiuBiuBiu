%% Load Dataset
% This example uses a small vehicle data set that contains 295 images. Each
% image contains 1 to 2 labeled instances of a vehicle. A small data set is
% useful for exploring the Faster R-CNN training procedure, but in
% practice, more labeled images are needed to train a robust detector.

% Load vehicle data set
data = load('labelingSession.mat');
polypDataset = char(data.labelingSession.ImageSet.ImageStruct.imageFilename);

%%
% The training data is stored in a table. The first column contains the
% path to the image files. The remaining columns contain the ROI labels for
% vehicles.

% Display first few rows of the data set.
polypDataset(1:4,:)

%%
% Display one of the images from the data set to understand the type of
% images it contains.

% Add fullpath to the local vehicle data folder.
% url='';
% dataDir ='';
% polypDataset.imageFilename = fullfile(url,polypDataset.imageFilename);
% i = 1:4;
% x = strcat(data.labelingSession.ImageSet.ImageStruct.imageFilename,num2str('i'))

% Read one of the images.
% I = imread(polypDataset(2:2,:));
I = imread(polypDataset(2:2,:));

% Insert the ROI labels.
I = insertShape(I, 'Rectangle',cell(data.labelingSession.ImageSet.ImageStruct.objectBoundingBoxes(2:2,:)));

% Resize and display image.
I = imresize(I, 3);
figure
imshow(I)

%%
% Split the data set into a training set for training the detector, and a
% test set for evaluating the detector. Select 60% of the data for
% training. Use the rest for evaluation.

% Split data into a training and test set.
idx = floor(0.6 * height(polypDataset));
trainingData = polypDataset(1:idx,:);
testData = polypDataset(idx:end,:);

%% Create a Convolutional Neural Network (CNN)
% A CNN is the basis of the Faster R-CNN object detector. Create the CNN
% layer by layer using Neural Network Toolbox(TM) functionality.
%
% Start with the |imageInputLayer| function, which defines the type and
% size of the input layer. For classification tasks, the input size is
% typically the size of the training images. For detection tasks, the CNN
% needs to analyze smaller sections of the image, so the input size must be
% similar in size to the smallest object in the data set. In this data set
% all the objects are larger than [16 16], so select an input size of [32
% 32]. This input size is a balance between processing time and the amount
% of spatial detail the CNN needs to resolve.

% Create image input layer.
inputLayer = imageInputLayer([32 32 3]);

%%
% Next, define the middle layers of the network. The middle layers are made
% up of repeated blocks of convolutional, ReLU (rectified linear units),
% and pooling layers. These layers form the core building blocks of
% convolutional neural networks.

% Define the convolutional layer parameters.
filterSize = [3 3];
numFilters = 32;

% Create the middle layers.
middleLayers = [
                
    convolution2dLayer(filterSize, numFilters, 'Padding', 1)   
    reluLayer()
    convolution2dLayer(filterSize, numFilters, 'Padding', 1)  
    reluLayer() 
    maxPooling2dLayer(3, 'Stride',2)    
    
    ];
%%
% You can create a deeper network by repeating these basic layers. However,
% to avoid downsampling the data prematurely, keep the number of pooling
% layers low. Downsampling early in the network discards image information
% that is useful for learning.
% 
% The final layers of a CNN are typically composed of fully connected
% layers and a softmax loss layer. 

finalLayers = [
    
    % Add a fully connected layer with 64 output neurons. The output size
    % of this layer will be an array with a length of 64.
    fullyConnectedLayer(64)

    % Add a ReLU non-linearity.
    reluLayer()

    % Add the last fully connected layer. At this point, the network must
    % produce outputs that can be used to measure whether the input image
    % belongs to one of the object classes or background. This measurement
    % is made using the subsequent loss layers.
    fullyConnectedLayer(width(polypDataset))

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
    ];

%% Configure Training Options
% |trainFasterRCNNObjectDetector| trains the detector in four steps. The first
% two steps train the region proposal and detection networks used in Faster
% R-CNN. The final two steps combine the networks from the first two steps
% such that a single network is created for detection [1]. Each training
% step can have different convergence rates, so it is beneficial to specify
% independent training options for each step. To specify the network
% training options use |trainingOptions| from Neural Network Toolbox(TM).

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
% Now that the CNN and training options are defined, you can train the
% detector using |trainFasterRCNNObjectDetector|.
%
% During training, image patches are extracted from the training data. The
% |'PositiveOverlapRange'| and |'NegativeOverlapRange'| name-value pairs
% control which image patches are used for training. Positive training
% samples are those that overlap with the ground truth boxes by 0.6 to 1.0,
% as measured by the bounding box intersection over union metric. Negative
% training samples are those that overlap by 0 to 0.3. The best values for
% these parameters should be chosen by testing the trained detector on a
% validation set. To choose the best values for these name-value pairs,
% test the trained detector on a validation set.
%
% For Faster R-CNN training, *the use of a parallel pool of MATLAB workers is
% highly recommended to reduce training time*. |trainFasterRCNNObjectDetector|
% automatically creates and uses a parallel pool based on your <http://www.mathworks.com/help/vision/gs/computer-vision-system-toolbox-preferences.html parallel preference settings>. Ensure that the use of
% the parallel pool is enabled prior to training.
%
% A CUDA-capable NVIDIA(TM) GPU with compute capability 3.0 or higher is
% highly recommended for training.
%
% To save time while running this example, a pretrained network is loaded
% from disk. To train the network yourself, set the |doTrainingAndEval|
% variable shown here to true.

% A trained network is loaded from disk to save time when running the
% example. Set this flag to true to train the network. 
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
I = imread('highway.png');

% Run the detector.
[bboxes, scores] = detect(detector, I);

% Annotate detections in the image.
I = insertObjectAnnotation(I, 'rectangle', bboxes, scores);
figure
imshow(I)

%% Evaluate Detector Using Test Set
% Testing a single image showed promising results. To fully evaluate the
% detector, testing it on a larger set of images is recommended. Computer
% Vision System Toolbox(TM) provides object detector evaluation functions
% to measure common metrics such as average precision
% (|evaluateDetectionPrecision|) and log-average miss rates
% (|evaluateDetectionMissRate|). Here, the average precision metric is
% used. The average precision provides a single number that incorporates
% the ability of the detector to make correct classifications (precision)
% and the ability of the detector to find all relevant objects (recall).
%
% The first step for detector evaluation is to collect the detection
% results by running the detector on the test set. To avoid long evaluation
% time, the results are loaded from disk. Set the |doTrainingAndEval| flag
% from the previous section to true to execute the evaluation locally.

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
figure
plot(recall, precision)
xlabel('Recall')
ylabel('Precision')
grid on
title(sprintf('Average Precision = %.1f', ap))

displayEndOfDemoMessage(mfilename)