//
//  VideoStream.m
//  ArtShow
//
//  Created by Sean Hickey on 10/12/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import "VideoStream.h"
#import <opencv2/opencv.hpp>

using namespace cv;

@interface VideoStream () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (assign, nonatomic) Mat t_minus;
@property (assign, nonatomic) Mat t;
@property (assign, nonatomic) Mat t_plus;

- (void)processFrame:(VideoFrame)frame;
- (Mat)cvMatFromFrame:(VideoFrame)frame;

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
    AVCaptureDevice *videoDevice = nil;
    for (AVCaptureDevice *device in devices) {
        if ([device.localizedName isEqualToString:kSAECameraName]) {
            videoDevice = device;
        }
    }
    if (nil == videoDevice) {
        NSLog(@"Unable to find camera.");
        return NO;
    }
    
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
    
    [self processFrame:frame];
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
}

- (void)processFrame:(VideoFrame)frame
{
    self.t_minus = self.t;
    self.t = self.t_plus;
    self.t_plus = [self cvMatFromFrame:frame];
    
    if (self.t_minus.data) {
        Mat t_minus_gray;
        Mat t_gray;
        Mat t_plus_gray;
        
        cvtColor(self.t_minus, t_minus_gray, COLOR_RGB2GRAY);
        cvtColor(self.t, t_gray, COLOR_RGB2GRAY);
        cvtColor(self.t_plus, t_plus_gray, COLOR_RGB2GRAY);
        
        Mat diff1;
        Mat diff2;
        
        absdiff(t_plus_gray, t_gray, diff1);
        absdiff(t_gray, t_minus_gray, diff2);
        
        Mat motionDetected;
        bitwise_and(diff1, diff2, motionDetected);
        threshold(motionDetected, motionDetected, 50, 255, THRESH_BINARY);
        
        VideoFrame newFrame = {static_cast<size_t>(motionDetected.cols), static_cast<size_t>(motionDetected.rows), motionDetected.step[0], motionDetected.data};
        
        [self.delegate videoStream:self frameReady:newFrame];
    }
}


- (Mat)cvMatFromFrame:(VideoFrame)frame
{
    Mat cvMat((int)frame.height, (int)frame.width, CV_8UC4);
    
    memcpy(cvMat.data, frame.data, sizeof(unsigned char) * cvMat.cols * cvMat.rows * 4);
    
    return cvMat;
}

- (void)dealloc
{
    [_captureSession stopRunning];
}

@end
