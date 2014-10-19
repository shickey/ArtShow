//
//  BASInputViewController.m
//  ArtShow
//
//  Created by Sean Hickey on 10/12/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import "BASInputViewController.h"
#import "BASQuestion.h"
#import "BASResponse.h"
#import <QuartzCore/QuartzCore.h>

@interface BASInputViewController ()

@property (weak) IBOutlet NSTextField *questionText;
@property (weak) IBOutlet NSTextField *userResponseField;

@property (strong, nonatomic) BASQuestion *currentQuestion;

- (void)changeQuestion;
- (IBAction)submitResponse:(id)sender;

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

- (void)viewDidLoad
{
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:[NSColor colorWithRed:(39.0 / 255.0) green:(44.0 / 255.0) blue:(43.0 / 255.0) alpha:1.0].CGColor];
    
}

- (void)viewWillAppear
{
    [self changeQuestion];
    
    [self.userResponseField setFocusRingType:NSFocusRingTypeNone];
    
}

- (void)viewDidAppear
{
    NSTextView *fieldEditor = (NSTextView *)[self.userResponseField.window fieldEditor:YES forObject:self.userResponseField];
    [fieldEditor setInsertionPointColor:[NSColor colorWithWhite:(204.0 / 255.0) alpha:1.0]];
    [self.userResponseField becomeFirstResponder];
}

- (void)changeQuestion
{
    BASQuestion *nextQuestion = [BASQuestion fetchRandomQuestionIntoManagedObjectContext:self.managedObjectContext];
    NSLog(@"Question: %@", nextQuestion.questionText);
    [self.questionText setStringValue:nextQuestion.questionText];
    [self.userResponseField setStringValue:@""];
    self.currentQuestion = nextQuestion;
}

- (IBAction)submitResponse:(id)sender
{
    BASResponse *response = [BASResponse insertInManagedObjectContext:self.managedObjectContext];
    [response setQuestion:self.currentQuestion];
    [response setResponseText:self.userResponseField.stringValue];
    
    NSImage *image = [self.delegate inputViewControllerRequestedImage:self];
    if (nil != image) {
        [image lockFocus];
        NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, image.size.width, image.size.height)];
        [image unlockFocus];
        NSData *imageData = [rep representationUsingType:NSBMPFileType properties:nil];
        [response setImage:imageData];
    }
    
    NSError *saveError = nil;
    if (![self.managedObjectContext save:&saveError]) {
        NSLog(@"Error while saving managed object context: %@", saveError);
    }
    
    [self changeQuestion];
}

@end
