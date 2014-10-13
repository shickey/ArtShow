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

typedef enum : NSUInteger {
    BASInputViewControllerValue = 0,
    BASDisplayViewControllerValue
} BASViewControllerValue;

@interface UserWindowController () <VideoStreamDelegate>

@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) BASViewController *currentViewController;

@property (weak, nonatomic) IBOutlet NSView *containerView;

@property (strong, nonatomic) VideoStream *stream;
@property (weak) IBOutlet NSImageView *videoView;

- (void)switchViewController:(BASViewControllerValue)viewControllerValue;

@end

@implementation UserWindowController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super initWithWindowNibName:@"UserWindowController"];
    if (self) {
        _managedObjectContext = managedObjectContext;
        _stream = [[VideoStream alloc] init];
        [_stream setDelegate:self];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    BASInputViewController *inputViewController = [[BASInputViewController alloc] initWithManagedObjectContext:self.managedObjectContext];
    BASDisplayViewController *displayViewController = [[BASDisplayViewController alloc] initWithNibName:@"BASDisplayViewController" bundle:nil];
    self.viewControllers = @[inputViewController, displayViewController];
    
    for (BASViewController *vc in self.viewControllers) {
        [vc viewDidLoad];
    }
    
    [self switchViewController:BASInputViewControllerValue];
    
    [_stream start];
}

- (void)switchViewController:(BASViewControllerValue)viewControllerValue
{
    if (self.currentViewController) {
        [self.currentViewController viewWillDisappear];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController viewDidDisappear];
    }
    
    BASViewController *nextViewController = self.viewControllers[viewControllerValue];
    [nextViewController viewWillAppear];
    
    NSView *nextView = nextViewController.view;
    nextView.frame = self.containerView.bounds;
    [nextView setTranslatesAutoresizingMaskIntoConstraints:YES];
    nextView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.containerView addSubview:nextView];
    
    [nextViewController viewDidAppear];
    self.currentViewController = nextViewController;
}

- (void)videoStream:(VideoStream *)videoStream frameReady:(VideoFrame)frame
{
    __weak typeof(self) _weakSelf = self;
    dispatch_sync( dispatch_get_main_queue(), ^{
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef newContext = CGBitmapContextCreate(frame.data,
                                                        frame.width,
                                                        frame.height,
                                                        8,
                                                        frame.stride,
                                                        colorSpace,
                                                        kCGBitmapByteOrder32Little |
                                                        kCGImageAlphaPremultipliedFirst);
        CGImageRef newImage = CGBitmapContextCreateImage(newContext);
        CGContextRelease(newContext);
        CGColorSpaceRelease(colorSpace);
        
        NSImage *image = [[NSImage alloc] initWithCGImage:newImage size:NSZeroSize];
        CGImageRelease(newImage);
        [[_weakSelf videoView] setImage:image];
    });
}

@end
