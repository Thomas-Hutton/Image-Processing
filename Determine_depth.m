%% Camera setup



%% User input interface
prompt = {'Select fruit color, red or green:'}; %Prompt user for input
title = 'Fruit color selector'; %Title for input dialog box
N = 50; %Parameter that increases width of input dialog box
answer = inputdlg(prompt, title, [1 N]); %Create input dialog box
new_answer = lower(answer); %Convert input string to lowercase
new_answer = string(new_answer); %Convert type back to string

%% Acquire left and right image
left_rgb = imread('mypic1.jpg');
right_rgb = imread('mypic2.jpg');

%% Apply threshold mask
if  new_answer == 'red' %Check if user typed red
    left_img = maskNotRed1(left_rgb); %Filter out all colors except for red
    right_img = maskNotRed1(right_rgb);
elseif new_answer == 'green' %Check if user typed green
    left_img = maskNotGreen1(left_rgb); %Filter out all colors except for green
    right_img = maskNotGreen1(right_rgb);
else
    error('%s is not a valid color', new_answer); %Error message if non valid color entered
end
   
%% Morphological operations
se = strel('disk',7); %Create morphological structure element
left_imClean = imopen(left_img,se); %Morphologically open image
right_imClean = imopen(right_img,se);
left_imClean = imfill(left_imClean, 'holes'); %Fill all holes
right_imClean = imfill(right_imClean, 'holes');
left_imClean = imclearborder(left_imClean); %Remove objects around border of image
right_imClean = imclearborder(right_imClean);

%% Rectify image frames
frameLeft = left_imClean;
frameRight = right_imClean;
[frameLeftRect, frameRightRect] = ...
    rectifyStereoImages(frameLeft, frameRight);
imshow(stereoAnaglyph(frameLeftRect, frameRightRect));
