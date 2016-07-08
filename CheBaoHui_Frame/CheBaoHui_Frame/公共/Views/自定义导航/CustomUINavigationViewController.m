//
//  CustomUINavigationViewController.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "CustomUINavigationViewController.h"
#import "UIImage+Color.h"
@interface CustomUINavigationViewController ()

@end

@implementation CustomUINavigationViewController


+(void) initialize
{
    UINavigationBar *bar =  [UINavigationBar appearance ];
    [bar setBackgroundImage:[UIImage  imageNamed:@"naviBar"] forBarMetrics: UIBarMetricsDefault];
    
    //设置bar线条为隐藏
    [bar setBackgroundImage:[UIImage createImageWithColor: ColorFromRGBA(36, 150, 218, 1) ] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[UIImage new]];
    
    [bar  setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
