//
//  ReplacePhoneViewController.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/22.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ReplacePhoneViewController.h"
#import "VerifyUitl.h"
#import "MJExtension.h"
#import "ResultModel.h"
#import "DBManager.h"
#import "Individual.h"

@interface ReplacePhoneViewController ()
{
    int  _timeNumber1;
    int _timeNumber2;
}

/**
 *  旧手机验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeOld;
/**
 *  新手机号码
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberNew;

/**
 *  新验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeNew;

/**
 *  确定修改
 */
- (IBAction)confirmUpdate:(UIButton *)sender;

/**
 *  旧验证码按钮button
 */
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;

/**
 *  新验证码button
 */
@property (weak, nonatomic) IBOutlet UIButton *verifyNewButton;


@property(nonatomic,strong) HTTPManagerOfMine *HTTPManagerInstance;

/**
 * 获取旧手机验证码
 */

- (IBAction)obtainOld:(UIButton *)sender;
/**
 * 获取新的手机验证码
 */
- (IBAction)obtainNew:(UIButton *)sender;

@end

@implementation ReplacePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)obtainOld:(UIButton *)sender {
    [self timerStart1];
    [self obtainVerify: self.phone];
}

- (IBAction)obtainNew:(UIButton *)sender {
    [self timerStart2];
    [self obtainVerify:  self.phoneNumberNew.text];
}


- (IBAction)confirmUpdate:(UIButton *)sender {
//    if(self.verifyCodeOld.text){
//        [super  showToastHUD:@"请输入验证码" hideTime:2.0f];
//        return;
//    }
//    
//    if(self.verifyCodeNew.text){
//        [super  showToastHUD:@"请输入验证码" hideTime:2.0f];
//        return;
//    }
    
    
    NSString *Id = self.phoneId;
    NSString *smsCode = self.verifyCodeOld.text;
    NSString *mobilePhoneNew = self.phoneNumberNew.text;
    NSString *smsCodeNew = self.verifyCodeNew.text;
    

    // 调用 ChangeMobilePhone接口
    [self.HTTPManagerInstance ChangeMobilePhoneWithId:Id smsCode:smsCode mobilePhoneNew:mobilePhoneNew smsCodeNew:smsCodeNew];
    
    __weak typeof(self) temp = self;
    //成功 获得数据
    _HTTPManagerInstance.passResponseObjectOfChangeMobilePhone = ^(id responseObject){
        ResultModel * result =  [ResultModel  mj_objectWithKeyValues: responseObject];
        DBManager * dbManager = [DBManager  sharedInstance];
        Individual * individual =  [dbManager  selectIndividual];
        if ([result.code isEqualToString:@"0"]) {
            //修改成功
            [dbManager  updatePhoneNumber: temp.phoneNumberNew.text andId:individual.individualId
             ];
            [super showSuccessHUD:result.msg hideTime:2.0f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [temp.navigationController  popViewControllerAnimated:YES];
            });
        }else{
            [super  showFailureHUD:@"修改失败" hideTime:2.0f];
        }
    };
    
    // 失败
    _HTTPManagerInstance.passErrorOfChangeMobilePhone = ^(NSError *error){
        
    };
    
    
    
}

-(void) obtainVerify :(NSString * ) phoneNumber
{
    //判断电话号码是否正确
    if(![VerifyUitl isValidateMobile:phoneNumber]){
        [super showToastHUD:@"请输入正确号码" hideTime :2.0f];
        return;
    }
    
    NSString *mobilePhone = phoneNumber;
    NSString *isSystem = @"false";
    
    //调用GetSmsCodeWithmobile 接口
    [self.HTTPManagerInstance GetSmsCodeWithmobilePhone:mobilePhone isSystem:isSystem];
    
    //成功
    _HTTPManagerInstance.passResponseObjectOfGetSmsCode = ^(id rsponseObject){
        
    };
    
    //失败
    _HTTPManagerInstance.passErrorOfGetSmsCode = ^(NSError *error){
        
    };
    
}


#pragma  mark   获取验证码时  进行倒计时
-(void) timerStart1
{
    _timeNumber1 ++;
    if (_timeNumber1 < 60) {
        [self.verifyButton setTitle:[NSString stringWithFormat:@"%is",60 - _timeNumber1] forState:UIControlStateNormal];
        [self.verifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.verifyButton.userInteractionEnabled = NO;
        [self performSelector:@selector(timerStart1) withObject:nil afterDelay:1];
    }else{
        _timeNumber1 = 0;
        self.verifyButton.userInteractionEnabled = YES;
        NSString *_verifystr=[NSString stringWithFormat:@"验证码"];
        [self.verifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.verifyButton setTitle:_verifystr forState:UIControlStateNormal];
    }
}


-(void) timerStart2
{
    _timeNumber2 ++;
    if (_timeNumber2 < 60) {
        [self.verifyNewButton setTitle:[NSString stringWithFormat:@"%is",60 - _timeNumber2] forState:UIControlStateNormal];
        [self.verifyNewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.verifyNewButton.userInteractionEnabled = NO;
        [self performSelector:@selector(timerStart2) withObject:nil afterDelay:1];
    }else{
        _timeNumber2 = 0;
        self.verifyNewButton.userInteractionEnabled = YES;
        NSString *_verifystr=[NSString stringWithFormat:@"验证码"];
        [self.verifyNewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.verifyNewButton setTitle:_verifystr forState:UIControlStateNormal];
    }
}

#pragma mark -- 懒加载
-(HTTPManagerOfMine *)HTTPManagerInstance{
    if (_HTTPManagerInstance == nil) {
        _HTTPManagerInstance = [HTTPManagerOfMine sharedHTTPManagerOfMine];
    }
    return _HTTPManagerInstance;
}



@end
