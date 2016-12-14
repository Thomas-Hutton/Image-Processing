% load('redapples.mat');
% positiveInstances = redapples(:,1:2);
% imDir = fullfile('C:','Users','Thomas','Documents','Senior Design','Image Processing','Red apples');
% addpath(imDir);
% negativeFolder = fullfile('C:','Users','Thomas','Documents','Senior Design','Image Processing','Negative');
% negativeImages = imageDatastore(negativeFolder);
% trainCascadeObjectDetector('redappledetector.xml',positiveInstances, negativeImages,...
%      'FalseAlarmRate',0.1,'NumCascadeStages',6);
detector = vision.CascadeObjectDetector('redappledetector.xml');
img = pic;
bbox = step(detector,img);
detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'red apple');
imshow(detectedImg);
rmpath(imDir);