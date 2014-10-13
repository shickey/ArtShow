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

@required
- (void)videoStream:(VideoStream *)videoStream frameReady:(VideoFrame)frame;

@end

@interface VideoStream : NSObject

@property (weak, nonatomic) id<VideoStreamDelegate> delegate;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDeviceInput *deviceInput;

- (BOOL)start;

@end
