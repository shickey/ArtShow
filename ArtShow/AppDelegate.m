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

#import "BASQuestion.h"

@interface AppDelegate ()

@property (strong, nonatomic) UserWindowController *windowController;
@property (strong, nonatomic) CoreDataStack *coreDataStack;

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.coreDataStack = [[CoreDataStack alloc] init];
    self.windowController = [[UserWindowController alloc] initWithManagedObjectContext:self.coreDataStack.managedObjectContext];
    [self.windowController showWindow:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}


- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    
    return NSTerminateNow;
}

@end
