//
//  CALayer+Joker.m
//  CQFishForIOS
//
//  Created by 崔毅 on 15/7/20.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import "CALayer+Joker.h"

@implementation CALayer (Joker)

-(void)setBorderColorFromUIColor:(UIColor *)borderColorFromUIColor{
    self.borderColor = borderColorFromUIColor.CGColor;
}

@end
