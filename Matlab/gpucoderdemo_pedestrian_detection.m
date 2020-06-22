% https://ww2.mathworks.cn/help/gpucoder/examples/pedestrian-detection.html
gpucoderdemo_setup('gpucoderdemo_pedestrian_detection');
coder.checkGpuInstall('gpu','codegen','cudnn','quiet');
load('PedNet.mat');
disp(PedNet.Layers);