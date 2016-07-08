//
//  BrokerageListViewController.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/26.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BrokerageListViewController.h"
#import "MineItemModel.h"
#import "MineSectionModel.h"
#import "MineViewCell.h"
#import "BrokerageListCell.h"
#import "DBManager.h"
#import "Individual.h"
#import "ResultModel.h"
#import "DataModel.h"
#import "MJExtension.h"
#import "UIBarButtonItem+Extension.h"
#import "BrokerageListModel.h"

#define GlobalColor  ColorFromRGB(59, 158, 220)
#define  GlobalFontSize  16

@interface BrokerageListViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

/**
 *  线条scroll
 */
@property(nonatomic,strong)UIScrollView*lineScrollView;

/**
 *tableviewscroll
 */
@property(nonatomic,strong)UIScrollView* tableViewscrview;
/**
 * 收入
 */
@property(nonatomic,strong) UITableView * incomeTableview;

/**
 * 审核
 */
@property (nonatomic , strong) UITableView * examineTableView;

/**
 *   提现
 */
@property(nonatomic,strong)UITableView *  withdrawCashtableview;

@property (nonatomic , strong) NSArray *  incomeArray; /**< section模型数组*/

@property (nonatomic , strong) NSArray *  withdrawCashArray; /**< section模型数组*/

@property (nonatomic , strong) NSArray * examineArray;


/**
 *  左侧bar
 */
@property (nonatomic , strong) UIBarButtonItem * leftItemBar;


@property(nonatomic,strong) HTTPManagerOfMine *HTTPManagerInstance;

@end

@implementation BrokerageListViewController

{
    UIButton*tembtn;
    NSMutableArray*labArr;
    NSMutableArray*btnArr;
    UIPageControl* page;
    NSMutableArray*imgarr;
    CGRect temRect;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)initBrokerage
{
    [self incomeData];
    [self withdrawCashData];
    [self examineData];
    
}
/**
 * scroollview
 */
-(void) creatScrollview
{
    NSArray*arr=@[@"收入",@"审核",@"提现"];
    NSInteger  count =  arr.count;
    
    for (int i=0; i<count; i++) {
        UIButton*btn=[[UIButton alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/3, 10, SCREEN_WIDTH/3, 40)];
        btn.tag=i;
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:GlobalFontSize];
        [btnArr addObject:btn];
        if (i==0) {
            [btn setTitleColor:GlobalColor forState:UIControlStateNormal];
            tembtn=btn;
            temRect=btn.frame;
        } else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    _lineScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(temRect), SCREEN_WIDTH/3, 2)];
    [self.view addSubview:_lineScrollView];
    _lineScrollView.backgroundColor=GlobalColor;
    _lineScrollView.delegate=self;
    _lineScrollView.contentSize=CGSizeMake(SCREEN_WIDTH*2, 2);
    _lineScrollView.showsHorizontalScrollIndicator=NO;
    _lineScrollView.showsVerticalScrollIndicator=NO;
    
    _tableViewscrview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_lineScrollView.frame),SCREEN_WIDTH , SCREEN_HEIGHT-CGRectGetMaxY(_lineScrollView.frame))];
    [self.view addSubview:_tableViewscrview];
    _tableViewscrview.delegate=self;
    page=[[UIPageControl alloc]initWithFrame:CGRectZero];
    page.numberOfPages=3;
    page.currentPage=0;
    _tableViewscrview.pagingEnabled=YES;
    [_tableViewscrview addSubview:page];
    _tableViewscrview.showsHorizontalScrollIndicator=NO;
    _tableViewscrview.showsVerticalScrollIndicator=NO;
    _tableViewscrview.contentSize=CGSizeMake(SCREEN_WIDTH*3,SCREEN_HEIGHT/2);
}


#pragma mark--实时监听滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==_tableViewscrview) {
        _lineScrollView.contentOffset=CGPointMake(_tableViewscrview.contentOffset.x/3, 0);
        _lineScrollView.frame=CGRectMake(_tableViewscrview.contentOffset.x/3, 50, SCREEN_WIDTH/3, 2);
    }
}


#pragma mark--停止滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==_tableViewscrview) {
        int i=_tableViewscrview.contentOffset.x/SCREEN_WIDTH;
        UIButton*btn=btnArr[i];
        [tembtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:GlobalColor forState:UIControlStateNormal];
        tembtn=btn;
    }
    
}


#pragma mark--文字点击事件
-(void)btn_clicked:(UIButton*)btn
{
    [tembtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:GlobalColor forState:UIControlStateNormal];
    tembtn=btn;
    if (btn.tag==0) {//1
        [_tableViewscrview setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    if (btn.tag==1) {//2
        [_tableViewscrview setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    }
    if (btn.tag==2) {//3
        [_tableViewscrview setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
    }
}



/**
 * 收入
 */
-(UITableView *)incomeTableview
{
    if(!_incomeTableview){
        _incomeTableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(_tableViewscrview.frame)) style:UITableViewStylePlain];
        
        [_incomeTableview setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        _incomeTableview.separatorStyle =UITableViewCellSeparatorStyleNone;
        _incomeTableview.backgroundColor=ColorFromRGB(243, 244, 245);
        _incomeTableview.delegate=self;
        _incomeTableview.dataSource=self;
    }
    return  _incomeTableview;
}

/**
 * 提现
 */
-(UITableView *) withdrawCashtableview
{
    if(!_withdrawCashtableview){
        _withdrawCashtableview=[[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, CGRectGetHeight(_tableViewscrview.frame)) style:UITableViewStylePlain];
        [_withdrawCashtableview setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        _withdrawCashtableview.separatorStyle =UITableViewCellSeparatorStyleNone;
        _withdrawCashtableview.backgroundColor=ColorFromRGB(243, 244, 245);
        _withdrawCashtableview.delegate=self;
        _withdrawCashtableview.dataSource=self;
        
    }
    return  _withdrawCashtableview;
}

/**
 * 审核
 */
-(UITableView *)examineTableView
{
    if(!_examineTableView){
        _examineTableView=[[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(_tableViewscrview.frame)) style:UITableViewStylePlain];
        [_examineTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        _examineTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _examineTableView.backgroundColor=ColorFromRGB(243, 244, 245);
        _examineTableView.delegate=self;
        _examineTableView.dataSource=self;
    }
    return _examineTableView;
}



#pragma  mark uitableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger  tempNumber = 0;
    if(tableView == self.incomeTableview){
      tempNumber =   self.incomeArray.count;
    }
    if(tableView == self.examineTableView){
        tempNumber = self.examineArray.count;
    }
    if(tableView == self.withdrawCashtableview){
        tempNumber = self.withdrawCashArray.count;
    }
    return  tempNumber;
}



//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(tableView == self.incomeTableview){
//        MineSectionModel *  insureingSection =  self.incomeSectionArray [indexPath.section];
//        MineItemModel * item =  insureingSection.itemArray[indexPath.row];
//        
//        [self  executeCode:item];
//    }else if(tableView == self.examineTableView){
//        MineSectionModel  *   insuredSection =  self.examineSectionArray[indexPath.section];
//        MineItemModel * item =   insuredSection.itemArray[indexPath.row];
//        [self  executeCode:item];
//    }else  if(tableView == self.withdrawCashtableview){
//        MineSectionModel * stayInsureSection =   self.withdrawCashSectionArray[indexPath.section];
//        MineItemModel * item   =  stayInsureSection.itemArray[indexPath.row];
//        [self  executeCode:item];
//    }
//    
//}

-(CGFloat ) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  18;
}


-(void)   executeCode :(MineItemModel  * ) item
{
    if(item.executeCode){
        item.executeCode();
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*key1=@"key1";
    static NSString*key2=@"key2";
    static NSString*key3=@"key3";
    
    BrokerageListCell  * cell;
    if (tableView==self.incomeTableview) {
        cell=[self.incomeTableview dequeueReusableCellWithIdentifier:key1];
        if (cell==nil) {
            cell=[[BrokerageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key1];
        }
       BrokerageListModel * brokerage =  self.incomeArray[indexPath.row];
        cell.brokerageType = BrokerageTypeIncome;
        cell.descTitle = @"保单佣金";
        cell.brokerage = brokerage;
    }else if (tableView==self.examineTableView) {
        cell=[self.examineTableView dequeueReusableCellWithIdentifier:key2];
        if (cell==nil) {
            cell=[[BrokerageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key2];
        }
        BrokerageListModel * brokerage =  self.examineArray[indexPath.row];
        cell.brokerageType = BrokerageTypeExamine;
        cell.descTitle = @"提现申请";
        cell.brokerage = brokerage;
    }else if (tableView==self.withdrawCashtableview) {
        cell=[self.withdrawCashtableview dequeueReusableCellWithIdentifier:key3];
        if (cell==nil) {
            cell=[[BrokerageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key3];
        }
        BrokerageListModel * brokerage =  self.withdrawCashArray[indexPath.row];
        cell.brokerageType = BrokerageTypeWithdrawCash;
        cell.descTitle = @"提现成功";
        cell.brokerage = brokerage; 
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark 收入
-(void ) incomeData
{
     DBManager * dbManager = [DBManager sharedInstance];
     Individual *  individual = [dbManager selectIndividual];
    
    NSString *pageIndex = @"1";
    NSString *pageSize = @"20";
    NSString *businessUserId = individual.individualId;
    NSString *status = @"1";
    
    //调 佣金明细 接口
    [self.HTTPManagerInstance GetCommissionByBusinessUserIdWithpageIndex:pageIndex pageSize:pageSize businessUserId:businessUserId status:status];
    
    __weak typeof(self) temp = self;
    //成功 获得数据
    _HTTPManagerInstance.passResponseObjectOfGetCommissionByBusinessUserId = ^(id responseObject){
        
        ResultModel * result = [ResultModel mj_objectWithKeyValues:responseObject];
        NSArray * array =  [[result data] Data];
        temp.incomeArray = [BrokerageListModel  mj_objectArrayWithKeyValuesArray:array];
        temp.incomeTableview.rowHeight = 60;
        [temp.tableViewscrview addSubview:temp.incomeTableview];
    };
   
    //失败
    _HTTPManagerInstance.passErrorOfGetCommissionByBusinessUserId = ^(NSError *error){
        
    };

}

#pragma mark -- 审核 初始化数据
-(void)   examineData
{
    DBManager * dbManager = [DBManager sharedInstance];
    Individual *  individual = [dbManager selectIndividual];
    
    NSString *pageIndex = @"1";
    NSString *pageSize = @"10";
    NSString *businessUserId = individual.individualId;
    NSString *status = @"2";
    
    //调 佣金明细 接口
    [self.HTTPManagerInstance GetCommissionByBusinessUserIdWithpageIndex:pageIndex pageSize:pageSize businessUserId:businessUserId status:status];
    
    __weak typeof(self) temp = self;
    
    // 获得数据
    _HTTPManagerInstance.passResponseObjectOfGetCommissionByBusinessUserId = ^(id responseObject){
        ResultModel * result = [ResultModel mj_objectWithKeyValues:responseObject];
        NSArray * array =  [[result data] Data];
        temp.examineArray = [BrokerageListModel  mj_objectArrayWithKeyValuesArray:array];
        temp.examineTableView.rowHeight = 60;
        
        [temp.tableViewscrview addSubview:temp.examineTableView];
    };
    

    //失败
    _HTTPManagerInstance.passErrorOfGetCommissionByBusinessUserId = ^(NSError *error){
        
    };
}

#pragma mark -- 提现
-(void) withdrawCashData
{
    DBManager * dbManager = [DBManager sharedInstance];
    Individual *  individual = [dbManager selectIndividual];
    
    NSString *pageIndex = @"1";
    NSString *pageSize = @"20";
    NSString *businessUserId = individual.individualId;
    NSString *status = @"3";
    
    //调用 佣金明细 接口
    [self.HTTPManagerInstance GetCommissionByBusinessUserIdWithpageIndex:pageIndex pageSize:pageSize businessUserId:businessUserId status:status];
    
    __weak typeof(self) temp = self;
    
    //成功 获得数据
    _HTTPManagerInstance.passResponseObjectOfGetCommissionByBusinessUserId = ^(id responseObject){
        ResultModel * result = [ResultModel mj_objectWithKeyValues:responseObject];
        NSArray * array =  [[result data] Data];
        temp.withdrawCashArray = [BrokerageListModel  mj_objectArrayWithKeyValuesArray:array];
        temp.withdrawCashtableview.rowHeight = 60;
        [temp.tableViewscrview addSubview:temp.withdrawCashtableview];
    };
    
    //失败
    _HTTPManagerInstance.passErrorOfGetCommissionByBusinessUserId = ^(NSError *error){
        
    };
}



-(UIBarButtonItem *)leftItemBar
{
    if(!_leftItemBar){
        UIBarButtonItem * leftItemBar = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"header_back" hightImage:@""];
        self.leftItemBar = leftItemBar;
    }
    return  _leftItemBar;
}

-(void) back
{
    [self.navigationController  popViewControllerAnimated:YES];
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

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    imgarr=[NSMutableArray new];
    labArr=[NSMutableArray new];
    btnArr=[NSMutableArray new];
    temRect=CGRectZero;
    [self creatScrollview];
}

@end
