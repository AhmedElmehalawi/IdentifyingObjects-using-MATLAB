RGB = imread('pillsetc.png');
%imshow(RGB);

I = rgb2gray(RGB);
threshold = graythresh(I);
bw = im2bw(I,threshold);                %[imbinarize] instead of [im2bw]
%figure, imshow(bw)

bw1 = bwareaopen(bw,30);                % removing all object containing fewer than 30 pixels
%figure, imshow(bw1)

se = strel('disk',2);                   % filling the gap in the pen's cap
bw2 = imclose(bw1,se);
%figure, imshow(bw2);

bw3 = imfill(bw2,'holes');               % filling any holes
%figure, imshow(bw3);

[B,L] = bwboundaries(bw3,'noholes');
%figure, imshow(L);

imshow(label2rgb(L, @hsv, [.5 .5 .5]))   % Displaying the label matrix and draw each boundary
hold on

for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2);
end
    
stats = regionprops(L,'Area','Centroid','BoundingBox');

% looping over the boundaries
for k = 1:length(B)                              
 boundary = B{k};                             % obtaining (X,Y) boundary coordinates corresponding to label 'k'
 delta_sq = diff(boundary).^2;                % computing a simple estimate of the object's perimeter

 perimeter = sum(sqrt(sum(delta_sq,2)));

 area = stats(k).Area;                        % obtaining the area calculation corresponding to label 'k'
 metric = 4*pi*area/perimeter^2;              % computing the roundness metric
 metric_string = sprintf('%2.2f',metric);     % displaying the results

% marking objects above the threshold with a black circle
if metric > 0.9
  centroid = stats(k).Centroid;
  plot(centroid(1),centroid(2),'ko');
  bbox=stats(k).BoundingBox;
  rectangle('Position', [bbox(1)-5,bbox(2)-5,bbox(3)+15,bbox(4)+15],...
    'EdgeColor','r','LineWidth',2 );
end
  text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','y',...
    'FontSize',14,'FontWeight','bold');
end

title('Metrics closer to 1 indicate that the object is approximately round')







