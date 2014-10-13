//
//  VideoFrame.h
//  ArtShow
//
//  Created by Sean Hickey on 10/12/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#ifndef ArtShow_VideoFrame_h
#define ArtShow_VideoFrame_h

typedef struct VideoFrame {
    size_t width;
    size_t height;
    size_t stride;
    unsigned char * data;
} VideoFrame;

#endif
