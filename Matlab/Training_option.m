options = trainingOptions(solverName)
options = trainingOptions(solverName,Name,Value)

Input Arguments:
soloverName:
    'sgdm'/'rmsprop'/'adam' //Optimizer: https://ww2.mathworks.cn/help/deeplearning/ref/trainingoptions.html#bu59f0q-Momentum

Name-Value Pair Arguments:
    Polts and Display:
        'Plots','training-progress'/'none' //Plot training progress or not
        'Verbose','1(true)'/'0(false)' //Indicator to display training progress information
        'VerboseFrequency',100(positive integer) //Frequency of verbose printing
    Mini-Batch Option:
        'MaxEpochs',20(positive integer) //Maximum number of epochs
        'MiniBatchSize',256(positive integer) //Size of mini-batch
        'Shuffle','every-epoch'/'once' (default)/'never' //Option for data shuffling
    Validation:
        'ValidationData',{XValidation,YValidation} // Data to use for validation during training, image datastore | mini-batch datastore | table | cell array
        'ValidationFrequency',20(positive integer) // Frequency of network validation
        'ValidationPatience',5(positive integer) //Patience of validation stopping
    Solver Options:
        'InitialLearnRate',0.001 //Initial learning rate
        'LearnRateSchedule','piecewise'/'none'(default) //Option for dropping learning rate during training
        'LearnRateDropPeriod',3 //Number of epochs for dropping the learning rate
        'LearnRateDropFactor',0.1(scalar from 0 to 1) //Factor for dropping the learning rate
        'L2Regularization',0.0005(nonnegative scalar) //Factor for L2 regularization
        'Momentum',0.95(scalar from 0 to 1) //Contribution of previous step
        'GradientDecayFactor',0.95(scalar from 0 to 1) //Decay rate of gradient moving average
        'SquaredGradientDecayFactor',0.99(scalar from 0 to 1) // Decay rate of squared gradient moving average
        'Epsilon',1e-6(positive scalar) //Denominator offset
    Gradient Clipping:
        'GradientThreshold',6(positive scalar)/Inf(default) //Gradient threshold
        'GradientThresholdMethod','global-l2norm'/'12norm'(default)/'absolute-value' //Gradient threshold method
    Sequence Options:
        'SequenceLength','shortest'/'longest'(default)/'(positive integer)' //Option to pad, truncate, or split input sequences
        'SequencePaddingValue',-1/(scalar)/0(default) // Value to pad input sequences
    Hardware Options:
        'ExecutionEnvironment','gpu'/'cpu'/'multi-gpu'/'parallel'/'auto'(default) //Hardware resource for training network
        'WorkerLoad',(scalar from 0 to 1)/(positive integer)/(numeric vector)
    Checkpoints:
        'CheckpointPath','C:\Temp\checkpoint' //Path for saving checkpoint networks

// EXAMPLES:
options = trainingOptions('sgdm', ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.2, ...
    'LearnRateDropPeriod',5, ...
    'MaxEpochs',20, ...
    'MiniBatchSize',64, ...
    'Plots','training-progress')
// options =
//   TrainingOptionsSGDM with properties:

//                      Momentum: 0.9000
//              InitialLearnRate: 0.0100
//     LearnRateScheduleSettings: [1x1 struct]
//              L2Regularization: 1.0000e-04
//       GradientThresholdMethod: 'l2norm'
//             GradientThreshold: Inf
//                     MaxEpochs: 20
//                 MiniBatchSize: 64
//                       Verbose: 1
//              VerboseFrequency: 50
//                ValidationData: []
//           ValidationFrequency: 50
//            ValidationPatience: Inf
//                       Shuffle: 'once'
//                CheckpointPath: ''
//          ExecutionEnvironment: 'auto'
//                    WorkerLoad: []
//                     OutputFcn: []
//                         Plots: 'training-progress'
//                SequenceLength: 'longest'
//          SequencePaddingValue: 0

[XTrain,YTrain] = digitTrain4DArrayData;

idx = randperm(size(XTrain,4),1000);
XValidation = XTrain(:,:,:,idx);
XTrain(:,:,:,idx) = [];
YValidation = YTrain(idx);
YTrain(idx) = [];
layers = [
    imageInputLayer([28 28 1])
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'MaxEpochs',8, ...
    'ValidationData',{XValidation,YValidation}, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');

options = trainingOptions('adam', ...
    'InitialLearnRate',3e-4, ...
    'SquaredGradientDecayFactor',0.99, ...
    'MaxEpochs',20, ...
    'MiniBatchSize',64, ...
    'Plots','training-progress')
// reference:https://ww2.mathworks.cn/help/deeplearning/ref/trainingoptions.html
