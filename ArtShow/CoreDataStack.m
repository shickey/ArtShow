//
//  CoreDataStack.m
//  ArtShow
//
//  Created by Sean Hickey on 10/10/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import "CoreDataStack.h"

@interface CoreDataStack ()

- (NSURL *)appDocumentsURL;
- (NSURL *)modelURL;
- (NSURL *)storeURL;

@end

@implementation CoreDataStack

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Kick off stack creation
        [self managedObjectContext];
    }
    return self;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (nil == _persistentStoreCoordinator) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        NSError *error = nil;
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:[self storeURL]
                                                        options:nil
                                                          error:&error];
        if (nil != error) {
            NSLog(@"Unable to create persistent store coordinator. Error: %@, %@", error, error.localizedDescription);
            _persistentStoreCoordinator = nil;
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (nil == _managedObjectModel) {
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[self modelURL]];
    }
    
    return _managedObjectModel;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (nil == _managedObjectContext) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
        [_managedObjectContext setRetainsRegisteredObjects:YES];
    }
    
    return _managedObjectContext;
}

#pragma mark - Class Extension Methods

- (NSURL *)appDocumentsURL
{
    NSURL *appSupport = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *appDocsURL = [appSupport URLByAppendingPathComponent:@"local.seanhickey.ArtShow"];
    
    NSError *error = nil;
    [appDocsURL resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error]; // Don't assign to variable, we're just checking for errors
    if (error && [error code] == NSFileReadNoSuchFileError) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[appDocsURL path] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return appDocsURL;
}

- (NSURL *)modelURL
{
    return [[NSBundle mainBundle] URLForResource:@"ArtShow" withExtension:@"momd"];
}

- (NSURL *)storeURL
{
    return [[self appDocumentsURL] URLByAppendingPathComponent:@"ArtShow.sqlite"];
}

@end
