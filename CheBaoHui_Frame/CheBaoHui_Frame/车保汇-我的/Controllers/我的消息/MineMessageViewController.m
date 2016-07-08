//
//  MineMessageViewController.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MineMessageViewController.h"
#import "MineItemModel.h"
#import "MineSectionModel.h"
#import "MineViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "CustomRefreshHeader.h"

static const CGFloat MJDuration = 2.0;


@interface MineMessageViewController ()

@property (weak, nonatomic) IBOutlet UITableView *messageTableView;

@property (nonatomic , strong) NSArray * sectionArray; /**< section模型数组*/


@end

@implementation MineMessageViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
   
}



- (void)loadNewData
{
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        NSLog(@"%d",i);
    }
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.messageTableView reloadData];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.messageTableView.mj_header endRefreshing];
    });
}


-(void) setupSections
{
    MineItemModel *  message1 = [[MineItemModel alloc] init];
    message1.funcName = @"新消息1";
    message1.accessoryType = MineAccessoryTypeDisclosureIndicator;
    MineSectionModel * section1 = [[MineSectionModel alloc] init];
    section1.itemArray = @[message1];
    self.sectionArray = @[section1];
}


#pragma  mark  UITableView  代理
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.sectionArray.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MineSectionModel  * sectionModel =   self.sectionArray[section];
    return   sectionModel.itemArray.count;
}


-(UITableViewCell * ) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *  ID = @"ID";
    MineViewCell * cell =    [tableView  dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[MineViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    //获取组
    MineSectionModel *  sectionModel = self.sectionArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.item = sectionModel.itemArray[indexPath.row];
    return cell;
}

-(CGFloat)  tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    MineSectionModel  * sectionModel =   self.sectionArray[section];
    return  sectionModel.sectionHeaderHeight;
}


-(void )tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CustomRefreshHeader *  header = [CustomRefreshHeader  headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    header.stateLabel.hidden = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    self.messageTableView.mj_header = header;
    
    self.messageTableView.backgroundColor = ColorFromRGB(243, 244, 245);
    [self.messageTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.messageTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self  setupSections];
}

@end
