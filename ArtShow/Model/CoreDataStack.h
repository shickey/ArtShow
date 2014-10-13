//
//  CoreDataStack.h
//  ArtShow
//
//  Created by Sean Hickey on 10/10/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataStack : NSObject

@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@end
