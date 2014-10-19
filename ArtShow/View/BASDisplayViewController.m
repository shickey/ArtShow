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

static NSTimeInterval const kSAEDisplayTimeInterval = 10.0f;
static CGFloat const kSAEDisplayTransistionTimeInterval = 1.0f;

typedef enum : NSUInteger {
    kSAEDisplayShowingNone = 0,
    kSAEDisplayShowingLeft,
    kSAEDisplayShowingRight,
} SAEDisplayType;

@interface BASDisplayViewController ()

@property (assign, nonatomic) SAEDisplayType currentDisplayType;
@property (strong, nonatomic) BASResponse *currentResponse;
@property (strong, nonatomic) NSTimer *displayTimer;

@property (weak) IBOutlet NSImageView *imageView1;
@property (weak) IBOutlet NSTextField *questionText1;
@property (weak) IBOutlet NSTextField *responseText1;

@property (weak) IBOutlet NSImageView *imageView2;
@property (weak) IBOutlet NSTextField *questionText2;
@property (weak) IBOutlet NSTextField *responseText2;

- (void)resetDisplay;
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
        _currentDisplayType = kSAEDisplayShowingNone;
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
    [self resetDisplay];
    [self changeDisplay];
    self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:kSAEDisplayTimeInterval target:self selector:@selector(changeDisplay) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear
{
    [self.displayTimer invalidate];
    self.displayTimer = nil;
}

- (void)resetDisplay
{
    self.currentDisplayType = kSAEDisplayShowingNone;
    [self.imageView1.layer    setOpacity:0.0f];
    [self.questionText1.layer setOpacity:0.0f];
    [self.responseText1.layer setOpacity:0.0f];
    [self.imageView2.layer    setOpacity:0.0f];
    [self.questionText2.layer setOpacity:0.0f];
    [self.responseText2.layer setOpacity:0.0f];
}

- (void)changeDisplay
{
    BASResponse *nextResponse = [BASResponse fetchRandomResponseIntoManagedObjectContext:self.managedObjectContext];
    if (nil == nextResponse) {
        [self resetDisplay];
        self.currentDisplayType = kSAEDisplayShowingNone;
        [self.responseText2 setStringValue:@"Waiting for data..."]; // Use responseText2 so we can fade to responseText1 if need be
        [self.responseText2 setAlphaValue:1.0];
        [self animateToNewBackgroundColor:kSAEDisplayTransistionTimeInterval];
        return;
    }
    
    NSImage* image = [[NSImage alloc] initWithData:nextResponse.image];
    
    __block CGColorRef randomColor = [self generateColor];
    CABasicAnimation *backgroundColorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    backgroundColorAnimation.fromValue = (id)[self.view.layer backgroundColor];
    backgroundColorAnimation.toValue = (id)CFBridgingRelease(randomColor);
    backgroundColorAnimation.duration = kSAEDisplayTransistionTimeInterval;
    
    
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOutAnimation.fromValue = @1.0f;
    fadeOutAnimation.toValue   = @0.0f;
    fadeOutAnimation.duration  = kSAEDisplayTransistionTimeInterval;
    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.fromValue = @0.0f;
    fadeInAnimation.toValue   = @1.0f;
    fadeInAnimation.duration  = kSAEDisplayTransistionTimeInterval;
    
    // Display image on left
    if (self.currentDisplayType == kSAEDisplayShowingRight || self.currentDisplayType == kSAEDisplayShowingNone) {
        [self.imageView1 setImage:image];
        [self.questionText1 setStringValue:nextResponse.question.questionText];
        [self.responseText1 setStringValue:nextResponse.responseText];
        [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                [self.view.layer setBackgroundColor:randomColor];
                [self.imageView1.layer setOpacity:1.0f];
                [self.questionText1.layer setOpacity:1.0f];
                [self.responseText1.layer setOpacity:1.0f];
                [self.imageView2.layer setOpacity:0.0f];
                [self.questionText2.layer setOpacity:0.0f];
                [self.responseText2.layer setOpacity:0.0f];
            }];
            [self.view.layer addAnimation:backgroundColorAnimation forKey:@"backgroundColor"];
            [self.imageView1.layer addAnimation:fadeInAnimation forKey:@"opacity"];
            [self.questionText1.layer addAnimation:fadeInAnimation forKey:@"opacity"];
            [self.responseText1.layer addAnimation:fadeInAnimation forKey:@"opacity"];
            if (self.currentDisplayType != kSAEDisplayShowingNone) {
                [self.imageView2.layer addAnimation:fadeOutAnimation forKey:@"opacity"];
                [self.questionText2.layer addAnimation:fadeOutAnimation forKey:@"opacity"];
                [self.responseText2.layer addAnimation:fadeOutAnimation forKey:@"opacity"];
            }
        [CATransaction commit];
        self.currentDisplayType = kSAEDisplayShowingLeft;
    }
    
    // Display image on right
    else {
        [self.imageView2 setImage:image];
        [self.questionText2 setStringValue:nextResponse.question.questionText];
        [self.responseText2 setStringValue:nextResponse.responseText];
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self.view.layer setBackgroundColor:randomColor];
            [self.imageView1.layer setOpacity:0.0f];
            [self.questionText1.layer setOpacity:0.0f];
            [self.responseText1.layer setOpacity:0.0f];
            [self.imageView2.layer setOpacity:1.0f];
            [self.questionText2.layer setOpacity:1.0f];
            [self.responseText2.layer setOpacity:1.0f];
        }];
        [self.view.layer addAnimation:backgroundColorAnimation forKey:@"backgroundColor"];
        [self.imageView1.layer addAnimation:fadeOutAnimation forKey:@"opacity"];
        [self.questionText1.layer addAnimation:fadeOutAnimation forKey:@"opacity"];
        [self.responseText1.layer addAnimation:fadeOutAnimation forKey:@"opacity"];
        [self.imageView2.layer addAnimation:fadeInAnimation forKey:@"opacity"];
        [self.questionText2.layer addAnimation:fadeInAnimation forKey:@"opacity"];
        [self.responseText2.layer addAnimation:fadeInAnimation forKey:@"opacity"];
        [CATransaction commit];
        self.currentDisplayType = kSAEDisplayShowingRight;
    }
}

- (void)animateToNewBackgroundColor:(float)duration
{
    __block CGColorRef randomColor = [self generateColor];
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
    long ARC4RANDOM_MAX = 0x100000000;
    NSColor *color = [NSColor colorWithHue:(arc4random() / (float)ARC4RANDOM_MAX) saturation:0.65f brightness:1.0f alpha:1.0f];
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    [color getRed:&red green:&green blue:&blue alpha:NULL];
    return CGColorCreateGenericRGB(red, green, blue, 1.0);
}

@end
