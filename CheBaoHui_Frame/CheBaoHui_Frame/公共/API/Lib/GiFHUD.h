//
//  GiFHUD.h
//  GiFHUD
//
//  Created by Cem Olcay on 30/10/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiFHUD : UIView


+ (void)show;
+ (void)showWithOverlay;

//自己补充的三条
+ (void)showWithMessage:(NSString *)message;

+ (void)setGifWithImagesByBiggerFrame:(NSArray *)images;
+ (void)dismissBiggerFrame;


+ (void)dismiss;

+ (void)setGifWithImages:(NSArray *)images;
+ (void)setGifWithImageName:(NSString *)imageName;
+ (void)setGifWithURL:(NSURL *)gifUrl;


@end
