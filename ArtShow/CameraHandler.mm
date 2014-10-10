//
//  CameraHandler.mm
//  ArtShow
//
//  Created by Sean Hickey on 10/9/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import "CameraHandler.h"
#import <opencv2/opencv.hpp>

using namespace cv;

@implementation CameraHandler

- (instancetype)init
{
    self = [super init];
    if (self) {
        VideoCapture cap(0); // open the default camera
        
        Mat edges;
        namedWindow("edges",1);
        for(;;)
        {
            Mat frame;
            cap >> frame; // get a new frame from camera
            imshow("edges", frame);
            if(waitKey(30) >= 0) break;
        }
    }
    return self;
}

@end
