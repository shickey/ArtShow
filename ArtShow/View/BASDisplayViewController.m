//
//  BASDisplayViewController.m
//  ArtShow
//
//  Created by Sean Hickey on 10/12/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import "BASDisplayViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BASQuestion.h"
#import "BASResponse.h"

static NSTimeInterval const kSAEDisplayTimeInterval = 5.0f;
static CGFloat const kSAEDisplayTransistionTimeInterval = 1.0f;

@interface BASDisplayViewController ()

@property (strong, nonatomic) BASResponse *currentResponse;
@property (strong, nonatomic) NSTimer *displayTimer;

- (void)changeDisplay;
- (void)animateToNewBackgroundColor:(float)duration;
- (CGColorRef)generateColor;

@end

@implementation BASDisplayViewController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super initWithNibName:@"BASDisplayViewController" bundle:nil];
    if (self) {
        _managedObjectContext = managedObjectContext;
    }
    return self;
}

- (void)viewDidLoad
{
    [self.view setWantsLayer:YES];
    [self.view setLayerContentsRedrawPolicy:NSViewLayerContentsRedrawOnSetNeedsDisplay];
}

- (void)viewWillAppear
{
    [self changeDisplay];
    self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:kSAEDisplayTimeInterval target:self selector:@selector(changeDisplay) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear
{
    [self.displayTimer invalidate];
    self.displayTimer = nil;
}

- (void)changeDisplay
{
//    BASResponse *nextResponse = [BASResponse fetchRandomResponseIntoManagedObjectContext:self.managedObjectContext];
    
}

- (void)animateToNewBackgroundColor:(float)duration
{
    CGColorRef randomColor = [self generateColor];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.fromValue = (id)[self.view.layer backgroundColor];
    animation.toValue = (id)CFBridgingRelease(randomColor);
    animation.duration = duration;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        self.view.layer.backgroundColor = randomColor;
    }];
    [self.view.layer addAnimation:animation forKey:@"backgroundColor"];
    [CATransaction commit];
}

- (CGColorRef)generateColor
{
    NSColor *color = [NSColor colorWithHue:(arc4random() / (float)0x100000000) saturation:0.34f brightness:1.0f alpha:1.0f];
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    [color getRed:&red green:&green blue:&blue alpha:NULL];
    return CGColorCreateGenericRGB(red, green, blue, 1.0);
}

@end
