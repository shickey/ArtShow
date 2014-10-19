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

static int const kSAELowPixelThreshold = 75;
static int const kSAEHighPixelThreshold = 200;

@interface VideoStream () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (assign, nonatomic) Ptr<BackgroundSubtractor> backgroundSubtractor;
@property (assign, nonatomic, readwrite) BOOL hasObjectInView;

- (void)processFrame:(VideoFrame)frame;
- (Mat)cvMatFromFrame:(VideoFrame)frame;

- (void)checkThreshold:(int)threshold;

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
        if ([device.localizedName hasPrefix:kSAECameraName]) {
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
    
    // Create background subtractor object
    self.backgroundSubtractor = createBackgroundSubtractorMOG2(500);
    
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
    Mat mat = [self cvMatFromFrame:frame];
    
    Mat foregroundMask;
    self.backgroundSubtractor->apply(mat, foregroundMask);
    
    int countOfWhitePixels = countNonZero(foregroundMask);
    
    [self checkThreshold:countOfWhitePixels];
    
    VideoFrame maskFrame  = {static_cast<size_t>(foregroundMask.cols), static_cast<size_t>(foregroundMask.rows), foregroundMask.step[0], foregroundMask.data};
    
    [self.delegate videoStream:self frameReady:frame foregroundMask:maskFrame];
}


- (Mat)cvMatFromFrame:(VideoFrame)frame
{
    Mat cvMat((int)frame.height, (int)frame.width, CV_8UC4);
    
    memcpy(cvMat.data, frame.data, sizeof(unsigned char) * cvMat.cols * cvMat.rows * cvMat.channels());
    
    return cvMat;
}

- (void)checkThreshold:(int)threshold
{
    if (threshold > kSAEHighPixelThreshold && !self.hasObjectInView) {
        self.hasObjectInView = YES;
        [self.delegate videoStreamDetectedObject:self];
    }
    else if (threshold < kSAELowPixelThreshold && self.hasObjectInView) {
        self.hasObjectInView = NO;
        [self.delegate videoStreamDetectedClearBackground:self];
    }
}

- (void)dealloc
{
    [_captureSession stopRunning];
}

@end
