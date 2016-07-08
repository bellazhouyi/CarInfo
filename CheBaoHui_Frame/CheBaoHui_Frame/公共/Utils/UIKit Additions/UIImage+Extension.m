//
//  UIImage+Extension.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "UIImage+Extension.h"


@implementation UIImage (Extension)




-(UIImage *)transformtoSize:(CGSize)size image:(UIImage*)image{
    
    CGRect myImageRect = CGRectMake(0, 0, size.width, size.height);
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, myImageRect);
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIGraphicsPushContext(context);
    
    CGContextDrawImage(context, myImageRect, subImageRef);
   
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    CGImageRelease(subImageRef);
    
    CGContextRelease(context);
    
    UIGraphicsEndImageContext();
    
    UIGraphicsPopContext();
    
    return smallImage;
}

+(UIImage *) resizableImageWithName:(NSString * ) fileName   andW :(CGFloat )  w  andH :(CGFloat ) h
{
    UIImage * norImage= [UIImage imageNamed: fileName];
    CGFloat  width =  norImage.size.width;
    CGFloat  height =norImage.size.height;
    CGFloat edgeW = width* w;
    CGFloat edgeH = height*h ;
    UIImage *newImage = [norImage resizableImageWithCapInsets:UIEdgeInsetsMake(edgeH, edgeW, edgeH, edgeW) resizingMode:UIImageResizingModeStretch];
    return newImage;
}

+(UIImage *) resizableImage:(UIImage *)image  andW :(CGFloat )  w  andH :(CGFloat ) h {
    UIImage * norImage= image;
    CGFloat  width =  norImage.size.width;
    CGFloat  height =norImage.size.height;
    CGFloat edgeW = width* w;
    CGFloat edgeH = height*h ;
    UIImage *newImage = [norImage resizableImageWithCapInsets:UIEdgeInsetsMake(edgeH, edgeW, edgeH, edgeW) resizingMode:UIImageResizingModeStretch];
    return newImage;
}


#pragma mark -- 图片压缩到指定大小
//图片压缩到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


@end
