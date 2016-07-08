//
//  CarInsuranceViewController.m
//  Template_Joker
//
//  Created by Bella on 16/1/11.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "CarInsuranceViewController.h"
#import "AddCarInfoViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MineItemModel.h"
#import "MineSectionModel.h"
#import "MineViewCell.h"
#import "CustomRefreshHeader.h"
#import "DetailsViewController.h"
#import "WarrantyModel.h"
#import "DetailModel.h"
#import "DetailSectionModel.h"
#import "InsureFooterView.h"
#import "AddCarModel.h"
#import "AddCarSectionModel.h"
#import "DBManager.h"
#import "Individual.h"

#import "MJExtension.h"
#import "PolicyModel.h"
#import "PolicyListsModel.h"
#import "UIImage+Color.h"
#import "DateTools.h"

#import "InsuredMineItemModel.h"
#import "StayInsureMineItemModel.h"
#import "InsureingMineItemModel.h"
#import "UIView+Extension.h"

#import "HTTPManagerOfInsurance.h"

#define GlobalColor  ColorFromRGB(59, 158, 220)
#define  GlobalFontSize  16
static const CGFloat MJDuration = 2.0;

@interface CarInsuranceViewController ()<UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource>


@property (nonatomic , strong) NSArray *  insureingSectionArray; /**< section模型数组*/


@property (nonatomic , strong) NSArray *  stayInsureSectionArray; /**< section模型数组*/

@property (nonatomic , strong) NSArray *  insuredSectionArray; /**< section模型数组*/

//装table的view
@property (weak, nonatomic) IBOutlet UIView *tableCellView;

/**
 *  线条scroll
 */
@property(nonatomic,strong)UIScrollView*lineScrollView;

/**
 *tableviewscroll
 */
@property(nonatomic,strong)UIScrollView* tableViewscrview;
/**
 * 投保中  table视图1
 */
@property(nonatomic,strong) UITableView * insureingTableview;
/**
 *   待投保   table视图2
 */
@property(nonatomic,strong)UITableView *  stayInsuretableview;
/**
 *  已投保    table视图3
 */
@property(nonatomic,strong)UITableView * insuredTableview;

/**
 *车信息
 */
@property (nonatomic , strong) AddCarInfoViewController * addCarInfoView;

/**
 *  左侧bar
 */
@property (nonatomic , strong) UIBarButtonItem * leftItemBar;


/**
 *  网络请求的单例
 */
@property(nonatomic, strong) HTTPManagerOfInsurance *HTTPManager;;



- (IBAction)addCarInfo:(UIButton *)sender;

@end

@implementation CarInsuranceViewController
{
    UIButton *tembtn;
    NSMutableArray *labMutableArray;
    NSMutableArray *btnMutableArray;
    UIPageControl * pageController;
    NSMutableArray *imgMutableArray;
    CGRect temRect;
    
    
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - 加载数据
-(void)loadData{
    
    // 每次进入loadData  就remove一下当前视图
    [_lineScrollView  removeFromSuperview];
    
    [self  insureingDataWithStatus:@"投保中"];
    
    imgMutableArray = [NSMutableArray new];
    labMutableArray = [NSMutableArray new];
    btnMutableArray = [NSMutableArray new];
    
    temRect = CGRectZero;
    
    [self creatScrollview];
    [self creatTableview];
    
    [self refresh];
    
    //刷新页面
    [self.insureingTableview reloadData];
    [self.stayInsuretableview reloadData];
    [self.insuredTableview reloadData];
}

#pragma mark - 移除之前账号的残留物,即所有相关的数据
-(void)removeInsuringArray:(NSNotification *)sender{
    self.insureingSectionArray = nil;
    [self loadData];
}

#pragma mark - 刷新
-(void) refresh
{
    CustomRefreshHeader *  stayInsureHeaderRefresh = [CustomRefreshHeader  headerWithRefreshingTarget:self refreshingAction:@selector(loadStayInsureData)];
   
    CustomRefreshHeader *  insureingHeaderRefresh = [CustomRefreshHeader  headerWithRefreshingTarget:self refreshingAction:@selector(loadInsureingData)];
   
    CustomRefreshHeader *  insuredHeaderRefresh = [CustomRefreshHeader  headerWithRefreshingTarget:self refreshingAction:@selector(loadInsuredData)];
    
    // 马上进入刷新状态
    [stayInsureHeaderRefresh beginRefreshing];
    
    [insureingHeaderRefresh  beginRefreshing];
    
    [insuredHeaderRefresh  beginRefreshing];
    
    // 设置header
    self.insureingTableview.mj_header = insureingHeaderRefresh;
    
    self.insuredTableview.mj_header  = insuredHeaderRefresh;
    
    self.stayInsuretableview.mj_header = stayInsureHeaderRefresh;
}



#pragma  mark - 刷新
-(void) loadStayInsureData
{
    [self insureingDataWithStatus:@"待投保"];
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.stayInsuretableview reloadData];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.stayInsuretableview.mj_header endRefreshing];
    });
}


-(void) loadInsureingData
{
    [self insureingDataWithStatus:@"投保中"];
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.insureingTableview  reloadData];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.insureingTableview.mj_header endRefreshing];
    });
}


-(void) loadInsuredData
{
    [self insureingDataWithStatus:@"已投保"];
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.insuredTableview reloadData];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.insuredTableview.mj_header endRefreshing];
    });
}


#pragma mark - 投保中,待投保，已投保 接口调用
-(void ) insureingDataWithStatus:(NSString *)status
{
  
    //   得到数据管理
    DBManager * dbManager = [DBManager sharedInstance];
    
    // 查询对象
    Individual * individual= [dbManager selectIndividual];

    //调用接口
    [self.HTTPManager GetDoingInsureDatasWithbusinessUserId:individual.individualId andStatus:status];
    
    __weak typeof(self) temp = self;
    //成功得到数据
    _HTTPManager.passResponseObjectOfGetDoingInsureDatas = ^(id responseObject){
        //把后台数据 字典类型的转换成相应的模型
        PolicyModel * policyModel= [PolicyModel  mj_objectWithKeyValues: responseObject];
        
        NSArray  * array=[PolicyListsModel  mj_objectArrayWithKeyValuesArray:policyModel.data];
        
        if ([status isEqualToString:@"投保中"]) {
            [temp insureingDataWithArray:array];
        }else if ([status isEqualToString:@"待投保"]){
            [temp stayInsureDataWithArray:array];
        }else{
            [temp insuredDataWithArray:array];
        }
    };
    
    
    //接口 失败
    _HTTPManager.passErrorOfGetDoingInsureDatas = ^(NSError * error){
        [super showFailureHUD:FailureAboutRequestData hideTime:ToastHideTime];
    };
  
}


#pragma mark - 投保中 数据初始化
-(void)insureingDataWithArray:(NSArray *)array{
    NSMutableArray * nsMutableArray = [NSMutableArray  array];
    
    for (PolicyListsModel  * policiy in array) {
        
        InsureingMineItemModel  * mineItem = [[InsureingMineItemModel alloc] init];
        mineItem.funcName = policiy.cz_name;
        mineItem.synopsisName = policiy.cph_no;
        mineItem.accessoryType =  MineAccessoryTypeDisclosureIndicator;
        mineItem.detailText = [NSString detailText: policiy.Status];
        
        NSDictionary * contents = @{@"cz_name":policiy.cz_name == nil ? @"" : policiy.cz_name,@"cz_phone":policiy.Cz_phone == nil ? @"" : policiy.Cz_phone,@"cntr_id":policiy.cntr_id == nil ? @"" : policiy.cntr_id,@"companycode":policiy.xh_code == nil ? @"" : policiy.xh_code};
        
        //跳转到车辆信息界面
        mineItem.executeCode = ^{
            
            DetailsViewController * detailsView = [[DetailsViewController alloc] init];
            //传值
            detailsView.policyListModel = policiy;
            detailsView.showHead = YES;
            detailsView.cntr_ClInfoParameters = @{@"cph_no":policiy.cph_no,@"cjh_no":policiy.cjh_no};
            
            detailsView.title  = @"详情";
            
            if([policiy.Status isEqualToString:@"-1"]){ //待审核
                [detailsView  detailsViewWithpolicy:policiy contents:contents andStatus:policiy.Status];
            }else if([policiy.Status isEqualToString:@"0"]){//审核中
                [detailsView  detailsViewWithpolicy:policiy contents:contents andStatus:policiy.Status];
            }else if([policiy.Status isEqualToString:@"1"]){//审核失败
                [detailsView  detailsViewWithpolicy:policiy contents:contents andStatus:policiy.Status];
            }else if([policiy.Status isEqualToString:@"2"]){ //审核成功-待支付
                detailsView.title  = @"保单详情";
                detailsView.showFooter = YES;
                [detailsView  detailsViewWithpolicy:policiy contents:contents andStatus:policiy.Status];
            }else if([policiy.Status isEqualToString:@"3"]){ //支付失败
                detailsView.title  = @"保单详情";
                detailsView.showFooter = YES;
                [detailsView  detailsViewWithpolicy:policiy contents:contents andStatus:policiy.Status];
            }else if([policiy.Status isEqualToString:@"4"]){ //支付成功
                [detailsView  detailsViewWithpolicy:policiy contents:contents andStatus:policiy.Status];
                
            }else if([policiy.Status isEqualToString:@"5"]){ //刷卡支付，待财务确认
                [detailsView  detailsViewWithpolicy:policiy contents:contents andStatus:policiy.Status];
                
            }else if([policiy.Status isEqualToString:@"6"]){ //完成
                //整个订单完成
            }
            
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            
            pushToViewControllerAndTarget(self, DetailsViewController, detailsView);
            
        };
        [nsMutableArray addObject: mineItem];
    }
    MineSectionModel * mineSectionModel = [[MineSectionModel alloc] init];
    mineSectionModel.itemArray = nsMutableArray;
    self.insureingSectionArray  = @[mineSectionModel];
}


#pragma mark - 待投保 数据初始化
-(void) stayInsureDataWithArray:(NSArray *)array
{
    NSMutableArray * nsMutableArray = [NSMutableArray  array];
    for (PolicyListsModel  * policiy in array) {
        
        StayInsureMineItemModel  * mineItem = [[StayInsureMineItemModel alloc] init];
        mineItem.funcName = policiy.cz_name;
        mineItem.synopsisName = policiy.cph_no;
        mineItem.accessoryType =  MineAccessoryTypeDisclosureIndicator;
        //保险终止日期
        NSString *endTime = policiy.Zzrq == nil ? @"null" : policiy.Zzrq;
        NSDictionary *  contents = @{@"cz_name":policiy.cz_name,@"JQXTime":endTime ,@"SYXTime":endTime,@"Cz_phone":policiy.Cz_phone,@"cntr_id":policiy.cntr_id,@"companycode":policiy.xh_code};
        
        mineItem.executeCode = ^{
            [self  passDetails: policiy contents: contents];
        };
        
        [nsMutableArray addObject: mineItem];
    }
    MineSectionModel * mineSectionModel = [[MineSectionModel alloc] init];
    mineSectionModel.itemArray = nsMutableArray;
    self.stayInsureSectionArray  = @[mineSectionModel];
}

#pragma mark - 已投保 数据初始化
-(void ) insuredDataWithArray:(NSArray *)array
{
    NSMutableArray * nsMutableArray = [NSMutableArray  array];
    
    for (PolicyListsModel  * policiy in array) {
        
        InsuredMineItemModel  * mineItem = [[InsuredMineItemModel alloc] init];
        mineItem.funcName = policiy.cz_name;
        mineItem.synopsisName = policiy.cph_no;
        mineItem.detailText = policiy.Zzrq;
        mineItem.accessoryType =  MineAccessoryTypeDisclosureIndicator;
        //保险终止日期
        NSString *endTime = policiy.Zzrq == nil ? @"null" : policiy.Zzrq;
        NSDictionary *  contents = @{@"cz_name":policiy.cz_name,@"JQXTime":endTime ,@"SYXTime":endTime,@"Cz_phone":policiy.Cz_phone,@"cntr_id":policiy.cntr_id,@"companycode":policiy.xh_code};
        //跳转到车辆信息界面
        mineItem.executeCode = ^{
            [self  passDetails: policiy contents: contents];
        };
        [nsMutableArray addObject: mineItem];
    }
    
    MineSectionModel * mineSectionModel = [[MineSectionModel alloc] init];
    mineSectionModel.itemArray = nsMutableArray;
    self.insuredSectionArray  = @[mineSectionModel];
}


#pragma mark - 通过此方法进入到保单详情
-(void) passDetails:(PolicyListsModel *) policiy contents:(NSDictionary * ) contents
{
    DetailsViewController * detailsView = [[DetailsViewController alloc] init];
    detailsView.cntr_ClInfoParameters = @{@"cph_no":policiy.cph_no,@"cjh_no":policiy.cjh_no};
    
    detailsView.title  = @"详情";
    [detailsView  detailsViewWithpolicy:policiy contents:contents andStatus:@"-2"];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    pushToViewControllerAndTarget(self, DetailsViewController, detailsView);
}

/**
 *  创建tableview 并加入到UIScrollView 中
 */
-(void)creatTableview
{
    [self.tableViewscrview addSubview:self.insureingTableview];
    [self.tableViewscrview addSubview:self.stayInsuretableview];
    [self.tableViewscrview addSubview:self.insuredTableview];
}


#pragma  mark - uitableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger  tempNumber = 0;
    if(tableView == self.insureingTableview){//待投保
        MineSectionModel *  insureingSection =  self.insureingSectionArray [section];
        tempNumber = insureingSection.itemArray.count;
    }
    if(tableView == self.stayInsuretableview){ //待投保
        MineSectionModel * stayInsureSection =   self.stayInsureSectionArray[section];
        tempNumber = stayInsureSection.itemArray.count;
    }
    if(tableView == self.insuredTableview){  //已投保
        MineSectionModel  *   insuredSection =  self.insuredSectionArray[section];
        tempNumber =  insuredSection.itemArray.count;
    }
    return  tempNumber;
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.insureingTableview){//待投保
        MineSectionModel *  insureingSection =  self.insureingSectionArray [indexPath.section];
        InsureingMineItemModel * item =  insureingSection.itemArray[indexPath.row];
        [self  executeCode:item];
    }else  if(tableView == self.stayInsuretableview){ //待投保
        MineSectionModel * stayInsureSection =   self.stayInsureSectionArray[indexPath.section];
        StayInsureMineItemModel * item   =  stayInsureSection.itemArray[indexPath.row];
        [self  executeCode:item];
    }else if(tableView == self.insuredTableview){  //已投保
        MineSectionModel  *   insuredSection =  self.insuredSectionArray[indexPath.section];
        InsuredMineItemModel * item =   insuredSection.itemArray[indexPath.row];
        [self executeCode: item];
    }
}


-(void)   executeCode :(MineItemModel  * ) item
{
    
    if(item.executeCode){
        item.executeCode();
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*key1=@"cell1";
    static NSString*key2=@"cell2";
    static NSString*key3=@"cell3";
    
    MineViewCell  * cell;
    if (tableView==self.insureingTableview) {
          cell=[self.insureingTableview dequeueReusableCellWithIdentifier:key1];
            if (cell==nil) {
            cell=[[MineViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key1];
        }
        // 获取组
        MineSectionModel * sectionModel = self.insureingSectionArray[indexPath.section];
        //得到组中的item
        InsureingMineItemModel *  itemModel = sectionModel.itemArray[indexPath.row];
        cell.item = itemModel;
        
    }else if (tableView==self.stayInsuretableview) {
      cell=[self.stayInsuretableview dequeueReusableCellWithIdentifier:key2];
        if (cell==nil) {
            cell=[[MineViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key2];
        }
        // 获取组
        MineSectionModel * sectionModel = self.stayInsureSectionArray[indexPath.section];
        //得到组中的item
        StayInsureMineItemModel *  itemModel = sectionModel.itemArray[indexPath.row];
        cell.item = itemModel;
        
    }else if (tableView==self.insuredTableview) {
        cell=[self.insuredTableview dequeueReusableCellWithIdentifier:key3];
        if (cell==nil) {
            cell=[[MineViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key3];
        }
        // 获取组
        MineSectionModel * sectionModel = self.insuredSectionArray[indexPath.section];
        //得到组中的item
        InsuredMineItemModel *  itemModel = sectionModel.itemArray[indexPath.row];
        cell.item = itemModel;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(CGFloat ) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  18;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view;
    if (section == (self.insuredSectionArray.count - 1)) {
        view.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
        view.backgroundColor = [UIColor whiteColor];
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == (self.insuredSectionArray.count - 1)) {
        return 120;
    }
    return 0;
}


/**
 * scroollview
 */
-(void) creatScrollview
{
    NSArray*arr=@[@"投保中",@"待投保",@"已投保"];
    for (int i=0; i<3; i++) {
        UIButton*btn=[[UIButton alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/3, 10, SCREEN_WIDTH/3, 40)];
        btn.tag=i;
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        //btn.titleLabel.font = [ UIFont   fontWithName : @"Helvetica-Bold"  size : 40];
        btn.titleLabel.font=[UIFont systemFontOfSize:GlobalFontSize];
        [btnMutableArray addObject:btn];
        if (i==0) {
            [btn setTitleColor:GlobalColor forState:UIControlStateNormal];
            tembtn=btn;
            temRect=btn.frame;
        } else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             }
        [btn addTarget:self action:@selector(btn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableCellView addSubview:btn];
    }
    
    _lineScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(temRect), SCREEN_WIDTH/3, 2)];
    
    [self.tableCellView addSubview:_lineScrollView];
    _lineScrollView.backgroundColor=GlobalColor;
    _lineScrollView.delegate=self;
    _lineScrollView.contentSize=CGSizeMake(SCREEN_WIDTH*2, 2);
    _lineScrollView.showsHorizontalScrollIndicator=NO;
    _lineScrollView.showsVerticalScrollIndicator=NO;
    
    _tableViewscrview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_lineScrollView.frame),SCREEN_WIDTH , SCREEN_HEIGHT-CGRectGetMaxY(_lineScrollView.frame))];
    [self.tableCellView addSubview:_tableViewscrview];
    _tableViewscrview.delegate=self;
    pageController=[[UIPageControl alloc]initWithFrame:CGRectZero];
    pageController.numberOfPages=3;
    pageController.currentPage=0;
    _tableViewscrview.pagingEnabled=YES;
    [_tableViewscrview addSubview:pageController];
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
        UIButton*btn=btnMutableArray[i];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *新增
 */
- (IBAction)addCarInfo:(UIButton *)sender {
    
    [self.navigationController  setNavigationBarHidden:NO animated:NO];
    pushToViewControllerAndTarget(self, AddCarInfoViewController, self.addCarInfoView);
}



#pragma  mark - 懒加载
-(AddCarInfoViewController *)addCarInfoView
{
    if(!_addCarInfoView){
        AddCarInfoViewController * addCarInfo = [[AddCarInfoViewController alloc] init];
        addCarInfo.title = @"车辆信息";
        self.addCarInfoView = addCarInfo;
    }
    return  _addCarInfoView;
}


-(UITableView *)insureingTableview
{
    if(!_insureingTableview){
        _insureingTableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(_tableViewscrview.frame)) style:UITableViewStylePlain];
        
        [_insureingTableview setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        _insureingTableview.separatorStyle =UITableViewCellSeparatorStyleNone;
        _insureingTableview.backgroundColor=ColorFromRGB(243, 244, 245);
        
        _insureingTableview.delegate=self;
        _insureingTableview.dataSource=self;
    }
    return  _insureingTableview;
}


-(UITableView *)stayInsuretableview
{
    if(!_stayInsuretableview){
        _stayInsuretableview=[[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(_tableViewscrview.frame)) style:UITableViewStylePlain];
        [_stayInsuretableview setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        _stayInsuretableview.separatorStyle =UITableViewCellSeparatorStyleNone;
        _stayInsuretableview.backgroundColor=ColorFromRGB(243, 244, 245);
        
        _stayInsuretableview.delegate=self;
        _stayInsuretableview.dataSource=self;
        
    }
    return  _stayInsuretableview;
}



-(UITableView *)insuredTableview
{
    if(!_insuredTableview){
        _insuredTableview=[[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, CGRectGetHeight(_tableViewscrview.frame)) style:UITableViewStylePlain];
        [_insuredTableview setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        _insuredTableview.separatorStyle =UITableViewCellSeparatorStyleNone;
        _insuredTableview.backgroundColor=ColorFromRGB(243, 244, 245);
        _insuredTableview.delegate=self;
        _insuredTableview.dataSource=self;
    }
    return _insuredTableview;
}

-(HTTPManagerOfInsurance *)HTTPManager{
    if (_HTTPManager == nil) {
        _HTTPManager = [HTTPManagerOfInsurance sharedHTTPManagerOfInsurance];
    }
    return _HTTPManager;
}



#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    [self.navigationController  setNavigationBarHidden:YES animated:NO];
    //接收通知,当退出登录,重新登录一个账户时,移除上一个账户相关的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeInsuringArray:) name:removeDataWhenExit object:nil];
    
    //加载数据
    [self loadData];
}

@end
