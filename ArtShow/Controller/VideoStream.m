//
//  VideoStream.m
//  ArtShow
//
//  Created by Sean Hickey on 10/12/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import "VideoStream.h"

@interface VideoStream () <AVCaptureVideoDataOutputSampleBufferDelegate>

@end

@implementation VideoStream

- (instancetype)init
{
    self = [super init];
    if (self) {
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        [session setSessionPreset:AVCaptureSessionPreset640x480];
        _captureSession = session;
    }
    return self;
}

- (BOOL)start
{
    // Input
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if ([devices count] == 0) {
        NSLog(@"No video input devices found.");
        return NO;
    }
    AVCaptureDevice *videoDevice = [devices lastObject];
    
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (nil != error) {
        NSLog(@"Could not open input port for device %@. %@", videoDevice, [error localizedDescription]);
        return NO;
    }
    else {
        [self setDeviceInput:videoInput];
    }
    
    if ([self.captureSession canAddInput:videoInput]) {
        [self.captureSession addInput:videoInput];
    }
    else {
        NSLog(@"Unable to add input port to capture session %@", self.captureSession);
        return NO;
    }
    
    // Output
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    [videoOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    dispatch_queue_t captureQueue = dispatch_queue_create("local.seanhickey.ArtShow.VideoCapture", DISPATCH_QUEUE_SERIAL);
    [videoOutput setSampleBufferDelegate:self queue:captureQueue];
    
    NSDictionary *settings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]};
    [videoOutput setVideoSettings:settings];
    
    [self.captureSession addOutput:videoOutput];
    
    [self.captureSession startRunning];
    return YES;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);
    
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t stride = CVPixelBufferGetBytesPerRow(imageBuffer);
    VideoFrame frame = {width, height, stride, baseAddress};
    
    [self.delegate videoStream:self frameReady:frame];
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
}

- (void)dealloc
{
    [_captureSession stopRunning];
}

@end
