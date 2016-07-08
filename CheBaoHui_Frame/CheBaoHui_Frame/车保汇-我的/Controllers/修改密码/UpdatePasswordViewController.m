//
//  UpdatePasswordViewController.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "UpdatePasswordViewController.h"
#import "DBManager.h"
#import "Individual.h"
#import "MJExtension.h"
#import "ResultModel.h"

@interface UpdatePasswordViewController ()
/*
 *  旧密码
 */
@property (weak, nonatomic) IBOutlet UITextField *passwordOld;


@property (weak, nonatomic) IBOutlet UITextField *passwordNew;


@property(nonatomic,strong) HTTPManagerOfMine *HTTPManagerInstance;


@end

@implementation UpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置颜色
    self.view.backgroundColor = ColorFromRGB(243, 244, 245);
    //设置右上角buttonItem
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(updateOldPassword)];
    rightButtonItem.tintColor = [UIColor  whiteColor];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self.passwordOld  addTarget:self action:@selector(phoneNumberDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.passwordNew  addTarget:self action:@selector(phoneNumberDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

-(void ) phoneNumberDidChange :(UITextField * ) textField
{
    if(textField ==self.passwordOld){
        [self  textFiledMax: textField];
        
    }else if(textField ==self.passwordNew){
        [self  textFiledMax: textField];
    }
}

/**
 *设置输入的最大值
 */
-(void)textFiledMax :(UITextField * ) textField
{
    if (textField.text.length >=16) {
        textField.text = [textField.text substringToIndex:16];
    }
}


#pragma mark  -- 修改密码
-(void) updateOldPassword
{
    
   DBManager * dbManager =  [DBManager  sharedInstance];
   Individual *  individual = [dbManager selectIndividual];
    
    if(![self.passwordOld.text isEqualToString: individual.password]){
        [super  showFailureHUD:@"旧密码不正确" hideTime:2.0f];
        return;
    }
    
    [self.HTTPManagerInstance ModifyPasswordWithId:individual.individualId passwordOld:self.passwordOld.text passwordNew:self.passwordNew.text];
    
    __weak typeof(self) temp = self;
    
    //接口 数据获得成功
    _HTTPManagerInstance.passResponseObjectOfModifyPassword = ^(id responseObject){
        ResultModel  * result =  [ResultModel  mj_objectWithKeyValues: responseObject];
        if([result.code isEqualToString:@"1"]){
            [super showFailureHUD:result.msg hideTime:2.0f];
        }else{
            [super  showSuccessHUD:result.msg hideTime:2.0f];
            //修改数据库中的密码
            [dbManager  updateIndividual: individual.phoneNumber  passwordNew:temp.passwordNew.text];
            //延迟1秒钟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [temp.navigationController popViewControllerAnimated:YES];
            });
        }
    };
    
    //接口 失败
    _HTTPManagerInstance.passErrorOfModifyPassword = ^(NSError *error){
        
    };
    
}


#pragma mark -- 懒加载
-(HTTPManagerOfMine *)HTTPManagerInstance{
    if (_HTTPManagerInstance == nil) {
        _HTTPManagerInstance = [HTTPManagerOfMine sharedHTTPManagerOfMine];
    }
    return _HTTPManagerInstance;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
