augmenter = imageDataAugmenter('FillValue',128,...
    'RandXReflection',true,...
    'RandYReflection',true,...
    'RandXReflection',true,...
    'RandYReflection',true,...
    'RandRotation',[-90 90],...
    'RandScale',[1 1],...
    'RandXScale',[1 1],...
    'RandYScale',[1 1],...
    'RandXShear',[0 0],...
    'RandYShear',[0 0],...
    'RandXTranslation',[-10 10],...
    'RandYTranslation',[-10 10]);
    
 
//reference: https://ww2.mathworks.cn/help/deeplearning/ref/imagedataaugmenter.html
