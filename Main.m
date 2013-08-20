clc
close all;
clear all;

location1=[];
location2=[];

%vid_obj=videoinput('winvideo',1,'YUY2_640x480');
 vid_obj=videoinput('winvideo',2,'RGB24_352x288');
 set(vid_obj,'FramesPerTrigger',25);
 triggerconfig(vid_obj, 'manual');
 start(vid_obj);
 set(vid_obj,'returnedcolorspace','rgb');
 
flag=1;
'get ready for hand gestures'
temp=imread('target_image.jpg');
base_image(:,:,:,flag)=imresize(temp,[288 352]);

while(1)
    snap1=getsnapshot(vid_obj);
	figure,imshow(snap1)
	[xxx yyy k]=size(snap1);
    figure,imshow(base_image(:,:,:,flag));
    title('base image');
	centres=findCentre(snap1);
	[r1 c1]=size(centres);
	
	if((r1==4)&(c1==2))
		location1=centres(1:2,1:2);
		location2=centres(3:4,1:2);
		slope1=(location1(1,1)-location1(2,1))/(location1(1,2)-location1(2,2));
		slope2=(location2(1,1)-location2(2,1))/(location2(1,2)-location2(2,2));
		diff=abs(slope1-slope2)
		pre1=location1(2,2)-location1(1,2);
		pre2=location2(2,2)-location2(1,2);
	else
		diff=100000;
end

if(diff<0.3)
        'resizing mode'
        while(diff<0.3)
        snap1=getsnapshot(vid_obj);
        centres=findCentre(snap1);
        [r1 c1]=size(centres);
        if((r1==4)&(c1==2))
        location1=centres(1:2,1:2)
        location2=centres(3:4,1:2)
    
        slope1=(location1(1,1)-location1(2,1))/(location1(1,2)-location1(2,2));
        slope2=(location2(1,1)-location2(2,1))/(location2(1,2)-location2(2,2));

        diff=abs(slope1-slope2);
 
        distance1=location1(2,2)-location1(1,2);
        distance2=location2(2,2)-location2(1,2);
       
        change1=distance1-pre1
        change2=distance2-pre2
        
        if((change1>5)&(change2>5))
            'enlarge operation'
            mid_pointx=(location1(1,2)+location1(2,2))/2;
            mid_pointy=(location1(1,1)+location2(1,1))/2;
            
            
            temp=imcrop(base_image(:,:,:,flag),[mid_pointx-50,mid_pointy-50,200,200]);
            temp=imresize(temp,[xxx,yyy]);
            flag=flag+1;
            base_image(:,:,:,flag)=temp;
            
            %figure 
            imshow(base_image(:,:,:,flag));
            
        elseif((change2<-5)&(change1<-5))
            'decrease operation'
            flag=flag-1;
            if(flag<1)
                flag=1;
            end
            imshow(base_image(:,:,:,flag));
        end
            pre1=distance1;
            pre2=distance2;
        else
            
        diff=100000;
        end     
    pause(0.2);
        end
     
end
    break;
    end
	
delete(vid_obj);