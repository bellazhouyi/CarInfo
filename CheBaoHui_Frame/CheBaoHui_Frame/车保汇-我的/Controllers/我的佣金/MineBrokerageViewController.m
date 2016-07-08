//
//  MineBrokerageViewController.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MineBrokerageViewController.h"
#import "AuthenticationViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "DataModel.h"
#import "DBManager.h"
#import "Individual.h"
#import "AuthenticationingViewController.h"
#import "ResultModel.h"
#import "DataModel.h"
#import "MJExtension.h"

#import "BrokerageListViewController.h"



@interface MineBrokerageViewController ()


@property (weak, nonatomic) IBOutlet UIButton *authenticationButton;

@property (weak, nonatomic ) IBOutlet  UIButton * authenticationButton1;


@property (weak, nonatomic) IBOutlet UIButton *withdrawsCashButton;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;

/**
 *认证
 */
- (IBAction)authenticationClick:(UIButton *)sender;
/**
 *  取现
 */
- (IBAction)withdrawsCash:(UIButton *)sender;

/**
 *  左侧bar
 */
@property (nonatomic , strong) UIBarButtonItem * leftItemBar;

/**
 *  待审核和审核失败
 */
@property(nonatomic , strong) AuthenticationViewController *  authenticationViewController;


@property (nonatomic , strong) AuthenticationingViewController * authenticationingViewController;
/**
 *  佣金明晰
 */
@property (nonatomic , strong) BrokerageListViewController  * brokerageListViewController;


@property(nonatomic,strong) HTTPManagerOfMine *HTTPManagerInstance;


@end


@implementation MineBrokerageViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * rightItemBar = [[UIBarButtonItem  alloc] initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(brokerageList)];
    rightItemBar.tintColor = [UIColor  whiteColor];
    rightItemBar.title = @"明细";
    self.navigationItem.rightBarButtonItem = rightItemBar;
}

-(void) setData:(DataModel *)data
{
    _data = data;
    
    [self getCommissionByBusinessWithUserId:data.Id];
}

-(void) getCommissionByBusinessWithUserId:(NSString * ) userID
{
    //调用 我的佣金 接口
    [self.HTTPManagerInstance GetCommissionAmountWithbusinessUserId:userID status:@"1"];
    
    __weak typeof(self) temp = self;
    
    //成功 获得数据
    _HTTPManagerInstance.passResponseObjectOfGetCommissionAmount = ^(id responseObject){
        ResultModel * result =  [ResultModel  mj_objectWithKeyValues: responseObject];
        
        temp.commissionLabel.text =  [NSString  stringWithFormat:@"¥ %@",result.strData];
    };
    
    //失败
    _HTTPManagerInstance.passErrorOfGetCommissionAmount = ^(NSError *error){
        
    };
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super  viewWillAppear: animated];
    self.authenticationButton.hidden = NO;
    self.authenticationButton1.hidden = NO;
    if ([self.data.Status isEqualToString:@"0"]) {
        self.withdrawsCashButton.enabled = NO;
    }else if([self.data.Status isEqualToString:@"1"]){
        self.withdrawsCashButton.enabled = NO;
    }else if([self.data.Status  isEqualToString:@"2"]){
        self.authenticationButton.hidden = YES;
        self.authenticationButton1.hidden = YES;
        self.withdrawsCashButton.enabled = YES;
    }else if([self.data.Status isEqualToString:@"3"]){
        self.withdrawsCashButton.enabled = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)authenticationClick:(UIButton *)sender
{

    //读取数据库
    DBManager * dbManager  = [DBManager  sharedInstance];
    Individual * individual =  [dbManager selectIndividual];
    
    __weak typeof(self) temp = self;
    //调用 GetBusinessUserById接口
    [self.HTTPManagerInstance GetBusinessUserByIdWithId:individual.individualId];
    
    if([ self.data.Status isEqualToString:@"0"]  || [self.data.Status isEqualToString:@"3"]  ){  //待审核
        
        
        //成功 获得数据
        _HTTPManagerInstance.passResponseObjectOfGetBusinessUserById = ^(id responseObject){
            ResultModel * result =  [ResultModel  mj_objectWithKeyValues: responseObject];
            DataModel *  data = [result data];
            temp.authenticationViewController.data = data;
            if([temp.data.Status isEqualToString:@"0"]){
                temp.authenticationViewController.title = @"实名认证";
            }else{
                temp.authenticationViewController.title = @"认证失败";
            }
            
            [temp.navigationController  setNavigationBarHidden:NO];
            pushToViewControllerAndTarget(temp, AuthenticationViewController, temp.authenticationViewController);
        };
        
        //失败
        _HTTPManagerInstance.passErrorOfGetBusinessUserById = ^(NSError *error){
            
        };
        
    }else if([ self.data.Status  isEqualToString:@"1"] || [self.data.Status  isEqualToString:@"2" ]){//审核中
        
        // 成功 获得数据
        _HTTPManagerInstance.passResponseObjectOfGetBusinessUserById = ^(id responseObject){
            ResultModel * result =  [ResultModel  mj_objectWithKeyValues: responseObject];
            DataModel *  data = [result data];
            if([temp.data.Status isEqualToString:@"1"]){
                temp.authenticationingViewController.title = @"认证中";
            }else{
                temp.authenticationingViewController.title = @"认证成功";
            }
            temp.authenticationingViewController.data = data;
            temp.authenticationingViewController.navigationItem.leftBarButtonItem = temp.leftItemBar;
            [temp.navigationController  setNavigationBarHidden:NO];
            pushToViewControllerAndTarget(temp, AuthenticationingViewController, temp.authenticationingViewController);
        };
      
        //失败
        _HTTPManagerInstance.passErrorOfGetBusinessUserById = ^(NSError *error){
            
        };
    
    }
  
    
    
}

- (IBAction)withdrawsCash:(UIButton *)sender {
    [super showToastHUD:@"没钱" hideTime:2.0f];
}

/**
 * 佣金明细
 */
-(void) brokerageList
{
    self.brokerageListViewController.title = @"佣金明细";
    self.brokerageListViewController.navigationItem.leftBarButtonItem = self.leftItemBar;
    
    [self.brokerageListViewController initBrokerage];
    
    pushToViewControllerAndTarget(self, BrokerageListViewController, self.brokerageListViewController);
}


#pragma mark 懒加载
-(AuthenticationingViewController *)authenticationingViewController
{
    if(!_authenticationingViewController){
        AuthenticationingViewController * authenticationingView = [[AuthenticationingViewController alloc] init];
        self.authenticationingViewController = authenticationingView;
    }
    return _authenticationingViewController;
}


-(AuthenticationViewController *)authenticationViewController
{
    if(!_authenticationViewController){
        AuthenticationViewController * authenticationView = [[AuthenticationViewController alloc] init];
        self.authenticationViewController = authenticationView;
    }
    return  _authenticationViewController;
}

/**
 *  明细
 */
-(BrokerageListViewController *)brokerageListViewController
{
    if(!_brokerageListViewController){
        BrokerageListViewController * brokerageListView = [[BrokerageListViewController alloc] init];
        self.brokerageListViewController = brokerageListView;
    }
    return _brokerageListViewController;
}


-(UIBarButtonItem *)leftItemBar
{
    if(!_leftItemBar){
        UIBarButtonItem * leftItemBar = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"header_back" hightImage:@""];
        self.leftItemBar = leftItemBar;
    }
    return  _leftItemBar;
}

-(HTTPManagerOfMine *)HTTPManagerInstance{
    if (_HTTPManagerInstance == nil) {
        _HTTPManagerInstance = [HTTPManagerOfMine sharedHTTPManagerOfMine];
    }
    return _HTTPManagerInstance;
}

-(void) back
{
    [self.navigationController  popViewControllerAnimated:YES];
}

@end
