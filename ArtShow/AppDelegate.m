//
//  AppDelegate.m
//  ArtShow
//
//  Created by Sean Hickey on 10/9/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataStack.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) CoreDataStack *coreDataStack;

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.coreDataStack = [[CoreDataStack alloc] init];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}


- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    
    return NSTerminateNow;
}

@end
