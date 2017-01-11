clear
clc

camLeft = webcam(2); 
camRight = webcam(1);

load('stereoParams3.mat'); %Load the stereoParameters object

redAppleDetector = vision.CascadeObjectDetector('redappledetector.xml');

imgLeft = snapshot(camLeft);
imgRight = snapshot(camRight);

imgLeft = undistortImage(imgLeft, stereoParams3.CameraParameters1);
imgRight = undistortImage(imgRight, stereoParams3.CameraParameters2);

appleL = redAppleDetector(imgLeft);
appleR = redAppleDetector(imgRight);

% j = 1;
% while j <= numel(appleL)/4 && numel(appleR)/4
%     centerL{j} = [appleL(j,1),appleL(j,2)] + [appleL(j,3),appleL(j,4)] / 2;
%     centerR{j} = [appleR(j,1),appleR(j,2)] + [appleR(j,3),appleR(j,4)] / 2;
%     j = j+1;
% end
% 
% k = 1;
% while k <= numel(appleL)/4 && numel(appleR)/4
%     point3D{k} = triangulate(centerL{k}, centerR{k}, stereoParams3);
%     k = k+1;
% end
% 
% l = 1;
% while l <= numel(appleL)/4 && numel(appleR)/4
%     distanceInMeters{l} = [norm(point3D{l})/1000];
%     l = l+1;
% end

% centerL = appleL(1:2) + appleL(3:4) / 2;
% centerR = appleR(1:2) + appleR(3:4) / 2;

  
% point3D = triangulate(centerL{j}, centerR{j}, stereoParams3);

% distanceInMeters = norm(point3D)/1000;

j = 1;
 while j <= numel(appleL)/4 && numel(appleR)/4
     centerL{j} = [appleL(j,1),appleL(j,2)] + [appleL(j,3),appleL(j,4)] / 2;
     centerR{j} = [appleR(j,1),appleR(j,2)] + [appleR(j,3),appleR(j,4)] / 2;
     point3D{j} = triangulate(centerL{j}, centerR{j}, stereoParams3);
     distanceInMeters{j} = [norm(point3D{j})/1000];
     j = j+1;
 end

distanceInMeters = cell2mat(distanceInMeters);
distanceInMeters = sort(distanceInMeters,'descend');

labels = cell(1, numel(distanceInMeters));
for i = 1:numel(distanceInMeters)
    labels{i} = sprintf('%0.2f meters', distanceInMeters(i));
end

% distanceAsString = sprintf('%0.2f meters', distanceInMeters);
imgLeft = insertObjectAnnotation(imgLeft, 'rectangle', appleL,...
    labels, 'FontSize', 18);
imgRight = insertObjectAnnotation(imgRight, 'rectangle', appleR,...
    labels, 'FontSize', 18);
imgLeft = insertShape(imgLeft, 'FilledRectangle', appleL);
imgRight = insertShape(imgRight, 'FilledRectangle', appleR);

imshowpair(imgLeft, imgRight, 'montage');