//
//  NSImage+cvMat.m
//  ArtShow
//
//  Created by Sean Hickey on 10/13/14.
//  Copyright (c) 2014 Open Set Software. All rights reserved.
//

#import "NSImage+cvMat.h"

@implementation NSImage (cvMat)

+ (cv::Mat)cvMatFromImage:(NSImage *)image
{
    CGImageRef cgImage = [image CGImageForProposedRect:NULL context:NULL hints:nil];
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(cgImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4);
    
    CGContextRef context = CGBitmapContextCreate(cvMat.data,
                                                 cols,
                                                 rows,
                                                 8,
                                                 cvMat.step[0],
                                                 colorSpace,
                                                 kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
    CGContextDrawImage(context, CGRectMake(0, 0, cols, rows), cgImage);
    CGContextRelease(context);
    
    return cvMat;
}

+ (NSImage *)imageFromCvMat:(cv::Mat)mat
{
    NSData *data = [NSData dataWithBytes:mat.data length:(mat.elemSize() * mat.total())];
    CGColorSpaceRef colorSpace;
    
    if (mat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    }
    else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    CGImageRef imageRef = CGImageCreate(mat.cols,
                                        mat.rows,
                                        8,
                                        8 * mat.elemSize(),
                                        mat.step[0],
                                        colorSpace,
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,
                                        provider,
                                        NULL,
                                        false,
                                        kCGRenderingIntentDefault);
    
    NSImage *finalImage = [[NSImage alloc] initWithCGImage:imageRef size:NSZeroSize];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

- (cv::Mat)cvMat
{
    return [NSImage cvMatFromImage:self];
}

@end
