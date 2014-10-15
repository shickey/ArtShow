//
//  NSImage+cvMat.h
//  ArtShow
//
//  Created by Sean Hickey on 10/13/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <opencv2/opencv.hpp>

@interface NSImage (cvMat)

+ (cv::Mat)cvMatFromImage:(NSImage *)image;
+ (NSImage *)imageFromCvMat:(cv::Mat)mat;
- (cv::Mat)cvMat;

@end
