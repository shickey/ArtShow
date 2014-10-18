//
//  AppDelegate.m
//  ArtShow
//
//  Created by Sean Hickey on 10/9/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataStack.h"
#import "UserWindowController.h"
#import "VideoStream.h"
#import "VideoWindowController.h"

@interface AppDelegate ()

@property (strong, nonatomic) CoreDataStack *coreDataStack;
@property (strong, nonatomic) UserWindowController *userWindowController;

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.coreDataStack = [[CoreDataStack alloc] init];
    
    self.userWindowController = [[UserWindowController alloc] initWithManagedObjectContext:self.coreDataStack.managedObjectContext];
    [self.userWindowController showWindow:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}


- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    
    return NSTerminateNow;
}

@end
