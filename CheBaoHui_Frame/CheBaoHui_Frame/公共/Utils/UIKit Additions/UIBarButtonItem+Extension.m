//
//  UIBarButtonItem+Extension.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
@implementation UIBarButtonItem (Extension)

/**
 *  创建一个item
 *
 *  @param target     点击item后调用哪个对象的方法
 *  @param action     点击item后调用target的哪个方法
 *  @param image      图片
 *  @param hightImage   高亮图片
 *
 *  @return UIBarButtonItem
 */
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image hightImage:(NSString *)hightImage
{
    UIButton * backBtn =  [UIButton   buttonWithType:UIButtonTypeCustom];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    [backBtn addTarget: target action:action forControlEvents:UIControlEventTouchUpInside];
    [backBtn  setImage:[UIImage  imageNamed:  image] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage  imageNamed: hightImage] forState:UIControlStateHighlighted];
    backBtn.size =    CGSizeMake(40, 50);
    return  [[UIBarButtonItem  alloc] initWithCustomView: backBtn];
}

@end
