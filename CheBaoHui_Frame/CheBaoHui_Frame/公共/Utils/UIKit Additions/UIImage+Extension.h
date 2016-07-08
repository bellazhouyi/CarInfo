//
//  UIImage+Extension.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)


-(UIImage *)transformtoSize:(CGSize)size image:(UIImage*)image;
    

/**
 *传入图片的名称 返回一张拉伸不变形的图片
 *  @param name imageName
 *
 *  @return UIImage
 */

+(UIImage *) resizableImageWithName:(NSString * ) fileName   andW :(CGFloat )  w  andH :(CGFloat ) h ;


+(UIImage *) resizableImage:(UIImage *)image  andW :(CGFloat )  w  andH :(CGFloat ) h ;


//图片压缩到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;


@end
