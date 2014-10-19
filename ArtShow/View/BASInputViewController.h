//
//  BASInputViewController.h
//  ArtShow
//
//  Created by Sean Hickey on 10/12/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BASViewController.h"

@class BASInputViewController;

@protocol BASInputViewControllerDelegate <NSObject>

@required
- (NSImage *)inputViewControllerRequestedImage:(BASInputViewController *)inputViewController;

@end


@interface BASInputViewController : BASViewController

@property (weak, nonatomic) id<BASInputViewControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
