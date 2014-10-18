//
//  VideoWindowController.m
//  ArtShow
//
//  Created by Sean Hickey on 10/13/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import "VideoWindowController.h"

@interface VideoWindowController ()

@property (weak) IBOutlet NSImageView *videoView;

@end

@implementation VideoWindowController

- (void)updateImage:(NSImage *)image
{
    [self.videoView setImage:image];
}

@end
