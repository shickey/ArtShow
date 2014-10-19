//
//  VideoStream.h
//  ArtShow
//
//  Created by Sean Hickey on 10/12/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "VideoFrame.h"

@class VideoStream;
@protocol VideoStreamDelegate <NSObject>

@optional
- (void)videoStream:(VideoStream *)videoStream frameReady:(VideoFrame)frame foregroundMask:(VideoFrame)mask;
- (void)videoStreamDetectedObject:(VideoStream *)videoStream;
- (void)videoStreamDetectedClearBackground:(VideoStream *)videoStream;

@end

@interface VideoStream : NSObject

@property (weak, nonatomic) id<VideoStreamDelegate> delegate;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDeviceInput *deviceInput;
@property (assign, nonatomic, readonly) BOOL hasObjectInView;

- (BOOL)start;

@end
