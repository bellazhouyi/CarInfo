//
//  LoginUIView.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "LoginUIView.h"

@interface LoginUIView()<UITextFieldDelegate>

/**
 *  登录
 *
 */
- (IBAction)loginClick:(UIButton *)sender;

/**
 *  忘记密码
 */
- (IBAction)forgetPasswordClick:(UIButton *)sender;

/**
 *  电话号码
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
/**
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginUIView


/**
 *  初始化东西
 */
-(void) initLoginUiView
{
    
    [self.loginButton.layer setMasksToBounds:YES];
    [self.loginButton.layer  setCornerRadius:5.0f];

    self.phoneNumber.delegate = self;
    self.password.delegate = self;
    
    [self.phoneNumber addTarget:self action:@selector(phoneNumberDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.password addTarget:self action:@selector(phoneNumberDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}
/*
  设置帐号和密码的输入长度
 */
-(void ) phoneNumberDidChange :(UITextField * ) textField
{
    if(textField == self.phoneNumber){
        if (textField.text.length >= 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }else if(textField == self.password){
        if (textField.text.length >=16) {
            textField.text = [textField.text substringToIndex:16];
        }
    }
}

#pragma mark UITextFieldDelegate  代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneNumber) {
        [self.phoneNumber resignFirstResponder];
        [self.password becomeFirstResponder];
    } else if(textField == self.password) {
        [self.password resignFirstResponder];
    }
    return YES;
}


/**
 *点击登录
 */
- (IBAction)loginClick:(UIButton *)sender {
    
    if([self.delegate  respondsToSelector:@selector(phoneNumber:passowrd:)]){
        [self.delegate   phoneNumber: self.phoneNumber.text passowrd:self.password.text];
    }
}


/**
 * 点击忘记密码 进入重新设置密码界面
 */
- (IBAction)forgetPasswordClick:(UIButton *)sender {
    if([self.delegate  respondsToSelector:@selector(jumpToSettingNewPassword)]){
        [self.delegate  jumpToSettingNewPassword];
    }


    
}
@end
