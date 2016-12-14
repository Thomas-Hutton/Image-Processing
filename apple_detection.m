clear
clc

%% User input interface
prompt = {'Select fruit color, red or green:'}; %Prompt user for input
title = 'Fruit color selector'; %Title for input dialog box
N = 50; %Parameter that increases width of input dialog box
answer = inputdlg(prompt, title, [1 N]); %Create input dialog box
new_answer = lower(answer); %Convert input string to lowercase
new_answer = string(new_answer); %Convert type back to string

%% Acquire image
rgb = imread('app.jpg');

%% Apply threshold mask
if  new_answer == 'red' %Check if user typed red
    img = maskNotRed1(rgb); %Filter out all colors except for red
elseif new_answer == 'green' %Check if user typed green
    img = maskNotGreen1(rgb); %Filter out all colors except for green
else
    error('%s is not a valid color', new_answer); %Error message if non valid color entered
end
   
%% Morphological operations
se = strel('sphere',7); %Create morphological structure element
imClean = imopen(img,se); %Morphologically open image
imClean = imfill(imClean, 'holes'); %Fill all holes
imClean = imclearborder(imClean); %Remove objects around border of image

%% Calculate and display centroid of apples
s = regionprops(imClean, 'centroid'); %Determine centroid of apples
centroids = cat(1, s.Centroid); %Concatenate structure array containing centroids into a single matrix
imshow(imClean); %Display cleaned image
hold on
plot(centroids(:,1), centroids(:,2), 'b.') %Superimpose centroid locations onto image
hold off


