% https://ww2.mathworks.cn/help/gpucoder/examples/pedestrian-detection.html
gpucoderdemo_setup('gpucoderdemo_pedestrian_detection');
coder.checkGpuInstall('gpu','codegen','cudnn','quiet');
load('PedNet.mat');
disp(PedNet.Layers);
type('pedDetect_predict.m')
% Load an input image.
im = imread('test.jpg');
im = imresize(im,[480,640]);

cfg = coder.gpuConfig('mex');
cfg.TargetLang = 'C++';
codegen -config cfg pedDetect_predict -args {im} -report
imshow(im);
imshow(im);
outputImage = insertShape(im,'Rectangle',ped_bboxes,'LineWidth',3);
imshow(outputImage);
clear mex;
cleanup