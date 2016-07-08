//
//  MineSettingViewController.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MineSettingViewController.h"
#import "MineItemModel.h"
#import "MineSectionModel.h"
#import "MineViewCell.h"
#import "AboutCompanyViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "RegisterViewController.h"
#import "UpdatePasswordViewController.h"
#import "DBManager.h"
@interface MineSettingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *settingTableView;



@property (nonatomic , strong) NSArray * sectionArray; /**< section模型数组*/


/**
 *  左侧bar
 */
@property (nonatomic , strong) UIBarButtonItem * leftItemBar;



@end

@implementation MineSettingViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
}


-(void) setupSections
{
    //头像
    MineItemModel *  messagePush = [[MineItemModel alloc] init];
    messagePush.funcName = @"消息推送";
    messagePush.accessoryType = MineAccessoryTypeSwitch;
    
    MineSectionModel * section1  = [[MineSectionModel alloc] init];
    section1.sectionHeaderHeight = 18;
    section1.itemArray = @[messagePush];
    
    MineItemModel * updatePassword = [[MineItemModel alloc] init];
    updatePassword.funcName = @"修改密码";
    updatePassword.accessoryType = MineAccessoryTypeDisclosureIndicator;
    updatePassword.executeCode = ^{
        UpdatePasswordViewController * updatePassowrdView = [[UpdatePasswordViewController alloc] init];
        updatePassowrdView.title = @"修改密码";
        
        pushToViewControllerAndTarget(self, UpdatePasswordViewController, updatePassowrdView);
    };
    //关于华瑞
    MineItemModel  * aboutCompany = [[MineItemModel  alloc] init ];
    aboutCompany.funcName = @"关于华瑞";
    aboutCompany.accessoryType = MineAccessoryTypeDisclosureIndicator;
    aboutCompany.executeCode =^{
        AboutCompanyViewController * aboutCompanyView = [[AboutCompanyViewController alloc] init];
        aboutCompanyView.title = @"关于";
        aboutCompanyView.navigationItem.leftBarButtonItem =  self.leftItemBar;
        pushToViewControllerAndTarget(self, AboutCompanyViewController, aboutCompanyView);
    };
    MineSectionModel * section2 =  [[MineSectionModel alloc] init];
    section2.sectionHeaderHeight = 18;
    section2.itemArray = @[updatePassword , aboutCompany];
    MineItemModel * exit = [[MineItemModel alloc] init];
    exit.funcName = @"退出登陆";
    exit.accessoryType = MineAccessoryTypeCenter;
    MineSectionModel * section3 = [[MineSectionModel alloc] init];
    exit.executeCode  = ^{
        //点击退出就清除本地持久化数据
        DBManager  * dbManager = [DBManager  sharedInstance];
        //删除数据
        [dbManager  deleteIndividual];
        
        //  点击退出的时候清理数据库
        [dbManager deleteImageData];
        
         RegisterViewController * registerView = [[RegisterViewController alloc] init];
        
        [self.navigationController  setNavigationBarHidden:YES animated:YES];
        pushToViewControllerAndTarget(self, RegisterViewController, registerView);
    };
    section3.sectionHeaderHeight = 18;
    section3.itemArray = @[exit];
    self.sectionArray = @[section1,section2, section3];
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

//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
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




#pragma  mark - 返回
-(void) back
{
    [self.navigationController  popViewControllerAnimated:YES];
}

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.settingTableView.backgroundColor = ColorFromRGB(243, 244, 245);
    //这是表格不能拖动
    self.settingTableView.scrollEnabled = NO;
    [self.settingTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.settingTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self  setupSections];
}

@end
