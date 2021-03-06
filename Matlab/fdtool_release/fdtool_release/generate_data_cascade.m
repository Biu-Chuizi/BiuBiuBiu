function  [Xtrain , Xtest , stat]     = generate_data_cascade(options , Xfa )

%
%  Generate i.i.d positive features from positives examples stacked in a 3D 
%  tensor matrix Xpos and negative samples from negatives picts stores in 
%  negatives folder
%
%  Usage
%  ------
%
%  [Xtrain , Xtest , stat]     = generate_data_cascade(options , Xfa )
%
%  Inputs
%  -------
%
%  options          Options struture (see train_cascade function)
%  Xfa              Previous Falses alarms detection matrix (Ny x Nx x Nfa)
%
%  Outputs
%  -------
%
%  Xtrain           Generated train data (Ny x Nx x (options.Npostrain+options.Nnegtrain))
%  Xtest            Generated test data (Ny x Nx x (options.Npostest+options.Nnegtest))
%  stat             Number of positives and negatives generated for both train and test set
%
%
%
%  Author : Sébastien PARIS : sebastien.paris@lsis.org
%  -------  Date : 03/1/2011
%
%

if(options.resetseed)
    RandStream.setDefaultStream(RandStream.create('mt19937ar','seed',options.seed));
end



Ntotal              = options.Ntotal;
X                   = zeros(options.ny , options.nx , Ntotal , 'uint8');
stat                = zeros(5,1);

%% Generate Npos Positives examples from Xpos without replacement %%

Npostotal           = options.Npos;
indexpos            = randperm(Npostotal);
nb_stage            = length(options.m);

directory           = [];
for i = 1:length(options.negext)
    directory       = [directory ; dir(fullfile(options.positives_path , ['*.' options.posext{i}]))] ;
end
nbpos_photos        = length(directory);
index_posphotos     = randperm(nbpos_photos);

copos               = 1;
co                  = 1;
cophotos            = 1;
h                   = waitbar(0,sprintf('Generating positives, n^o stage = %d' , nb_stage));
set(h , 'name' , sprintf('Generating positives, n^o stage = %d' , nb_stage))

if(options.preview)
    fig = figure(1);
    set(fig,'doublebuffer','on');
    colormap(gray)
end


while((copos <= options.Npos) && (co <= Npostotal) )
    if(~isempty(options.param))
        if(cophotos < nbpos_photos)
            cophotos               = cophotos + 1;
        else
            cophotos               = 1;
            index_posphotos        = randperm(nbpos_photos);
        end
        Ipos                       = imread(fullfile(options.positives_path , directory(index_posphotos(cophotos)).name));
        [Ny , Nx , Nz]             = size(Ipos);
        if(Nz == 3)
            Ipos                   = rgb2gray(Ipos);
        end
        %% Resize to training %%
        Ipos                       = imresize(Ipos , options.dimsItraining);
        
        %% Standardize image %%
        if(options.standardize)
            dIpos                      = double(Ipos);
            stdIpos                    = std(dIpos(:));
            if(stdIpos~=0)
                dIpos                  = dIpos/stdIpos;
            end
            minIpos                    = min(dIpos(:));
            maxIpos                    = max(dIpos(:));
            tempX                      = uint8(floor(255*(dIpos-minIpos)/(maxIpos-minIpos)));
        end
        
        
        %% Rotation %%
        if(rand < options.probarotIpos)
            tempX                      = fast_rotate(tempX , options.m_angle + options.std_angle*randn(1,1));
        end
        
        %% preview image %%

        if(options.typefeat == 0)
            [fxtempX , ytempX]   = eval_haar(tempX , options);
            if(ytempX == 1)
                X(: , : , copos) = tempX;
                copos            = copos + 1;
                if(options.preview)
                    imagesc(tempX);
                    drawnow
                end
            end
        else
            [fxtempX , ytempX]   = eval_mblbp(tempX , options);
            if(ytempX == 1)
                X(: , : , copos) = tempX;
                copos            = copos + 1;
                if(options.preview)
                    imagesc(tempX);
                    drawnow
                end  
            end
        end
    else
        if(cophotos < nbpos_photos)
            cophotos               = cophotos + 1;
        else
            cophotos               = 1;
            index_posphotos        = randperm(nbpos_photos);
        end
        Ipos                       = imread(fullfile(options.positives_path , directory(index_posphotos(cophotos)).name));
        [Ny , Nx , Nz]             = size(Ipos);
        if(Nz == 3)
            Ipos                   = rgb2gray(Ipos);
        end
        %% Resize to training %%
        Ipos = imresize(Ipos , options.dimsItraining);

        %% Standardize image %%
        if(options.standardize)
            dIpos                      = double(Ipos);
            stdIpos                    = std(dIpos(:));
            if(stdIpos~=0)
                dIpos                  = dIpos/stdIpos;
            end
            minIpos                    = min(dIpos(:));
            maxIpos                    = max(dIpos(:));
            tempX                      = uint8(floor(255*(dIpos-minIpos)/(maxIpos-minIpos)));
        end
        
        %% Rotation image %%
        if(rand < options.probarotIpos)
            tempX                  = fast_rotate(tempX , options.m_angle + options.std_angle*randn(1,1));
        end
        
        %% preview image %%
         if(options.preview)
            imagesc(tempX);
            drawnow
        end
           
        X(: , : , copos)           = tempX;
        copos                      = copos + 1;
    end
    
    co                        = co + 1;
    waitbar(copos/options.Npos , h , sprintf('#pos/#generated = %d/%d, P_d = %5.4f' , copos - 1 , co - 1 , (copos - 1)/(co - 1)));
    
end
close(h)

stat(1)                                          = copos - 1;
stat(2)                                          = co - 1;


%% Generate Nneg Negatives examples from Negatives images with replacement %%

if(options.usefa == 1)
    prenegnum                                    = size(Xfa,3);
    X(:,:,options.Npos+1:prenegnum+options.Npos) = Xfa;
    coneg                                        = prenegnum+options.Npos+1;
else
    prenegnum                                    = 0;
    coneg                                        = options.Npos+1;
end


cophotos               = 1;
directory              = [];
for i = 1:length(options.negext)
    directory          = [directory ; dir(fullfile(options.negatives_path , ['*.' options.negext{i}]))] ;
end
nbneg_photos           = length(directory);
index_negphotos        = randperm(nbneg_photos);
Ineg                   = imread(fullfile(options.negatives_path , directory(index_negphotos(cophotos)).name));
[Ny , Nx , Nz]         = size(Ineg);
if(Nz == 3)
    Ineg               = rgb2gray(Ineg);
end
maxNyNx                = max([Ny Nx]);
if(maxNyNx > options.negmax_size)
    ratio              = options.negmax_size/maxNyNx;
    Ny                 = ceil(ratio*Ny);
    Nx                 = ceil(ratio*Nx);
    Ineg               = imresize(Ineg , [Ny Nx]);
end

if(min(Ny,Nx) < options.scalemax*max(options.ny,options.nx))
    scalemax           = min(Ny,Nx)/max(options.ny,options.nx);
else
    scalemax           = options.scalemax;
end

if(options.preview)
    imagesc(Ineg);
end



h                     = waitbar(0,sprintf('Generating negatives, n^o stage = %d' , nb_stage));
set(h , 'name' , sprintf('Generating negatives, n^o stage = %d' , nb_stage))
co                    = 1;
while(coneg <= Ntotal)
    if(~isempty(options.param))
        if(rand < options.probaswitchIneg)
            if(cophotos < nbneg_photos)
                cophotos               = cophotos + 1;
            else
                cophotos               = 1;
                index_negphotos        = randperm(nbneg_photos);
            end
            Ineg                       = imread(fullfile(options.negatives_path , directory(index_negphotos(cophotos)).name));
            [Ny , Nx , Nz]             = size(Ineg);
            if(Nz == 3)
                Ineg                   = rgb2gray(Ineg);
            end
            if(min(Ny,Nx) < options.scalemax*max(options.ny,options.nx))
                scalemax               = min(Ny,Nx)/max(options.ny,options.nx);
            end
        end
        
        %% Scaling Negatives %%
        scale                          = options.scalemin + (scalemax-options.scalemin)*rand;
        nys                            = round(options.ny*scale);
        nxs                            = round(options.nx*scale);  
        y                              = ceil(1 + (Ny - nys - 1)*rand);
        x                              = ceil(1 + (Nx - nxs - 1)*rand);    
        tempX                          = imresize(Ineg(y:y+nys-1 , x:x+nxs-1) , [options.ny , options.nx]);
      
        %% standardize Negatives %%
        
        if(options.standardize)
            dIneg                      = double(tempX);
            stdIneg                    = std(dIneg(:));
            if(stdIneg~=0)
                dIneg                  = dIneg/stdIneg;
            end
            minIneg                    = min(dIneg(:));
            maxIneg                    = max(dIneg(:));
            tempX                      = uint8(floor(255*(dIneg-minIneg)/(maxIneg-minIneg)));
        end
               
        if(options.typefeat == 0)
            [fxtempX , ytempX]                      = eval_haar(tempX , options);
            if(std(double(tempX(:)),1)~= 0)
                if(ytempX == 1)
                    X(: , : , coneg )               = tempX;
                    coneg                           = coneg + 1;
                    if(options.preview)
                        imagesc(tempX);
                        drawnow
                    end       
                end
                co                                  = co + 1;
            end
        else
            [fxtempX , ytempX]                      = eval_mblbp(tempX , options);
            if(std(double(tempX(:)),1)~= 0)
                if(ytempX == 1)
                    X(: , : , coneg )               = tempX;
                    coneg                           = coneg + 1;
                    if(options.preview)
                        imagesc(tempX);
                        drawnow
                    end    
                end
                co                                  = co + 1;
            end
        end
    else
        if(rand < options.probaswitchIneg)
            if(cophotos < nbneg_photos)
                cophotos               = cophotos + 1;
            else
                cophotos               = 1;
                index_negphotos        = randperm(nbneg_photos);
            end
            
            Ineg                       = imread(fullfile(options.negatives_path , directory(index_negphotos(cophotos)).name));
            [Ny , Nx , Nz]             = size(Ineg);
            if(Nz == 3)
                Ineg                   = rgb2gray(Ineg);
            end
            
            if(min(Ny,Nx) < options.scalemax*max(options.ny,options.nx))
                scalemax              = min(Ny,Nx)/max(options.ny,options.nx);
            end
        end
        
        scale                          = options.scalemin + (scalemax-options.scalemin)*rand;
        nys                            = round(options.ny*scale);
        nxs                            = round(options.nx*scale);
        
        y                              = ceil(1 + (Ny - nys - 1)*rand);
        x                              = ceil(1 + (Nx - nxs - 1)*rand);
        Itemp                          = Ineg(y:y+nys-1 , x:x+nxs-1);
        tempX                          = imresize(Itemp , [options.ny , options.nx]);
        
        if(options.standardize)
            dIneg                      = double(tempX);
            stdIneg                    = std(dIneg(:));
            if(stdIneg~=0)
                dIneg                  = dIneg/stdIneg;
            end
            minIneg                    = min(dIneg(:));
            maxIneg                    = max(dIneg(:));
            tempX                      = uint8(floor(255*(dIneg-minIneg)/(maxIneg-minIneg)));
        end
      
       
        if(std(double(tempX(:)),1)~= 0)
            X(: , : , coneg )          = tempX;
            coneg                      = coneg + 1;
            co                         = co + 1;
            if(options.preview)
                imagesc(tempX);
                drawnow
            end         
        end
    end
    waitbar((coneg - (options.Npos+1))/options.Nneg , h , sprintf('#neg/#generated = %d/%d, P_{fa} = %5.4f, scale = %4.2f' , coneg - (options.Npos+1), co + prenegnum - 1 , (coneg - (options.Npos+1))/(co + prenegnum - 1) , scale));    
end
close(h)
stat(3)        = coneg-1-stat(1);
stat(4)        = co-1;
if(options.usefa == 1)
    stat(5)    = prenegnum;
else
    stat(5)    = 0;
end

Xtrain         = X(:,:,[1:options.Npostrain,options.Npos+1:options.Npos+options.Nnegtrain]);
Xtest          = X(:,:,[options.Npostrain+1:options.Npos,options.Npos+options.Nnegtrain+1:Ntotal]);

