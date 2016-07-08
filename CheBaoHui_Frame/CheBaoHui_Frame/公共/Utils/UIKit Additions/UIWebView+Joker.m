//
//  UIWebView+Joker.m
//  Additions_PS
//
//  Created by pengshuai on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import "UIWebView+Joker.h"

@implementation UIWebView (Joker)

- (void)removeBackgroundShadow
{
    for(UIView *eachSubview in [self.scrollView subviews])
    {
        if([eachSubview isKindOfClass:[UIImageView class]] && eachSubview.frame.origin.x <= 500)
        {
            eachSubview.hidden = YES;
            [eachSubview removeFromSuperview];
        }
    }
}

- (void)loadWebsite:(NSString *)website
{
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:website]]];
}

@end
