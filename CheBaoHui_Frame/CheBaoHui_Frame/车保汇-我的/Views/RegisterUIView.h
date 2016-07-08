//
//  RegisterUIView.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  注册新用户
 */

@protocol RegisterUIViewDelegate   <NSObject>

-(void)  phoneNumber:(NSString * ) phoneNumber  verifyNumber:(NSString * ) verifyNumber password:(NSString *)password;

-(void)  phoneNumber:(NSString * ) phoneNumber  button:(UIButton *) button;


@end


@interface RegisterUIView : UIView

-(void)  initRegister;

@property (weak, nonatomic) id delegate;

@end
