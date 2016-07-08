//
//  UILabel+Extension.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/17.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)


-(CGSize) sizeForTitle :(NSString * ) title  withFont :(UIFont  *  ) font
{
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX)  options:NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName : font } context:nil];
    
    return  CGSizeMake(titleRect.size.width,titleRect.size.height);
}





@end
