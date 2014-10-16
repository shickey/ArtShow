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

- (void)switchViewController:(BASViewControllerValue)viewControllerValue;

@end

@implementation UserWindowController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super initWithWindowNibName:@"UserWindowController"];
    if (self) {
        _managedObjectContext = managedObjectContext;
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
    
    [self switchViewController:BASDisplayViewControllerValue];
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

@end
