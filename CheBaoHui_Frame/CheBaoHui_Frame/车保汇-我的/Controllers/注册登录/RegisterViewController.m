//
//  RegisterViewController.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginUIView.h"
#import "UIView+Extension.h"
#import "RegisterUIView.h"
#import "SettingNewPsswordViewController.h"
#import "VerifyUitl.h"
#import "MJExtension.h"

#import "ResultModel.h"

#import "DBManager.h"
#import "DataModel.h"

typedef NS_ENUM(NSInteger,SwitchStyle) {
    UISwitchStyleRegister,
    UISwitchStyleLogin
} ;


@interface RegisterViewController ()<RegisterUIViewDelegate,LoginUIViewDelegate>
{
    int  _timeNumber;
}

- (IBAction)closeController:(UIButton *)sender;



@property (weak, nonatomic) IBOutlet UISegmentedControl *switchView;

- (IBAction)switchClick:(UISegmentedControl *)sender;

@property (weak, nonatomic) IBOutlet UIView *partView;

/**
 *  登录的uiview
 */
@property (nonatomic , strong) LoginUIView *  loginUiView;

@property (weak, nonatomic) UIButton * button;

/**
 *  注册的uiview
 */
@property (nonatomic , strong) RegisterUIView * registerUiView;

@property (nonatomic , strong) SettingNewPsswordViewController  *  settingNewPasswordView;


@property(nonatomic,strong) HTTPManagerOfMine *HTTPManagerInstance;

@end

@implementation RegisterViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.loginUiView  setDelegate:self];
    [self.partView  addSubview: self.loginUiView];
    
    __weak typeof(self) temp = self;
    self.passIsLogin = ^(BOOL isLogin){
        //跳转到上一级UI
        [temp.navigationController  popToRootViewControllerAnimated:YES];
    };
}

/**
 *点击事件进行切换视图
 */
- (IBAction)switchClick:(UISegmentedControl *)sender
{
    NSInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case UISwitchStyleRegister:{
            //清除当前view
            [self.registerUiView  removeFromSuperview];
            //addSuibivew
            [self.partView addSubview: self.loginUiView];
        }
            break;
        case UISwitchStyleLogin:{
            //清除当前view
            [self.loginUiView  removeFromSuperview];
            [self.registerUiView  initRegister];
            // 设置代理
            self.registerUiView.delegate = self;
            //addSuibivew
            [self.partView addSubview: self.registerUiView];
        }
            break;
    }
}

#pragma mark -  RegisterUIViewDelegate    获取短信验证码执行此代理
//  代理是接受view中发送过来的电话号码和uibutton
-(void)phoneNumber:(NSString *)phoneNumber button:(UIButton *)button
{
    //判断电话号码是否正确
    if(![VerifyUitl isValidateMobile:phoneNumber]){
        [super showToastHUD:@"请输入正确号码" hideTime :2.0f];
        return;
    }
    self.button = button;
    [self  timerStart];
    
    //所需 参数
    NSString *mobilePhone = phoneNumber;
    NSString *isSystem = @"false";
    
    //调用 接口
    [self.HTTPManagerInstance GetSmsCodeWithmobilePhone:mobilePhone isSystem:isSystem];
    
    //成功
    _HTTPManagerInstance.passResponseObjectOfGetSmsCode = ^(id responseObject){
        
    };
    
    //失败
    _HTTPManagerInstance.passErrorOfGetSmsCode = ^(NSError *error){
        
    };
    
}


#pragma  mark RegisterUIViewDelegate 点击注册执行此代理
//代理接收来自view中的注册按钮
-(void) phoneNumber:(NSString *)phoneNumber verifyNumber:(NSString *)verifyNumber password:(NSString *)password
{
    
    //判断电话号码是否正确
    if(![VerifyUitl isValidateMobile:phoneNumber]){
        [super showFailureHUD:@"请输入正确的手机号码" hideTime :2.0f];
        return;
    }
    //判断验证码是否为空 是空进行提示
    if(verifyNumber.length==0){
        [super  showFailureHUD:@"验证码不能为空" hideTime:2.0f];
        return;
    }
    
    //判断密码不能小于6
    if(password.length<6){
        [super  showFailureHUD:@"密码不能小于6位" hideTime:2.0f];
        return;
    }
    
    
    //参数
    NSString *mobilePhone = phoneNumber;
    NSString *smsCode = verifyNumber;
    
    //调用RegisterBusinessUser 接口
    [self.HTTPManagerInstance RegisterBusinessUserWithmobilePhone:mobilePhone password:password smsCode:smsCode];
    
    __weak typeof(self) temp = self;
    //成功 获得数据
    _HTTPManagerInstance.passResponseObjectOfRegisterBusinessUser = ^(id responseObject){
        ResultModel * result =  [ResultModel  mj_objectWithKeyValues: responseObject];
        //如果服务器返回来的是状态码     1提示错误信息  0 提示正确信息
        if([result.code  isEqualToString:@"1"]){
            if([ result.msg rangeOfString:@"，"].location !=NSNotFound){
                [super showFailureHUD:@"手机或者验证码不正确" hideTime:2.0f];
            }else{
                [super showFailureHUD:result.msg hideTime:2.0f];
            }
        }else {
            //注册成功显示成功提示
            [super showSuccessHUD:result.msg  hideTime:2.0f];
            //把数据保存到sqllite中
            DBManager *   dbManager =     [DBManager sharedInstance];
            //清除 (确保数据库中没有数据在保存)
            [dbManager  deleteIndividual];
            DataModel * data=[result data];
            //把数据进行持久化
            [dbManager addIndividual: phoneNumber password:password data:data ];
            /**
             *   点击注册就生成一张图片表
             */
            [dbManager  saveId: phoneNumber];
            
            //延迟2秒
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [temp hideKeyBoard];
                
                //注册成功后,清除上一个账号的残留物,发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:removeDataWhenExit object:nil];
                //跳转
                //self.passIsLogin(YES);
                if([temp.delegate respondsToSelector:@selector(passIsLogin:)]){
                    [temp.delegate  passIsLogin:YES];
                }else{
                    [temp.navigationController  popToRootViewControllerAnimated:YES];
                }
            });
        }
    };
    
    //失败
    _HTTPManagerInstance.passErrorOfRegisterBusinessUser = ^(NSError *error){
        [super showWarningHUD:@"注册失败" hideTime:ToastHideTime];
    };
    
}

#pragma  mark - LoginUIViewDelegate  点击登录 执行此代理
-(void)phoneNumber:(NSString *)phoneNumber passowrd:(NSString *)password
{
    //判断电话号码是否正确
    if(![VerifyUitl isValidateMobile:phoneNumber]){
        [super showFailureHUD:@"请输入正确号码" hideTime :2.0f];
        return;
    }
    //判断密码不能小于6
    if(password.length<6){
        [super  showFailureHUD:@"密码不能小于6位" hideTime:2.0f];
        return;
    }
    
    NSString *mobilePhone = phoneNumber;
    
    //调用 LoginValidate登录 接口
    [self.HTTPManagerInstance LoginValidateWithmobilePhone:mobilePhone password:password];
    
    __weak typeof(self) temp = self;
    
    //成功 获得数据
    _HTTPManagerInstance.passResponseObjectOfLoginValidate = ^(id responseObject){
        ResultModel * result =  [ResultModel mj_objectWithKeyValues:responseObject];
        
        if([result.code  isEqualToString:@"1"]){
            [super showFailureHUD:result.msg hideTime:2.0f];
        }else{
            [super  showSuccessHUD:result.msg hideTime:2.0f];
            
            //登录成功就把帐号进行持久化
            DBManager * dbManager = [DBManager sharedInstance];
            //操作前进行清除
            [dbManager  deleteIndividual];
            //执行保存操作
            DataModel * data= [result data];
            
            //把数据进行持久化
            [dbManager addIndividual:phoneNumber password:password data: data ];
            
            // 点击注册就生成一张图片表
            [dbManager  saveId: phoneNumber];
            //延迟1秒
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [temp hideKeyBoard];
                
                //登录成功后,清除上一个账号的残留物,发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:removeDataWhenExit object:nil];
                
                //登录成功后，进行传值
                //self.passIsLogin(YES);
                if([temp.delegate respondsToSelector:@selector(passIsLogin:)]){
                    [temp.delegate  passIsLogin:YES];
                }else{
                    //NSLog(@"1");
                    [temp.navigationController popToRootViewControllerAnimated:YES];
                }
            });
        }
    };
    
    //失败
    _HTTPManagerInstance.passErrorOfLoginValidate = ^(NSError *error){
        [super showFailureHUD:@"服务器内部出错" hideTime :2.0f];
    };
    
}

#pragma  mark LoginUIViewDelegate  点击忘记密码之行此代理
-(void) jumpToSettingNewPassword
{
    pushToViewControllerAndTarget(self, SettingNewPsswordViewController, self.settingNewPasswordView);
}


#pragma  mark -  获取验证码时  进行倒计时
-(void) timerStart
{
    _timeNumber ++;
    if (_timeNumber < 60) {
        [self.button setTitle:[NSString stringWithFormat:@"%is",60 - _timeNumber] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.button.userInteractionEnabled = NO;
        [self performSelector:@selector(timerStart) withObject:nil afterDelay:1];
    }else{
        _timeNumber = 0;
        self.button.userInteractionEnabled = YES;
        NSString *_verifystr=[NSString stringWithFormat:@"验证码"];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.button setTitle:_verifystr forState:UIControlStateNormal];
    }
    
}






- (IBAction)closeController:(UIButton *)sender {
    //跳转    直接跳转到根
    //[self.navigationController  popToRootViewControllerAnimated:YES];
    [self  exitApplication];
}


-(void)  exitApplication
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [UIView  animateWithDuration:0 animations:^{
        DBManager * dbManager = [DBManager sharedInstance];
        //清除数据库中所有数据
        [dbManager deleteIndividual];
        [dbManager  deleteImageData];
        
        window.alpha = 0;
    } completion:^(BOOL finished) {
        exit(0);
    }];
}


#pragma  mark - 懒加载
-(LoginUIView *)loginUiView
{
    if(!_loginUiView){
        LoginUIView * loginView = [[[NSBundle  mainBundle] loadNibNamed:@"LoginUIView" owner:nil options:nil] lastObject];
        loginView.x =  self.switchView.x;
        loginView.width = self.switchView.width;
        self.loginUiView =loginView;
    }
    return  _loginUiView;
}
-(RegisterUIView *)registerUiView
{
    if(!_registerUiView){
        RegisterUIView * registerView = [[[NSBundle  mainBundle] loadNibNamed:@"RegisterUIView" owner:nil options:nil] lastObject];
        registerView.x = self.switchView.x;
        registerView.width = self.switchView.width;
        self.registerUiView = registerView;
    }
    return  _registerUiView;
}

-(SettingNewPsswordViewController *)settingNewPasswordView
{
    if(!_settingNewPasswordView){
        SettingNewPsswordViewController * settingNewPassword  = [[SettingNewPsswordViewController alloc] init];
        
        self.settingNewPasswordView = settingNewPassword;
    }
    return _settingNewPasswordView;
}

-(HTTPManagerOfMine *)HTTPManagerInstance{
    if (_HTTPManagerInstance == nil) {
        _HTTPManagerInstance = [HTTPManagerOfMine sharedHTTPManagerOfMine];
    }
    return _HTTPManagerInstance;
}

#pragma mark - viewWillDisappear
- (void)viewWillDisappear: (BOOL)animated
{
    [super  viewWillDisappear:animated];
    [self.navigationController  setNavigationBarHidden:NO animated:NO];
    
}


#pragma mark - dealloc
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //初始化
    [self.loginUiView  initLoginUiView];
}


@end
