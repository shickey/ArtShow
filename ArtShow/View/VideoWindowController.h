//
//  VideoWindowController.h
//  ArtShow
//
//  Created by Sean Hickey on 10/13/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class VideoStream;

@interface VideoWindowController : NSWindowController

@property (strong, nonatomic) VideoStream *videoStream;

- (instancetype)initWithVideoStream:(VideoStream *)videoStream;

@end
