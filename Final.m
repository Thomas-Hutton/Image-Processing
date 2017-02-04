% USART Receive
clc
clear
avr = serial('COM4','BAUD',9600);
avr.Terminator = 'B';
fopen(avr);
receive1 = fscanf(avr);
fclose(avr);

fopen(avr);
receive2 = fscanf(avr);
fclose(avr);

% Run routine for red apples
if receive1 == '0b00000001B'& receive2 == '0b00010000B'
    % Setup left and right cameras 
    camLeft = webcam(2); 
    camRight = webcam(1);

    camLeft.Resolution = '1280x720';
    camRight.Resolution = '1280x720';
    
    % Load the stereoParameters object
    load('stereoParams3.mat'); 

    % Load red apple detection parametors 
    redAppleDetector = vision.CascadeObjectDetector('redappledetector.xml');

    % Take a picture using left and right cameras
    imgLeft = snapshot(camLeft);
    imgRight = snapshot(camRight);

    % Correct images for lens distortion
    imgLeft = undistortImage(imgLeft, stereoParams3.CameraParameters1);
    imgRight = undistortImage(imgRight, stereoParams3.CameraParameters2);

    % Apply red apple detection algorithm to images
    appleL = redAppleDetector(imgLeft);
    appleR = redAppleDetector(imgRight);
    
    j = 1;
    while j <= numel(appleL)/4 && numel(appleR)/4
        centerL{j} = [appleL(j,1),appleL(j,2)] + [appleL(j,3),appleL(j,4)] / 2;
        centerR{j} = [appleR(j,1),appleR(j,2)] + [appleR(j,3),appleR(j,4)] / 2;
        point3D{j} = triangulate(centerL{j}, centerR{j}, stereoParams3);
        distanceInMeters{j} = [norm(point3D{j})/1000];
        j = j+1;
    end

    point3D = cell2mat(point3D);

    % Convert distanceInMeters from type cell to matrix
    distanceInMeters = cell2mat(distanceInMeters);

    % Sort calculated distances in matrix from highest to lowest
    distanceInMeters = sort(distanceInMeters,'descend');

    labels = cell(1, numel(distanceInMeters));
    for i = 1:numel(distanceInMeters)
        labels{i} = sprintf('%0.2f meters', distanceInMeters(i));
    end
    
elseif receive1 == '0b00000001B' & receive2 == '

end
