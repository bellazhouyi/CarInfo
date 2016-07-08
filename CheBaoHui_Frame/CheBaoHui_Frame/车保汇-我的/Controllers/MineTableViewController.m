//
//  MineTableViewController.m
//  Template_Joker
//
//  Created by Bella on 16/1/11.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MineTableViewController.h"
#import "MineHeaderView.h"
#import "MineItemModel.h"
#import "MineSectionModel.h"
#import "MineViewCell.h"
#import "MineDimensionCodeViewController.h"
#import "UIView+Extension.h"
#import "MineInformationViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MineBrokerageViewController.h"
#import "MineMessageViewController.h"
#import "MineSettingViewController.h"
#import "Individual.h"
#import "DBManager.h"
#import "RegisterViewController.h"
#import "ResultModel.h"
#import "DataModel.h"
#import "MJExtension.h"




@interface MineTableViewController ()

@property (nonatomic , strong) NSArray * sectionArray; /**< section模型数组*/

/**
 *  状态栏的view
 */
@property (nonatomic , strong) UIView *   statusBarView;

/**
 *  mineHeader
 */
@property (nonatomic , strong) MineHeaderView * mineHeaderView;


/**
 *  我的佣金
 */
@property (nonatomic , strong) MineBrokerageViewController *  mineBrokerageViewController;


@property (nonatomic , strong) MineInformationViewController * mineInformationViewController;;


/**
 *  我的二维码
 */
@property (nonatomic , strong) MineDimensionCodeViewController * mineDimensionCodeViewController;

/**
 *  我的设置
 */
@property (nonatomic,strong) MineSettingViewController * mineSettingViewController;


/**
 *  左侧bar
 */
@property (nonatomic , strong) UIBarButtonItem * leftItemBar;


@property(nonatomic,strong) HTTPManagerOfMine *HTTPManager;


@end

@implementation MineTableViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma  mark - 跳转到我的资料
-(void) mineInformation
{
    //读取数据库
    DBManager * dbManager  = [DBManager  sharedInstance];
    Individual * individual =  [dbManager selectIndividual];
    
    if(individual){
        [self.navigationController  setNavigationBarHidden:NO animated:NO];
        //PUSH到控制器
        pushToViewControllerAndTarget(self,MineInformationViewController, self.mineInformationViewController);
    }else{
        //如果发现数据库中没有 ,就跳转到登录界面
        RegisterViewController * registerView = [[RegisterViewController alloc] init];
        pushToViewControllerAndTarget(self,RegisterViewController, registerView);
        
    }
}


#pragma mark - 设置cell初始值
-(void)  setupSections
{
    MineItemModel * mineDimensionCode = [[MineItemModel alloc] init];
    mineDimensionCode.funcName = @"我的二维码";
    mineDimensionCode.img =  [UIImage  imageNamed:@"icon-list01"];
    mineDimensionCode.accessoryType = MineAccessoryTypeDisclosureIndicator;
    mineDimensionCode.executeCode = ^{
        self.mineDimensionCodeViewController.navigationItem.leftBarButtonItem = self.leftItemBar;
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        pushToViewControllerAndTarget(self,MineDimensionCodeViewController, self.mineDimensionCodeViewController);
    };
    
    MineItemModel * mineCommission =[[MineItemModel alloc] init];
    mineCommission.funcName = @"我的佣金";
    mineCommission.img =  [UIImage  imageNamed:@"icon-list01"];
    mineCommission.accessoryType = MineAccessoryTypeDisclosureIndicator;
    
    __weak typeof(self) temp = self;
    mineCommission.executeCode = ^{
        
        //读取数据库
        DBManager *dbManager  = [DBManager  sharedInstance];
        Individual *individual =  [dbManager selectIndividual];
        
        [temp.HTTPManager GetBusinessUserByIdWithId:individual.individualId];
        
        //调接口 得到数据
        _HTTPManager.passResponseObjectOfGetBusinessUserById = ^(id responseObject){
            ResultModel * result =  [ResultModel  mj_objectWithKeyValues: responseObject];
            DataModel *  data = [result data];
            temp.mineBrokerageViewController.data = data;
            temp.mineBrokerageViewController.navigationItem.leftBarButtonItem = temp.leftItemBar;
            [temp.navigationController  setNavigationBarHidden:NO animated:NO];
            pushToViewControllerAndTarget(temp,MineBrokerageViewController, temp.mineBrokerageViewController);
        };
        
        //调接口 失败
        _HTTPManager.passErrorOfGetBusinessUserById = ^(NSError *error){
            
        };
        
    };
    
    
    MineItemModel  *  mineMessage = [[MineItemModel alloc] init];
    mineMessage.funcName = @"我的消息";
    mineMessage.img =  [UIImage  imageNamed:@"icon-list01"];
    mineMessage.accessoryType = MineAccessoryTypeDisclosureIndicator;
    mineMessage.executeCode = ^{
        MineMessageViewController * mineMessage = [[MineMessageViewController alloc] init];
        mineMessage.title = @"我的消息";
        mineMessage.navigationItem.leftBarButtonItem = self.leftItemBar;
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        pushToViewControllerAndTarget(self,MineMessageViewController, mineMessage);
    };
    
    MineItemModel * mineSetting = [[MineItemModel alloc] init];
    mineSetting.funcName = @"设置";
    mineSetting.img =  [UIImage  imageNamed:@"icon-list01"];
    mineSetting.accessoryType   = MineAccessoryTypeDisclosureIndicator;
    mineSetting.executeCode = ^{
        //在这里进行判断,如果没有登录 就跳到登录界面 ,  已经登录就跳到设置界面
        DBManager * dbManager = [DBManager sharedInstance];
        Individual * individual =  [dbManager selectIndividual];
        
        if(individual){
            self.mineSettingViewController.navigationItem.leftBarButtonItem = self.leftItemBar;
            [self.navigationController  setNavigationBarHidden:NO animated:NO];
            pushToViewControllerAndTarget(self,MineSettingViewController, self.mineSettingViewController)
        }else{
            RegisterViewController * registerView = [[RegisterViewController alloc] init];
            [self.navigationController  setNavigationBarHidden:YES animated:YES];
            pushToViewControllerAndTarget(self,RegisterViewController, registerView)
        }
    };
    MineSectionModel * section1 = [[MineSectionModel alloc] init];
    section1.sectionHeaderHeight = 0;
    section1.itemArray = @[mineDimensionCode , mineCommission , mineMessage,  mineSetting];
    self.sectionArray  = @[section1];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MineSectionModel * sectionModel =  self.sectionArray [section];
    return  sectionModel.itemArray.count;
}

-(UITableViewCell * ) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //id
    static  NSString *  ID = @"ID";
    // 获取组
    MineSectionModel * sectionModel = self.sectionArray[indexPath.section];
    //得到组中的item
    MineItemModel *  itemModel = sectionModel.itemArray[indexPath.row];
    MineViewCell *  cell =  [tableView dequeueReusableCellWithIdentifier: ID];
    if(!cell){
        cell = [[MineViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:ID];
    }
    //设置选中cell的时候选中为none
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item =  itemModel;
    return  cell;
}


-(CGFloat)  tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    MineSectionModel * sectionModel = self.sectionArray[section];
    return  sectionModel.sectionHeaderHeight;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES ];
    MineSectionModel * sectionModel =  self.sectionArray[indexPath.section];
    MineItemModel * item=   sectionModel.itemArray[indexPath.row];
    if(item.executeCode){
        item.executeCode();
    }
}

#pragma mark - UITableView处理section的不悬浮，禁止section停留的方法，主要是这段代码
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    MineSectionModel * sectionModel = [self.sectionArray  firstObject];
    CGFloat sectionHeaderHeight = sectionModel.sectionHeaderHeight;
    if(scrollView.contentOffset .y <= sectionHeaderHeight  && scrollView.contentOffset.y >=0){
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else if(scrollView.contentOffset.y>=sectionHeaderHeight){
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}



-(UIView *)statusBarView
{
    if(!_statusBarView){
        UIView * uiview =  [[UIView  alloc] init];
        uiview.backgroundColor =ColorFromRGB(30, 141, 207) ;
        uiview.width = self.view.width;
        uiview.height = 20;
        uiview.y = -20;
        [self.view addSubview: uiview];
        self.statusBarView = uiview;
    }
    return  _statusBarView;
    
}

#pragma  mark - 懒加载
#pragma mark -- HTTPManager
-(HTTPManagerOfMine *)HTTPManager{
    if (_HTTPManager == nil) {
        _HTTPManager = [HTTPManagerOfMine sharedHTTPManagerOfMine];
    }
    return _HTTPManager;
}

#pragma mark -- 我的佣金
-(MineBrokerageViewController *)mineBrokerageViewController
{
    if(!_mineBrokerageViewController){
        MineBrokerageViewController * mineBrokerageView  = [[MineBrokerageViewController alloc] init];
        mineBrokerageView.title = @"我的佣金";
        self.mineBrokerageViewController = mineBrokerageView;
    }
    return  _mineBrokerageViewController;
}

#pragma mark -- 我的二维码
-(MineDimensionCodeViewController *)mineDimensionCodeViewController{
    
    if(!_mineDimensionCodeViewController){
        MineDimensionCodeViewController * mineDimestion = [[MineDimensionCodeViewController alloc] init];
        mineDimestion.title = @"我的二维码";
        self.mineDimensionCodeViewController = mineDimestion;
    }
    return  _mineDimensionCodeViewController;
}


#pragma mark -- 设置
-(MineSettingViewController *)mineSettingViewController
{
    if(!_mineSettingViewController){
        MineSettingViewController * mineSetting = [[MineSettingViewController alloc] init];
        mineSetting.title = @"设置";
        self.mineSettingViewController = mineSetting;
        
    }
    return  _mineSettingViewController;
}


#pragma mark -- 头像 getter方法
-(MineHeaderView *)mineHeaderView
{
    if(!_mineHeaderView){
        MineHeaderView * headerView = [[[NSBundle mainBundle] loadNibNamed:@"MineHeaderView" owner:nil options:nil] lastObject];
        
        self.mineHeaderView =  headerView;
    }
    return  _mineHeaderView;
}

#pragma mark -- 左侧按钮
-(UIBarButtonItem *)leftItemBar
{
    if(!_leftItemBar){
        UIBarButtonItem * leftItemBar = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"header_back" hightImage:@""];
        self.leftItemBar = leftItemBar;
    }
    return  _leftItemBar;
}

#pragma mark -- 我的资料
-(MineInformationViewController *)mineInformationViewController
{
    if(nil == _mineInformationViewController){
        MineInformationViewController *  mineInformationViewController = [[MineInformationViewController alloc] init];
        mineInformationViewController.title = @"我的资料";
        mineInformationViewController.navigationItem.leftBarButtonItem = self.leftItemBar;
        
        _mineInformationViewController = mineInformationViewController;
    }
    
    return _mineInformationViewController;
}


#pragma  mark - 返回
-(void) back
{
    [self.navigationController  popViewControllerAnimated:YES];
}




#pragma mark - 初始化 头像
-(void) initHeaderView
{
    
    [self.mineHeaderView initMineHeaderView];
    
    self.tableView.tableHeaderView = self.mineHeaderView ;
    
    //点击头视图Button 的响应事件
    [self.mineHeaderView  addTarget: self action:@selector(mineInformation)];
}

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController  setNavigationBarHidden:YES animated:NO];
    
    [self initHeaderView];
    
    [self statusBarView];
    
    [self  setupSections];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.tableView.scrollEnabled = NO;
}



@end
