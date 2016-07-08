//
//  RegisterUIView.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "RegisterUIView.h"
#import "VerifyUitl.h"
#import "AFNetworking.h"

@interface  RegisterUIView()<UITextFieldDelegate>

/**
 *  手机号码
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
/**
 *  验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *verifyNumber;

/**
 *  密码
 */
@property (weak , nonatomic)IBOutlet  UITextField *  password;

/**
 *  获取验证码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *achieveVerifyNumberButton;

/**
 *  注册按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *registerButton;


@end

@implementation RegisterUIView

-(void)initRegister
{
    
    
    
    [self.registerButton.layer setMasksToBounds:YES];
    [self.registerButton.layer  setCornerRadius:5.0f];

    [self.achieveVerifyNumberButton.layer setMasksToBounds:YES];
    [self.achieveVerifyNumberButton.layer  setCornerRadius:5.0f];

    [self.phoneNumber addTarget:self action:@selector(phoneNumberDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.verifyNumber addTarget:self action:@selector(phoneNumberDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.password addTarget:self action:@selector(phoneNumberDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    //验证输入框是否有内容
    if(self.phoneNumber.text.length==0){
        [self.achieveVerifyNumberButton setUserInteractionEnabled:NO];
    }
}

-(void ) phoneNumberDidChange :(UITextField * ) textField 
{
    if(textField == self.phoneNumber){
        if (textField.text.length >= 11) {
            [self.achieveVerifyNumberButton  setUserInteractionEnabled:YES];
            textField.text = [textField.text substringToIndex:11];
        }
    } else if(textField == self.verifyNumber){
        if (textField.text.length >=4) {
            textField.text = [textField.text substringToIndex:4];
        }
    }else if(textField == self.password){
        if (textField.text.length >=16) {
            textField.text = [textField.text substringToIndex:16];
        }
    }
}

/**
 注册
 */
- (IBAction)registerClick:(UIButton *)sender
{
    if([self.delegate  respondsToSelector:@selector(phoneNumber:verifyNumber:password:)]){
        [self.delegate  phoneNumber:self.phoneNumber.text verifyNumber:self.verifyNumber.text password:self.password.text];
    }
}

/*
 获取验证码
 */
- (IBAction)achieveVerifyNumberClick:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector( phoneNumber:button:)]){
        [self.delegate  phoneNumber:self.phoneNumber.text button:self.achieveVerifyNumberButton];
    }
}




@end
