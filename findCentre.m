function centres=findcentre(snap1)
min_area=1100;
location1=[];
location2=[];
rr=snap1(:,:,1);
gg=snap1(:,:,2);
bb=snap1(:,:,3);
redz=((rr>=80) & (rr<=255) & (gg>=0) & (gg<=50) & (bb>=0) & (bb<=50));
 %   figure,imshow(redz);
    %title('before filter');
    %redz=medfilt2(redz);
    %figure,imshow(redz);
    %title('after filter');
    
%     redz = bwareaopen(redz,10); %% 10 se kam pixels ko hatao 
%    figure,imshow(redz);
%     title('area open');
    
    
    se=strel('disk',5);
redz=imclose(redz,se);
%figure,imshow(redz);
redz=imfill(redz,'holes'); %closed component ke ander vali noise ka removal
%figure,imshow(redz);

L1 = bwlabel(redz);%connected componenets label
a1 = regionprops(L1, 'Area');
area=[a1.Area]
f1=find(area>min_area);
im1=ismember(L1,f1);% agar l1 ,f1 ka member hai 
L1=im1.*L1;

c1= regionprops(L1, 'Centroid');
g1=[c1.Centroid];
g1(isnan(g1))=[]; %remove nan error 
counter=1;
for i=1:length(g1)
    if mod(i,2)~=0
        location1(counter,2)=g1(i);
    else
        location1(counter,1)=g1(i);
        counter=counter+1;
    end
end






bluez=((rr>=0) & (rr<=55) & (gg>=0) & (gg<=55) & (bb>=65) & (bb<=200));
    %figure,imshow(bluez);
    %title('before filter');
    bluez=medfilt2(bluez);
    %figure,imshow(bluez);
    title('after filter');
    
%     redz = bwareaopen(redz,10); %% 10 se kam pixels ko hatao 
%     figure,imshow(redz);
%     title('area open');
    
    
    se=strel('disk',5);
bluez=imclose(bluez,se);
%figure,imshow(bluez);
title('image closing');
bluez=imfill(bluez,'holes'); %connected component ke ander vali noise ka removal
%figure,imshow(bluez);
title('image after filling holes ')
L1 = bwlabel(bluez);
a1 = regionprops(L1, 'Area');
area=[a1.Area]
f1=find(area>min_area);
im1=ismember(L1,f1);%% returns 1 jaha pe area required limit mein hai
L1=im1.*L1;

c1= regionprops(L1, 'Centroid');
g1=[c1.Centroid];
g1(isnan(g1))=[]; %remove nan eroor 
counter=1;
for i=1:length(g1)
    if mod(i,2)~=0
        location2(counter,2)=g1(i);
    else
        location2(counter,1)=g1(i);
        counter=counter+1;
    end
end


location1
location2

centres=vertcat(location1,location2);
