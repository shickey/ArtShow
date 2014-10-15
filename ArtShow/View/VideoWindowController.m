//
//  VideoWindowController.m
//  ArtShow
//
//  Created by Sean Hickey on 10/13/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import "VideoWindowController.h"
#import "VideoStream.h"

@interface VideoWindowController () <VideoStreamDelegate>

@property (weak) IBOutlet NSImageView *videoView;

@end

@implementation VideoWindowController

- (instancetype)initWithVideoStream:(VideoStream *)videoStream
{
    self = [super initWithWindowNibName:@"VideoWindowController"];
    if (self) {
        _videoStream = videoStream;
        [_videoStream setDelegate:self];
    }
    return self;
}

- (void)videoStream:(VideoStream *)videoStream frameReady:(VideoFrame)frame
{
    __weak typeof(self) _weakSelf = self;
    dispatch_sync( dispatch_get_main_queue(), ^{
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGContextRef newContext = CGBitmapContextCreate(frame.data,
                                                        frame.width,
                                                        frame.height,
                                                        8,
                                                        frame.stride,
                                                        colorSpace,
                                                        kCGBitmapByteOrderDefault);
        CGImageRef newImage = CGBitmapContextCreateImage(newContext);
        CGContextRelease(newContext);
        CGColorSpaceRelease(colorSpace);
        
        NSImage *image = [[NSImage alloc] initWithCGImage:newImage size:NSZeroSize];
        CGImageRelease(newImage);
        [[_weakSelf videoView] setImage:image];
    });
}

@end
