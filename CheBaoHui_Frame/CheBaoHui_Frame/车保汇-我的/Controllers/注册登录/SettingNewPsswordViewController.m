//
//  SettingNewPsswordViewController.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SettingNewPsswordViewController.h"
#import "VerifyUitl.h"
#import "MJExtension.h"
#import "ResultModel.h"
#import "DBManager.h"


@interface SettingNewPsswordViewController ()
{
        int  _timeNumber;
}


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
 *设置新密码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *setNewPasswordButton;


@property(nonatomic,strong) HTTPManagerOfMine *HTTPManagerInstance;


- (IBAction)closeController:(UIButton *)sender;

@end

@implementation SettingNewPsswordViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void) initUITextField
{
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)closeController:(UIButton *)sender {
 [self.navigationController  popViewControllerAnimated:YES];
    
}


#pragma mark --设置新密码, 调用 ResetPassword 忘记密码 接口
- (IBAction)  setNewPassWordClick:(UIButton *)sender
{
    //判断电话号码是否正确
    if(![VerifyUitl isValidateMobile:self.phoneNumber.text]){
        [super showFailureHUD:@"请输入正确号码" hideTime :2.0f];
        return;
    }
    //判断验证码是否为空 是空进行提示
    if(self.verifyNumber.text.length==0){
        [super  showFailureHUD:@"验证码不能为空" hideTime:2.0f];
        return;
    }
    
    //判断密码不能小于6
    if(self.password.text.length<6){
        [super  showFailureHUD:@"密码不能小于6位" hideTime:2.0f];
        return;
    }
    
    NSString *mobilePhone = self.phoneNumber.text;
    NSString *smsCode = self.verifyNumber.text;
    NSString *passwordnew = self.password.text;
    
    //调用 ResetPassword 忘记密码 接口
    [self.HTTPManagerInstance ResetPasswordWithmobilePhone:mobilePhone smsCode:smsCode passwordNew:passwordnew];
    
    __weak typeof(self) temp = self;
    
    //成功 获得数据
    _HTTPManagerInstance.passResponseObjectOfResetPassword = ^(id responseObject){
        ResultModel * result =  [ResultModel  mj_objectWithKeyValues: responseObject];
        //如果服务器返回来的是状态码     1提示错误信息  0 提示正确信息
        if([result.code  isEqualToString:@"1"]){
            if([ result.msg rangeOfString:@"，"].location !=NSNotFound){
                NSRange range = [result.msg rangeOfString:@"，"];
                NSString * newMsg = [result.msg substringToIndex:range.location];
                [super showFailureHUD: newMsg hideTime:2.0f];
            }else{
                [super showFailureHUD:result.msg hideTime:2.0f];
            }
        }else {
            //密码修改成功显示信息
            [super showSuccessHUD:result.msg  hideTime:2.0f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [temp.navigationController  popViewControllerAnimated:YES];
            });
        }
    };
    
    //失败
    _HTTPManagerInstance.passErrorOfResetPassword = ^(NSError *error){
        
    };
    
    
}

#pragma mark -- 获取 验证码,调用 GetSmsCode接口
- (IBAction)achieveVerifyNumberClick:(UIButton *)sender
{
    //判断电话号码是否正确
    if(![VerifyUitl isValidateMobile:self.phoneNumber.text]){
        [super showToastHUD:@"请输入正确号码" hideTime :2.0f];
        return;
    }
    [self  timerStart];
  
    //参数
    NSString *mobilePhone = self.phoneNumber.text;
    NSString *isSystem = @"false";
    //调用 GetSmsCode接口
    [self.HTTPManagerInstance GetSmsCodeWithmobilePhone:mobilePhone isSystem:isSystem];
    
    //成功 得到数据
    _HTTPManagerInstance.passResponseObjectOfGetSmsCode = ^(id responseObject){
        
    };
    
    //失败
    _HTTPManagerInstance.passErrorOfGetSmsCode = ^(NSError * error){
        
    };
}


#pragma  mark   获取验证码时  进行倒计时
-(void) timerStart
{
    _timeNumber ++;
    if (_timeNumber < 60) {
        [self.achieveVerifyNumberButton setTitle:[NSString stringWithFormat:@"%is",60 - _timeNumber] forState:UIControlStateNormal];
        [self.achieveVerifyNumberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.achieveVerifyNumberButton.userInteractionEnabled = NO;
        [self performSelector:@selector(timerStart) withObject:nil afterDelay:1];
    }else{
        _timeNumber = 0;
        self.achieveVerifyNumberButton.userInteractionEnabled = YES;
        NSString *_verifystr=[NSString stringWithFormat:@"验证码"];
        [self.achieveVerifyNumberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.achieveVerifyNumberButton setTitle:_verifystr forState:UIControlStateNormal];
    }
    
}


#pragma mark - 懒加载
-(HTTPManagerOfMine *)HTTPManagerInstance{
    if (_HTTPManagerInstance == nil) {
        _HTTPManagerInstance = [HTTPManagerOfMine sharedHTTPManagerOfMine];
    }
    return _HTTPManagerInstance;
}


#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController  setNavigationBarHidden:YES animated:NO];
    [self initUITextField];
    
    
    //设置圆角
    [self.setNewPasswordButton.layer setMasksToBounds:YES];
    [self.setNewPasswordButton.layer  setCornerRadius:5.0f];
    
    [self.achieveVerifyNumberButton.layer setMasksToBounds:YES];
    [self.achieveVerifyNumberButton.layer  setCornerRadius:5.0f];
    
}


@end
