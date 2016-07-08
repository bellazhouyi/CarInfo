//
//  LoginUIView.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  登录
 */

@protocol  LoginUIViewDelegate  <NSObject>

/**
 *  @param phoneNumber 账号
 *  @param password     密码
 */
-(void)  phoneNumber:(NSString * ) phoneNumber passowrd:(NSString * ) password;

-(void) jumpToSettingNewPassword;

@end

@interface LoginUIView : UIView


-(void) initLoginUiView;



@property (weak, nonatomic) id delegate;

@end
