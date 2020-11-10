%Original Image
RGB = imread('img.jpg');
imshow(RGB),title('Original Image');

I = rgb2gray(RGB);
figure, imshow(I),title('Gray Image');
threshold = graythresh(I);
bw = imbinarize(I,threshold);                %[imbinarize] is used instead of [im2bw]
figure, imshow(bw);

%Edge detection
bb= edge(bw,'canny');
imshow(bb),title('BW with edge detection')

% filling holes & gaps of the objects
se = strel('disk',2);       
bw1 = imclose(bb,se);
bw2 = imfill(bw1,'holes');
figure, imshow(bw2),title('BW Image after filling the holes');

[B,L] = bwboundaries(bw2,'noholes');
figure, imshow(L);
imshow(label2rgb(L, @hsv, [.5 .5 .5]))       % Displaying the label matrix and draw each boundary
hold on

stats = regionprops(L,'Area','Centroid','BoundingBox');

for k = 1:length(B)                              
 boundary = B{k};                             % obtaining (X,Y) boundary coordinates corresponding to label 'k'
 delta_sq = diff(boundary).^2;                % computing a simple estimate of the object's perimeter

 perimeter = sum(sqrt(sum(delta_sq,2)));

 area = stats(k).Area;                        % obtaining the area calculation corresponding to label 'k'
 metric = 4*pi*area/perimeter^2;              % computing the roundness metric
 metric_string = sprintf('%2.2f',metric);     % displaying the results

% marking objects above the threshold with a black circle
if metric > 0.89
  centroid = stats(k).Centroid;
  plot(centroid(1),centroid(2),'ko');
  bbox=stats(k).BoundingBox;
  rectangle('Position', [bbox(1)-5,bbox(2)-5,bbox(3)+15,bbox(4)+15],...
    'EdgeColor','r','LineWidth',2 );
end
  text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','K',...
    'FontSize',12,'FontWeight','bold');
end

title('Metrics closer to 1 indicate that the object is approximately round')