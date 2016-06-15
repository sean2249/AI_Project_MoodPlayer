%% Fundemental Setting 
clear all; close all;

projectName = 'KDEF';
training = imageSet('train_KDEF', 'recursive');
cellSize = [8 8];
blockSize = [2 2];
flag4Cascade = 0;
% imgSize = [280,180];
%% Test 
% img = read(training(1),1);
% img = imresize((img), imgSize, 'bicubic');
% img = extractHOGFeatures(img, 'CellSize', cellSize);
% [img, visu] = extractHOGFeatures(img,'CellSize', cellSize);
% % imshow(img); hold on;plot(visu);
% HOGsize = size(img,2);         

%% Extract HOG Feature
sum = 0; for i=1:length(training),sum = sum + training(i).Count; end

trainingFeature = [];
featureCount=1;
faceDetector = vision.CascadeObjectDetector;

for idx=1:length(training)
    for num=1:training(idx).Count
       img = read(training(idx),num);
       
%        if flag4Cascade==1
%            bboxes = step(faceDetector, img);
%                for i=1:size(bboxes,1)
%                    tmp = img(bboxes(i,2):bboxes(i,2)+bboxes(i,4),bboxes(i,1):bboxes(i,1)+bboxes(i,3),:);
%                    tmp = imresize((tmp), imgSize, 'bicubic');
%                    tmp = extractHOGFeatures(tmp, 'CellSize', cellSize);
%                    trainingFeature = [trainingFeature;tmp];
%                    trainingLabel{featureCount} = training(idx).Description;
%                    featureCount = featureCount +1;
%                end     
%        end

%        if flag4Cascade==0
           tmp = extractHOGFeatures(img, 'CellSize', cellSize);
           trainingFeature = [trainingFeature;tmp];
           trainingLabel{featureCount} = training(idx).Description;
           featureCount = featureCount +1;
%        end
    end
end
%% Classifier
faceClassifier = fitcecoc(trainingFeature, trainingLabel);
save(strcat('classifier', projectName, '.mat'), 'faceClassifier');

%%
save(strcat(projectName,'_features.mat'), 'trainingFeature');
save(strcat(projectName,'_label.mat'), 'trainingLabel');
