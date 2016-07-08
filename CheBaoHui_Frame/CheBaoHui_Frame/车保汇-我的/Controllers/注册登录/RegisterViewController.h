//
//  RegisterViewController.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  判断是否登录成功
 *
 *  @param isLogin <#isLogin description#>
 */
typedef void(^IsLogin)(BOOL isLogin);

@protocol RegisterViewControllerDelegate <NSObject>

-(void) passIsLogin:(BOOL) isLogin;

@end



@interface RegisterViewController : JJBaseController

//声明block
@property(nonatomic,copy) IsLogin passIsLogin;

@property (nonatomic, weak) id   delegate;

@end
