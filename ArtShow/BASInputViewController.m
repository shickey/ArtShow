//
//  BASInputViewController.m
//  ArtShow
//
//  Created by Sean Hickey on 10/12/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import "BASInputViewController.h"

@interface BASInputViewController ()

@property (weak) IBOutlet NSTextField *questionText;
@property (weak) IBOutlet NSTextField *userResponseField;

- (void)changeQuestion;

@end

@implementation BASInputViewController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super initWithNibName:@"BASInputViewController" bundle:nil];
    if (self) {
        _managedObjectContext = managedObjectContext;
    }
    return self;
}

- (void)changeQuestion
{
    
}

@end
