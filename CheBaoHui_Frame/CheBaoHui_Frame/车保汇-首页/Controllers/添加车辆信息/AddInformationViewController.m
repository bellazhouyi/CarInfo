//
//  AddInformationViewController.m
//  Template_Joker
//
//  Created by Bella on 16/1/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "AddInformationViewController.h"
#import "InsuranceProposalViewController.h"



@interface AddInformationViewController ()<UITextFieldDelegate,UITextViewDelegate>

/**
 *  车架号码的textField
 */
@property (weak, nonatomic) IBOutlet UITextField *frameNumberTextField;


/**
 *  车主姓名textField
 */
@property (weak, nonatomic) IBOutlet UITextField *owerNameTextField;

/**
 *  厂牌型号的textField
 */
@property (weak, nonatomic) IBOutlet UITextField *brandNumberTextField;

/**
 *  发动机号的textField
 */
@property (weak, nonatomic) IBOutlet UITextField *engineNumberTextField;

/**
 *  车辆信息的Button
 */
@property (weak, nonatomic) IBOutlet UIButton *buyDateBtn;


/**
 *  暂存车牌号
 */
@property(nonatomic,strong) NSString *tempLicenseNumber;

/**
 *  隐藏键盘 功能的管理 实例
 */
@property(nonatomic,strong) IQKeyboardReturnKeyHandler *returnKeyHandler;

/**
 *  加载中的 动画显示
 */
@property(nonatomic,strong) GSIndeterminateProgressView *progressView;

@property(nonatomic,strong) CarInfo *tempCarInfo;

@end

@implementation AddInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //输入框跟随键盘自动上下浮
    [self startMove];
}

#pragma mark --输入框跟随键盘自动上下浮
-(void)startMove{
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    self.returnKeyHandler.delegate = self;
}

#pragma mark -- UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == self.owerNameTextField) {
        
        if (![NSString isChinese:textField.text] ) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"只能输入中文" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                textField.clearsOnBeginEditing = YES;
                [textField becomeFirstResponder];
            }];
            
            [alertController addAction:confirm];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 选择日期
- (IBAction)selectDate:(UIButton *)sender {
    
    //隐藏键盘
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    SelectDateView *selectDateView = (SelectDateView *)[[[NSBundle mainBundle] loadNibNamed:@"SelectDateView" owner:nil options:nil] firstObject];
    
    //设置显示位置
    CGFloat height = selectDateView.bounds.size.height;
    CGRect frame ;
    frame.origin.x = 0;
    frame.origin.y = self.view.bounds.size.height - height;
    frame.size.width = self.view.bounds.size.width;
    frame.size.height = height;
    selectDateView.frame = frame;
    
    //设置初始值
    [selectDateView setOriginalViewWithDateString:sender.titleLabel.text];
    
    [self.view addSubview:selectDateView];
    
    //当前日期
    NSString *currentDate = self.buyDateBtn.titleLabel.text;
    
    //回调，得到选择日期
    selectDateView.passDate = ^(NSString *date){
        //判断，若是跟当前日期不一致，则换日期
        if (date != currentDate) {
            [self.buyDateBtn setTitle:date forState:UIControlStateNormal];
        }
    };
}

#pragma mark --跳转到投保方案界面
- (IBAction)toInsuranceProposalVC:(UIButton *)sender {
    
    InsuranceProposalViewController *insuranceProposalVC = [InsuranceProposalViewController new];
    
    HTTPManager *manager = [HTTPManager sharedHTPPManager];
    NSString *cph_no = self.tempLicenseNumber; //车牌号
    NSString *cz_name = self.owerNameTextField.text; //车主姓名
    if (![NSString isChinese:cz_name]) {
        [super showToastHUD:@"车主姓名只能为中文" hideTime:0.4];
        return;
    }
    
    NSString *buy_date = self.buyDateBtn.titleLabel.text; //注册日期
    NSString *xh_code = [self.brandNumberTextField.text removeSpaceAndUpperStr];  //品牌型号
    NSString *fdj_no = [self.engineNumberTextField.text removeSpaceAndUpperStr];  //发动机号
    NSString *cjh_no = self.frameNumberTextField.text; //车架号
    NSString *TransferTime = @""; //过户日期
    
    if (cz_name.length == 0 || xh_code.length == 0 ||fdj_no.length == 0 || cjh_no.length == 0) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"信息不完整" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertControl addAction:action];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else if ([buy_date isEqualToString:@"请选择购买日期   >"]){
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"请输入购买日期" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertControl addAction:action];
        [self presentViewController:alertControl animated:YES completion:nil];
    }
    else{
        [manager addCarInfoWithcph_no:cph_no cz_name:cz_name buy_date:buy_date xh_code:xh_code fdj_no:fdj_no cjh_no:cjh_no TransferTime:TransferTime];
        
        
        GSIndeterminateProgressView *progressView = [[GSIndeterminateProgressView alloc] initWithFrame:CGRectMake(sender.frame.origin.x, sender.center.y + 18 ,
                                                                                                                  sender.frame.size.width, 2)];
        self.progressView = progressView;
        progressView.progressTintColor = [UIColor grayColor];
        progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        sender.userInteractionEnabled = NO;
        [sender setTitle:@"加载中" forState:UIControlStateNormal];
        [self.view addSubview:progressView];
        
        [progressView startAnimating];
        
        __weak typeof(insuranceProposalVC) tempInsuranceProposalVC = insuranceProposalVC;
        manager.passCarInfoInstance = ^(CarInfo *carInfo){
            
            if (nil == carInfo) {
                carInfo = [CarInfo new];
                carInfo.cph_no = cph_no;
                carInfo.cz_name = cz_name;
                carInfo.buy_date = buy_date;
                carInfo.xh_code = xh_code;
                carInfo.fdj_no = fdj_no;
                carInfo.cjh_no = cjh_no;
                carInfo.TransferTime = TransferTime;
                tempInsuranceProposalVC.carInfoInstance = carInfo;
            }else{
                
                if (carInfo.Idcard_No.length == 0) {
                    carInfo.Idcard_No = self.tempCarInfo.Idcard_No;
                }
                
                tempInsuranceProposalVC.carInfoInstance = carInfo;
            }
            
            self.hidesBottomBarWhenPushed = YES;
            //移除加载动画
            [progressView stopAnimating];
            pushToViewControllerAndTarget(self, InsuranceProposalViewController, insuranceProposalVC);
            sender.userInteractionEnabled = YES;
            [sender setTitle:@"确定" forState:UIControlStateNormal];
        };
        //服务器端 没有数据
        manager.passNullMsg_CreateVehicle = ^(){
            CarInfo * carInfo = [CarInfo new];
            carInfo.cph_no = cph_no;
            carInfo.cz_name = cz_name;
            carInfo.buy_date = buy_date;
            carInfo.xh_code = xh_code;
            carInfo.fdj_no = fdj_no;
            carInfo.cjh_no = cjh_no;
            carInfo.TransferTime = TransferTime;
            tempInsuranceProposalVC.carInfoInstance = carInfo;
            
            self.hidesBottomBarWhenPushed = YES;
            //移除加载动画
            [progressView stopAnimating];
            pushToViewControllerAndTarget(self, InsuranceProposalViewController, insuranceProposalVC);
            sender.userInteractionEnabled = YES;
            [sender setTitle:@"确定" forState:UIControlStateNormal];
        };
        
        
        //内部服务器错误报告
        manager.passErrorCreateVehicleInfo = ^(){
            [GiFHUD showWithMessage:@"网络繁忙,请稍后再试"];
            self.view.alpha = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMinute * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //移除加载动画
                [progressView stopAnimating];
                
                [GiFHUD dismissBiggerFrame];
                
                sender.userInteractionEnabled = YES;
                [sender setTitle:@"确定" forState:UIControlStateNormal];
                
                self.view.alpha = 1;
            });
        };
        
    }
    
}


#pragma mark -- frameNumber的setter方法
-(void)setFrameNumber:(NSString *)frameNumber{
    self.frameNumberTextField.text = frameNumber;
}

-(void)setLicenseNumber:(NSString *)licenseNumber{
    self.tempLicenseNumber = licenseNumber;
}


-(void)setCarInfo:(CarInfo *)carInfo{
    
    self.tempCarInfo = carInfo;
    
    self.owerNameTextField.text = carInfo.cz_name;
    self.brandNumberTextField.text = carInfo.xh_code;
    self.engineNumberTextField.text = carInfo.fdj_no;
    
    if (nil == carInfo.buy_date) {
        [self.buyDateBtn setTitle:@"请选择购买日期   >" forState:UIControlStateNormal];
    }else{
        [self.buyDateBtn setTitle:[carInfo.buy_date substringToIndex:10]  forState:UIControlStateNormal];
    }
}

#pragma mark - viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.owerNameTextField.delegate = nil;
}


@end
