//
//  UIImage+tool.m
//  HeartBeat
//
//  Created by Leon.Hwa on 17/2/24.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "UIImage+tool.h"

@implementation UIImage (tool)

- (UIColor *)averageColorPrecise
{
    CGImageRef rawImageRef = self.CGImage;
    
    // This function returns the raw pixel values
    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(rawImageRef));
    const UInt8 *rawPixelData = CFDataGetBytePtr(data);
    
    NSUInteger imageHeight = CGImageGetHeight(rawImageRef);
    NSUInteger imageWidth  = CGImageGetWidth(rawImageRef);
    NSUInteger bytesPerRow = CGImageGetBytesPerRow(rawImageRef);
    NSUInteger stride = CGImageGetBitsPerPixel(rawImageRef) / 8;
    
    // Here I sort the R,G,B, values and get the average over the whole image
    unsigned int red   = 0;
    unsigned int green = 0;
    unsigned int blue  = 0;
    
    for (int row = 0; row < imageHeight; row++) {
        const UInt8 *rowPtr = rawPixelData + bytesPerRow * row;
        for (int column = 0; column < imageWidth; column++) {
            red    += rowPtr[2];
            green  += rowPtr[1];
            blue   += rowPtr[0];
            rowPtr += stride;
            
        }
    }
    CFRelease(data);
    
    CGFloat f = 1.0f / (255.0f * imageWidth * imageHeight);
    return [UIColor colorWithRed:f*red  green:f*green blue:f*blue alpha:1];
}

// should be at least four time faster than averageColorPrecise
// but the result isn't accurate, color values only given in integers (if multiplied by 255.0f)
- (UIColor *)averageColor
{
    CGSize size = {1, 1};
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(ctx, kCGInterpolationMedium);
    [self drawInRect:(CGRect){.size = size} blendMode:kCGBlendModeCopy alpha:1];
    uint8_t *data = CGBitmapContextGetData(ctx);
    UIColor *color = [UIColor colorWithRed:data[0] / 255.0f
                                     green:data[1] / 255.0f
                                      blue:data[2] / 255.0f
                                     alpha:data[3]];
    UIGraphicsEndImageContext();
    return color;
    
    // another implemention that should work on every UIImage
    /*
     CGImageRef rawImageRef = [self CGImage];
     
     // scale image to an one pixel image
     
     uint8_t  bitmapData[4];
     int bitmapByteCount;
     int bitmapBytesPerRow;
     int width = 1;
     int height = 1;
     
     bitmapBytesPerRow = (width * 4);
     bitmapByteCount = (bitmapBytesPerRow * height);
     memset(bitmapData, 0, bitmapByteCount);
     CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
     CGContextRef context = CGBitmapContextCreate (bitmapData,width,height,8,bitmapBytesPerRow,
     colorspace,kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst);
     CGColorSpaceRelease(colorspace);
     CGContextSetBlendMode(context, kCGBlendModeCopy);
     CGContextSetInterpolationQuality(context, kCGInterpolationMedium);
     CGContextDrawImage(context, CGRectMake(0, 0, width, height), rawImageRef);
     CGContextRelease(context);
     return [UIColor colorWithRed:bitmapData[2] / 255.0f
     green:bitmapData[1] / 255.0f
     blue:bitmapData[0] / 255.0f
     alpha:1];
     */
}


- (UIImage *)imageMaskWithColor:(UIColor *)maskColor {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [maskColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

// Create a UIImage from sample buffer data
+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return image;
}
@end
