//
//  AuthenticationingViewController.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/25.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "AuthenticationingViewController.h"

#import "AuthenticationingModel.h"
#import "AuthenticationingViewCell.h"
#import "MineSectionModel.h"
#import "DBManager.h"
#import "Individual.h"
#import "ResultModel.h"
#import "MJExtension.h"
#import "DataModel.h"

@interface AuthenticationingViewController ()

@property (nonatomic , strong) NSArray * sectionArray; /**< section模型数组*/

@property (weak, nonatomic) IBOutlet UITableView *authenticationTableView;

@end

@implementation AuthenticationingViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
}


-(void) setupSections
{
    AuthenticationingModel * authenticName = [[AuthenticationingModel alloc] init];
    authenticName.funcName = @"真实姓名";
    authenticName.detailText = self.data.Name;
    AuthenticationingModel * identityCardNumber =[[AuthenticationingModel alloc] init];
    identityCardNumber.funcName = @"身份证号码";
    identityCardNumber.detailText = self.data.IdCardNo;
    
    AuthenticationingModel  *  competencyNumber = [[AuthenticationingModel alloc] init];
    competencyNumber.funcName = @"资格证号码";
    competencyNumber.detailText = self.data.QCertificateNo;
    
    AuthenticationingModel * bankCard = [[AuthenticationingModel alloc] init];
    bankCard.funcName = @"银行卡";
    bankCard.detailText =  self.data.BankNo;
    
    MineSectionModel * section1 = [[MineSectionModel alloc] init];
    section1.sectionHeaderHeight = 18;
    section1.itemArray = @[authenticName , identityCardNumber , competencyNumber,bankCard];
    
    //身份证正面
    AuthenticationingModel *identityCardFront = [[AuthenticationingModel alloc] init];
    identityCardFront.funcName = @"身份证正面";
    identityCardFront.detailImageUrl = self.data.IdCardNoPhoto1Url;
    
    MineSectionModel * section2 = [[MineSectionModel alloc] init];
    section2.sectionHeaderHeight = 18;
    section2.itemArray = @[identityCardFront];
    
    //身份证反面
    AuthenticationingModel *identityCardVerso = [[AuthenticationingModel alloc] init];
    identityCardVerso.funcName = @"身份证反面";
    identityCardVerso.detailImageUrl = self.data.IdCardNoPhoto2Url;
    
    MineSectionModel * section3 = [[MineSectionModel alloc] init];
    section3.sectionHeaderHeight = 18;
    section3.itemArray = @[identityCardVerso];
    
    AuthenticationingModel * competencyPage = [[AuthenticationingModel alloc] init];
    competencyPage.funcName = @"资格证内页";
    competencyPage.detailImageUrl = self.data.QCertificatePhotoUrl;
    
    MineSectionModel * section4 = [[MineSectionModel alloc] init];
    section4.sectionHeaderHeight = 18;
    section4.itemArray = @[competencyPage];
    self.sectionArray  = @[section1 , section2,section3, section4];
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
    static  NSString * ID = @"ID";
    // 获取组
    MineSectionModel * sectionModel = self.sectionArray[indexPath.section];
    //得到组中的item
    AuthenticationingModel *  itemModel = sectionModel.itemArray[indexPath.row];
    AuthenticationingViewCell *  cell =  [tableView dequeueReusableCellWithIdentifier: ID];
    if(!cell){
        cell = [[AuthenticationingViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:ID];
    }
    //设置选中cell的时候选中为none
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = itemModel;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    MineSectionModel * sectionModel = self.sectionArray[section];
    return  sectionModel.sectionHeaderHeight;
}


#pragma mark --  uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
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


#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.authenticationTableView.backgroundColor = ColorFromRGB(243, 244, 245);
    //这是表格不能拖动
    self.authenticationTableView.scrollEnabled = NO;
    [self.authenticationTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.authenticationTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    [self  setupSections];
}

@end
