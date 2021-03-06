//
//  UserWindowController.m
//  ArtShow
//
//  Created by Sean Hickey on 10/12/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import "UserWindowController.h"
#import "BASInputViewController.h"
#import "BASDisplayViewController.h"
#import "VideoStream.h"
#import "VideoWindowController.h"

typedef enum : NSUInteger {
    BASNoneViewControllerValue = 0,
    BASDisplayViewControllerValue,
    BASInputViewControllerValue
} BASViewControllerValue;

@interface UserWindowController () <VideoStreamDelegate, BASInputViewControllerDelegate>

@property (strong, nonatomic) VideoStream *videoStream;
@property (strong, nonatomic) VideoWindowController *videoWindowController;
@property (strong, nonatomic) NSImage *lastImage;

@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) BASViewController *currentViewController;
@property (assign, nonatomic) BASViewControllerValue currentViewControllerValue;

@property (weak, nonatomic) IBOutlet NSView *containerView;

- (void)switchViewController:(BASViewControllerValue)viewControllerValue;

@end

@implementation UserWindowController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super initWithWindowNibName:@"UserWindowController"];
    if (self) {
        _managedObjectContext = managedObjectContext;
        _currentViewControllerValue = BASNoneViewControllerValue;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.videoWindowController = [[VideoWindowController alloc] initWithWindowNibName:@"VideoWindowController"];
    [self.videoWindowController showWindow:self];
    [self.videoWindowController.window orderBack:self];
    
    self.videoStream = [[VideoStream alloc] init];
    [self.videoStream setDelegate:self];
    [self.videoStream start];
    
    BASDisplayViewController *displayViewController = [[BASDisplayViewController alloc] initWithManagedObjectContext:self.managedObjectContext];
    BASInputViewController *inputViewController = [[BASInputViewController alloc] initWithManagedObjectContext:self.managedObjectContext];
    [inputViewController setDelegate:self];
    self.viewControllers = @[displayViewController, inputViewController];
    
    for (BASViewController *vc in self.viewControllers) {
        [vc viewDidLoad];
    }
    
    [self switchViewController:BASDisplayViewControllerValue];
}

- (void)switchViewController:(BASViewControllerValue)viewControllerValue
{
    if (self.currentViewControllerValue == viewControllerValue) {
        return;
    }
    
    if (self.currentViewController) {
        [self.currentViewController viewWillDisappear];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController viewDidDisappear];
    }
    
    BASViewController *nextViewController = self.viewControllers[viewControllerValue - 1];
    [nextViewController viewWillAppear];
    
    NSView *nextView = nextViewController.view;
    nextView.frame = self.containerView.bounds;
    [nextView setTranslatesAutoresizingMaskIntoConstraints:YES];
    nextView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.containerView addSubview:nextView];
    
    [nextViewController viewDidAppear];
    self.currentViewController = nextViewController;
    self.currentViewControllerValue = viewControllerValue;
}

// VideoStreamDelegate Methods

- (void)videoStream:(VideoStream *)videoStream frameReady:(VideoFrame)frame foregroundMask:(VideoFrame)mask
{
    __weak typeof(self) _weakSelf = self;
    dispatch_sync( dispatch_get_main_queue(), ^{
        CGColorSpaceRef frameColorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef frameContext = CGBitmapContextCreate(frame.data,
                                                          frame.width,
                                                          frame.height,
                                                          8,
                                                          frame.stride,
                                                          frameColorSpace,
                                                          kCGBitmapByteOrder32Little |
                                                          kCGImageAlphaPremultipliedFirst);
        CGImageRef frameImageRef = CGBitmapContextCreateImage(frameContext);
        CGContextRelease(frameContext);
        CGColorSpaceRelease(frameColorSpace);
        
        NSImage *colorImage = [[NSImage alloc] initWithCGImage:frameImageRef size:NSZeroSize];
        CGImageRelease(frameImageRef);
        [_weakSelf setLastImage:colorImage];
        
        CGColorSpaceRef maskColorSpace = CGColorSpaceCreateDeviceGray();
        CGContextRef maskContext = CGBitmapContextCreate(mask.data,
                                                         mask.width,
                                                         mask.height,
                                                         8,
                                                         mask.stride,
                                                         maskColorSpace,
                                                         kCGBitmapByteOrderDefault);
        CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);
        CGContextRelease(maskContext);
        CGColorSpaceRelease(maskColorSpace);
        
        NSImage *maskImage = [[NSImage alloc] initWithCGImage:maskImageRef size:NSZeroSize];
        CGImageRelease(maskImageRef);
        [_weakSelf.videoWindowController updateImage:maskImage];
    });
}

- (void)videoStreamDetectedObject:(VideoStream *)videoStream
{
    NSLog(@"Found Object");
    __weak typeof(self) _weakSelf = self;
    dispatch_sync(dispatch_get_main_queue(), ^{
        [_weakSelf switchViewController:BASInputViewControllerValue];
    });
}

- (void)videoStreamDetectedClearBackground:(VideoStream *)videoStream
{
    NSLog(@"Background Clear");
    __weak typeof(self) _weakSelf = self;
    dispatch_sync(dispatch_get_main_queue(), ^{
        [_weakSelf switchViewController:BASDisplayViewControllerValue];
    });
}

// InputViewDelegate

- (NSImage *)inputViewControllerRequestedImage:(BASInputViewController *)inputViewController
{
    return self.lastImage;
}

@end
