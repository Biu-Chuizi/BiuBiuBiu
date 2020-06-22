%% Initialization
% close all;clear;clc;
tic
% 
% cudaFilename = 'pctdemo_processMandelbrotElement.cu';
% ptxFilename = ['pctdemo_processMandelbrotElement.',parallel.gpu.ptxext];
% kernel = parallel.gpu.CUDAKernel( ptxFilename, cudaFilename );

url = 'C:\Users\lab\Desktop\';

outputFolder = fullfile(url, '20190623');

% polypsImageSet = imageDatastore(fullfile(outputFolder),'LabelSource','foldernames');
% numel(polypsImageSet.Files)
%% Load Image Sets
%Note that for the bag of features approach to be effective, majority of each image's area must be occupied by the subject of the category
rootFolder = fullfile(outputFolder);
categories = { 'polyp','normal',};% 'MSMs'
imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource', 'foldernames');
tbl = countEachLabel(imds)
%% Prepare Training and Validation Image Sets
minSetCount = min(tbl{:,2}); % determine the smallest amount of images in a category

imds = splitEachLabel(imds, minSetCount, 'randomize');% Use splitEachLabel method to trim the set.

countEachLabel(imds)% Notice that each set now has exactly the same number of images.

% indices = crossvalind('Kfold',imds.Files,k);
[imds1, imds2, imds3, imds4, imds5, imds6, imds7, imds8, imds9, imds10] = splitEachLabel(imds, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 'randomize');
% indices = crossvalind('Kfold',species,10,'Classes',labels);
%     test = (indices == i); 
%     train = ~test;
validationSet = imds10;
trainingSet = imageDatastore(cat(1, imds1.Files, imds2.Files, imds3.Files, imds4.Files, imds5.Files, imds6.Files, imds7.Files, imds8.Files, imds9.Files));
trainingSet.Labels = cat(1, imds1.Labels, imds2.Labels, imds3.Labels, imds4.Labels, imds5.Labels, imds6.Labels, imds7.Labels, imds8.Labels, imds9.Labels);
%     [trainingSet, validationSet] = splitEachLabel(imds, 0.9, 'randomize');%Separate the sets into training and validation data.

% Find the first instance of an image for each category
NO = find(trainingSet.Labels == 'normal', 1);
YES = find(trainingSet.Labels == 'polyp', 1);
% MSMs = find(trainingSet.Labels == 'MSMs', 1);
% 
%     figure
% 
%     subplot(1,3,1);
%     imshow(readimage(trainingSet,NO))
%     subplot(1,3,2);
%     imshow(readimage(trainingSet,YES))
% subplot(1,3,3);
% imshow(readimage(trainingSet,MSMs))
%% Create a Visual Vocabulary and Train an Image Category Classifier
bag = bagOfFeatures(trainingSet);
%   bag = bagOfFeatures(imds) returns a bag of visual features. imds is
%   an ImageDatastore object. By default, SURF features are used to
%   generate the vocabulary features. Vocabulary is quantized using K-means
%   algorithm.
%
%   bag = bagOfFeatures(imds,'CustomExtractor',extractorFcn) returns a
%   bag of features that uses a custom feature extractor function to
%   generate the vocabulary features. extractorFcn is a function handle to
%   a custom feature extraction function.
%   'VocabularySize'    Integer scalar, VocabularySize >=2. Specifies 
%                       number of visual words to hold in the bag. It
%                       corresponds to K in K-means algorithm used to
%                       quantize the visual vocabulary.
%
%                       Default: 500
%
%   'StrongestFeatures' Fraction of strongest features to use from each 
%                       label contained in imds input.
%
%                       Default: 0.8
%
%   'Verbose'           Set true to display progress information.
%
%                       Default: true
%

img = readimage(imds, 1);

featureVector = encode(bag, img);


% Plot the histogram of visual word occurrences
% figure
% bar(featureVector)
% title('Visual word occurrences')
% xlabel('Visual word index')
% ylabel('Frequency of occurrence')

categoryClassifier = trainImageCategoryClassifier(trainingSet, bag);
%   classifier = trainImageCategoryClassifier(imds, bag) creates an image
%   category classifier. imds must be an ImageDatastore object and bag is
%   a bagOfFeatures object. A linear SVM classifier using error correcting
%   output codes (ECOC) is then trained to classify amongst each of the
%   image categories.
%   [...] = trainImageCategoryClassifier(..., Name, Value) specifies
%   additional name-value pairs described below:
%
%   'Verbose'        Set to true to display training progress information. 
%
%                    Default: true
%
%   'LearnerOptions' A learner template constructed by calling templateSVM
%                    function in the Statistics and Machine Learning Toolbox.
%                    This lets you change characteristics of the SVM classifier.
%                    See help for templateSVM function for more details.
%                    For example, to adjust the regularization parameter 
%                    and to set a custom kernel function, use 
%                    the following syntax:
%
%                    opts = templateSVM('BoxConstraint', 1.1, ...
%                                       'KernelFunction', 'gaussian');
%                    classifier = trainImageCategoryClassifier(imgSets,...
%                                       bag, 'LearnerOptions', opts);
%
%                    Default: defaults used by templateSVM function

%% Evaluate Classifier Performance
confMatrix_train = evaluate(categoryClassifier, trainingSet);
confMatrix_test = evaluate(categoryClassifier, validationSet);

% Compute average accuracy
% mean(diag(confMatrix_test));

%% Try the Newly Trained Classifier on Test Images
% test = 'E:\BiuBiuBiu\data\data_LST-4\';
% testFolder = fullfile(test,'ROI_polyp')
% img = imread(fullfile(testFolder,'2017-05-19-21-19-53_8.tiff'));%(rootFolder, 'HP', '7154.tiff'));
img = imread('C:\Users\lab\Desktop\1\2019-06-23-02-22-44_137.jpg');
[labelIdx, scores] = predict(categoryClassifier, img);
% 
% % Display the string label
categoryClassifier.Labels(labelIdx)

%% Time
% t1=toc