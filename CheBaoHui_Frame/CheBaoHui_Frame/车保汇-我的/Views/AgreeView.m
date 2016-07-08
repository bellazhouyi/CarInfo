//
//  AgreeView.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/21.
//  Copyright © 2016年 Joker. All rights reserved.
//


#import "AgreeView.h"

@interface AgreeView()

@property (weak, nonatomic) IBOutlet UIButton *serviceArticle;


@property (weak, nonatomic) IBOutlet UIButton *agreeArticle;


@end

@implementation AgreeView


-(void) serveArticleaddTarget:(id)target action:(SEL)action
{
    [self.serviceArticle addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

/**
 *同意
 */
-(void) agreeArticleaddTarget:(id)target action:(SEL)action
{
    [self.agreeArticle addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
}


@end
