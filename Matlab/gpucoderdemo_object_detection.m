% https://ww2.mathworks.cn/help/gpucoder/examples/object-detection.html
coder.checkGpuInstall('gpu','codegen','cudnn','quiet');
gpucoderdemo_setup('gpucoderdemo_object_detection');
net = getYolo();
disp(net.Layers);
cnncodegen(net);
dir('codegen')
