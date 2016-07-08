//
//  InsuranceProposalViewController.m
//  Template_Joker
//
//  Created by Bella on 16/1/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "InsuranceProposalViewController.h"
#import "ResultTableViewController.h"
#import "PriceDetail.h"

#import "Insurance.h"

#import "SelectMoneyView.h"
#import "SelectStateView.h"


#define documentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]

#define basePlistName @"BaseInsurancePropertyList"
#define haohuaPlistName @"HaoHuaInsurance"
#define jingjiPlistName @"JingJiInsurance"
#define zixuanPlistName @"ZiXuanInsurance"



@interface InsuranceProposalViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 *  投保方案中的tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  基本版 数据
 */
@property(nonatomic,strong) NSMutableArray *baseData;

/**
 *  经济版 数据
 */
@property(nonatomic,strong) NSMutableArray *jingJiData;

/**
 *  豪华版 数据
 */
@property(nonatomic,strong) NSMutableArray *haoHuaData;


/**
 *  自选版 数据
 */
@property(nonatomic,strong) NSMutableArray *ziXuanData;


/**
 *  当前版 数据
 */
@property(nonatomic,strong) NSMutableArray *currentData;


/**
 *  自定义segmentControl
 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *customSegmentControl;

/**
 *  底部的view
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;


/**
 *  暂时存储carInfo
 */
@property(nonatomic,strong) CarInfo *tempCarInfo;


@end

/**
 *  cell标识符
 */
static NSString *onlyTwoBtnCellIdentifier = @"onlyTwoBtnCell";
static NSString *basicCellIdentifier = @"basicCell";
static NSString *originalCellIdentifier = @"originalCell";
static NSString *twoBtnCellIdentifier = @"twoBtnCell";
static NSString *threeBtnCellIdentifier = @"threeBtnCell";

/**
 *  是否勾选险种Button的tag初值
 */
static int isSelectedInsuranceBtnTagIndex = 100;

/**
 *   不计免赔Button的tag初值
 */
static int notDutyBtnTagIndex = 300;

/**
 *  选取投保金额Button的tag的初值
 */
static int selectedMoneyBtnTagIndex = 400;



@implementation InsuranceProposalViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
}



#pragma mark - 初始化数据
-(void)setOriginalValue{
    self.title = @"投保方案";
    
    //segmentControl
    self.customSegmentControl.selectedSegmentIndex = 0;
    
    //最开始是，基本版,不需要显示
    self.currentData = self.baseData;
    
    //cell的自适应
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    
    //禁止回弹
    self.tableView.bounces = NO;
    
}

#pragma mark - 设置代理
-(void)setDelegateForTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - 注册cell
-(void)registerCell{
    //注册xib的cell
    [self.tableView registerNib:[UINib nibWithNibName:@"OnlyTwoBtnCell" bundle:nil] forCellReuseIdentifier:onlyTwoBtnCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"BasicCell" bundle:nil] forCellReuseIdentifier:basicCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"OriginalCell" bundle:nil] forCellReuseIdentifier:originalCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoBtnCell" bundle:nil] forCellReuseIdentifier:twoBtnCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ThreeBtnCell" bundle:nil] forCellReuseIdentifier:threeBtnCellIdentifier];
    
}

#pragma mark - 加载数据
-(void)loadData{
    
    [self.baseData addObjectsFromArray:[self getArrayFromPlistFile:[[NSBundle mainBundle] pathForResource:@"BaseInsurancePropertyList" ofType:@"plist"]]];
    [self.jingJiData addObjectsFromArray:[self getArrayFromPlistFile:[[NSBundle mainBundle] pathForResource:@"JingJiInsurance" ofType:@"plist"]]];
    [self.haoHuaData addObjectsFromArray:[self getArrayFromPlistFile:[[NSBundle mainBundle] pathForResource:@"HaoHuaInsurance" ofType:@"plist"]]];
    [self.ziXuanData addObjectsFromArray:[self getArrayFromPlistFile:[[NSBundle mainBundle] pathForResource:@"ZiXuanInsurance" ofType:@"plist"]]];
    
}


#pragma mark - 从plist文件中获取到数据
-(NSMutableArray *)getArrayFromPlistFile:(NSString *)filePath{
    NSMutableArray *dataArray = [NSMutableArray array];
    
    //从plist文件中取得最外层
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    
    for (NSArray *sonArray in array) {
        
        //用来存储模型数组
        NSMutableArray *returnArray = [NSMutableArray array];
        
        for (NSDictionary *itemDict in sonArray) {
            Insurance *insurance = [Insurance new];
            [insurance setValuesForKeysWithDictionary:itemDict];
            //把模型放入容器中
            [returnArray addObject:insurance];
        }
        
        //数组里有 装有模型数据的数组
        [dataArray addObject:returnArray];
    }
    
    
    return dataArray;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //根据当前索引 返回row的数量
    return [[self.currentData objectAtIndex:section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //返回当前版本数据的数量
    return self.currentData.count;
}

#pragma mark - tableViewCell 内容设置
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  [self showTableViewWithTableView:tableView indexPath:indexPath];
    
}

#pragma mark - tableView的内容
-(UITableViewCell *)showTableViewWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    Insurance *insurance ;
    
    //获取到对应的模型数据
    insurance = self.currentData[indexPath.section][indexPath.row];
    
    //分区0 下面的cell的样式
    if (0 == indexPath.section) {
        
        if (0 == indexPath.row) {
            BasicCell *basicCell = [tableView dequeueReusableCellWithIdentifier:basicCellIdentifier forIndexPath:indexPath];
            //传值给cell上的控件，进行展示。
            basicCell.insuranceNameLable.text = insurance.insuranceName;
            
            basicCell.isSelectedInsuranceBtn.tag = indexPath.section * isSelectedInsuranceBtnTagIndex + indexPath.row;
            
            //判断该险种是否勾选
            if (YES == insurance.isSelectedInsuranceFlag) {
                [basicCell isShowWithValue:YES];
            }else{
                [basicCell isShowWithValue:NO];
            }
            
            //勾选险种事件
            [basicCell.isSelectedInsuranceBtn addTarget:self action:@selector(isSelectedInsuranceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            return basicCell;
        }else if (1 == indexPath.row || 3 == indexPath.row){
            TwoBtnCell *twoBtnCell = [tableView dequeueReusableCellWithIdentifier:twoBtnCellIdentifier forIndexPath:indexPath];
            //险种名称
            NSString *basicText = insurance.insuranceName;
            //是否选择某险种的Button的tag值
            NSInteger basicTag = indexPath.section * isSelectedInsuranceBtnTagIndex + indexPath.row;
            
            //判断该险种是否勾选
            if (YES == insurance.isSelectedInsuranceFlag) {
                [twoBtnCell isShowWithValue:YES];
            }else{
                [twoBtnCell isShowWithValue:NO];
            }
            
            //向cell传值,险种名称,险种tag值
            [twoBtnCell passTextOfInsuranceName:basicText isSelectedInsuranceBtnWithTag:basicTag];
            
            //勾选险种事件
            [twoBtnCell.isSelectedInsuranceBtn addTarget:self action:@selector(isSelectedInsuranceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            //不计免赔的tag值
            twoBtnCell.notDutyBtn.tag = notDutyBtnTagIndex * indexPath.section + indexPath.row;
            //不计免赔事件
            [twoBtnCell.notDutyBtn addTarget:self action:@selector(notDutyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            if (YES == insurance.notDutyFlag) {
                [twoBtnCell notDutyAction:YES];
            }else{
                [twoBtnCell notDutyAction:NO];
            }
            
            
            return twoBtnCell;
        }else{
            ThreeBtnCell *threeBtnCell = [self.tableView dequeueReusableCellWithIdentifier:threeBtnCellIdentifier forIndexPath:indexPath];
            NSString *basicText = insurance.insuranceName;
            NSInteger basicTag = indexPath.section * isSelectedInsuranceBtnTagIndex + indexPath.row;
            
            
            //判断该险种是否勾选
            if (YES == insurance.isSelectedInsuranceFlag) {
                [threeBtnCell isShowWithValue:YES];
            }else{
                [threeBtnCell isShowWithValue:NO];
            }
            
            //传值,是否选择该险种
            [threeBtnCell passTextOfInsuranceName:basicText isSelectedInsuranceBtnWithTag:basicTag];
            
            [threeBtnCell.isSelectedInsuranceBtn addTarget:self action:@selector(isSelectedInsuranceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            //投保金额的选取
            if ([insurance.insuranceName isEqualToString:@"乘客责任险"]) {
                [threeBtnCell.selectMoneyBtn setTitle:[NSString stringWithFormat:@"%@/万/座",insurance.InsurancePrice] forState:UIControlStateNormal];
            }else{
                [threeBtnCell.selectMoneyBtn setTitle:[NSString stringWithFormat:@"%@/万",insurance.InsurancePrice] forState:UIControlStateNormal];
            }
            threeBtnCell.selectMoneyBtn.tag = selectedMoneyBtnTagIndex * indexPath.section + indexPath.row;
            [threeBtnCell.selectMoneyBtn addTarget:self action:@selector(selectMoneyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            //不计免赔
            threeBtnCell.notDutyBtn.tag = notDutyBtnTagIndex * indexPath.section + indexPath.row;
            [threeBtnCell.notDutyBtn addTarget:self action:@selector(notDutyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            if (YES == insurance.notDutyFlag) {
                [threeBtnCell notDutyAction:YES];
            }else{
                [threeBtnCell notDutyAction:NO];
            }
            
            return threeBtnCell;
        }
    }
    //分区1 下面的cell的样式
    else{
        if (0 == indexPath.row) {
            
            OnlyTwoBtnCell *onlyTwoBtnCell = [tableView dequeueReusableCellWithIdentifier:onlyTwoBtnCellIdentifier forIndexPath:indexPath];
            NSString *extraText = insurance.insuranceName;
            NSInteger extraTag = indexPath.section * isSelectedInsuranceBtnTagIndex + indexPath.row;
            
            //判断该险种是否勾选
            if (YES == insurance.isSelectedInsuranceFlag) {
                [onlyTwoBtnCell isShowWithValue:YES];
            }else{
                [onlyTwoBtnCell isShowWithValue:NO];
            }
            
            //是否选择该险种
            [onlyTwoBtnCell passTextOfInsuranceName:extraText isSelectedInsuranceBtnWithTag:extraTag];
            [onlyTwoBtnCell.isSelectedInsuranceBtn addTarget:self action:@selector(isSelectedInsuranceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            

            //产地的选取
            onlyTwoBtnCell.selectMoneyBtn.tag = selectedMoneyBtnTagIndex * indexPath.section + indexPath.row;
            [onlyTwoBtnCell.selectMoneyBtn addTarget:self action:@selector(selectStateAction:) forControlEvents:UIControlEventTouchUpInside];
            
            return onlyTwoBtnCell;
        }else{
            TwoBtnCell *twoBtnCell = [self.tableView dequeueReusableCellWithIdentifier:twoBtnCellIdentifier forIndexPath:indexPath];
            NSString *extraText = insurance.insuranceName;
            NSInteger extraTag = indexPath.section * isSelectedInsuranceBtnTagIndex + indexPath.row;
            
            //判断该险种是否勾选
            if (YES == insurance.isSelectedInsuranceFlag) {
                [twoBtnCell isShowWithValue:YES];
            }
            else{
                [twoBtnCell isShowWithValue:NO];
            }
            
            //向cell传值
            [twoBtnCell passTextOfInsuranceName:extraText isSelectedInsuranceBtnWithTag:extraTag];
            [twoBtnCell.isSelectedInsuranceBtn addTarget:self action:@selector(isSelectedInsuranceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            //不计免赔
            twoBtnCell.notDutyBtn.tag = notDutyBtnTagIndex * indexPath.section + indexPath.row;
            [twoBtnCell.notDutyBtn addTarget:self action:@selector(notDutyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            if (YES == insurance.notDutyFlag) {
                [twoBtnCell notDutyAction:YES];
            }else{
                [twoBtnCell notDutyAction:NO];
            }
            
            return twoBtnCell;
        }
    }
}

#pragma mark - 勾选险种后,处理事件--跳转到自选版,并且勾选上险种
-(void)isSelectedInsuranceBtnAction:(UIButton *)sender{
    NSInteger section = sender.tag / isSelectedInsuranceBtnTagIndex;
    NSInteger row = sender.tag % isSelectedInsuranceBtnTagIndex;
    
    Insurance *otherData = [[self.ziXuanData objectAtIndex:section] objectAtIndex:row];
    Insurance *currentData = [[self.currentData objectAtIndex:section] objectAtIndex:row];
    
    //如果是附加险，得先判断,车辆损失险是否勾选
    if (1 == section) {
        if (![[[self.currentData objectAtIndex:0] objectAtIndex:1] isSelectedInsuranceFlag]) {
                //没有选择车辆损失险,那么附加险不能选择
            [GiFHUD showWithMessage:@"先选择车辆损失险"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kGifHUDDismissInTouBaoFangAn * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [GiFHUD dismissBiggerFrame];
            });
                return;
        }
    }
    
    //如果当前数据不是自选版的数据
    if (self.currentData != self.ziXuanData) {
        self.customSegmentControl.selectedSegmentIndex = 3;
        
        //取反,控制险种是否勾选
        otherData.isSelectedInsuranceFlag = !currentData.isSelectedInsuranceFlag;
        self.currentData = self.ziXuanData;
        
    }else{
        
        currentData.isSelectedInsuranceFlag = !currentData.isSelectedInsuranceFlag;
        self.currentData = self.currentData;
    }
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    Insurance *insurance = self.currentData[section][row];
    //判断该险种是否勾选
    if (YES == insurance.isSelectedInsuranceFlag) {
        [cell isShowWithValue:YES];
    }else{
        [cell isShowWithValue:NO];
    }
    
    [self writeToPlistFile];
    
    
}

#pragma mark - 把更新的数据写入plist文件
- (void)writeToPlistFile{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString *baseFilePath = [docPath stringByAppendingString:[NSString stringWithFormat:@"%@.plist",basePlistName]];
    
    [self.baseData writeToFile:baseFilePath atomically:YES];
    
    NSString *haoHuaFilePath = [docPath stringByAppendingString:[NSString stringWithFormat:@"%@.plist",haohuaPlistName]];
    [self.haoHuaData writeToFile:haoHuaFilePath atomically:YES];
    
    NSString *jingJiFilePath = [docPath stringByAppendingString:[NSString stringWithFormat:@"%@.plist",jingjiPlistName]];
    [self.jingJiData writeToFile:jingJiFilePath atomically:YES];
    
    NSString *ziXuanFilePath = [docPath stringByAppendingString:[NSString stringWithFormat:@"%@.plist",zixuanPlistName]];
    [self.ziXuanData writeToFile:ziXuanFilePath atomically:YES];
    
    //刷新数据
    [self.tableView reloadData];
    
}

#pragma mark - 选择产地
-(void)selectStateAction:(UIButton *)sender{
    NSInteger section = sender.tag / selectedMoneyBtnTagIndex;
    NSInteger row = sender.tag % selectedMoneyBtnTagIndex;
    
    SelectStateView *selectStateView = (SelectStateView *)[[[NSBundle mainBundle] loadNibNamed:@"SelectStateView" owner:nil options:nil] firstObject];
    //设置显示位置
    CGFloat height = selectStateView.bounds.size.height;
    CGRect frame ;
    frame.origin.x = 0;
    frame.origin.y = self.view.bounds.size.height - height;
    frame.size.width = self.view.bounds.size.width;
    frame.size.height = height;
    selectStateView.frame = frame;
    
    //设置初始值
    [selectStateView setOriginalViewWithArray:@[@"国产",@"进口"]];
    
    [self.view addSubview:selectStateView];
    
    
    selectStateView.passState = ^(NSString *state){
        
        Insurance *currentData = [[self.currentData objectAtIndex:section] objectAtIndex:row];
        
        
        if ([state isEqualToString:@"国产"]) {
            currentData.state = @"1";
        }
        if ([state isEqualToString:@"进口"]) {
            currentData.state = @"0";
        }
        [sender setTitle:state forState:UIControlStateNormal];
        
        [self writeToPlistFile];
        
    };
    
    selectStateView.passCancleSige = ^(){
        
    };
}

#pragma mark - 投保金额的选取
-(void)selectMoneyBtnAction:(UIButton *)sender{
    NSInteger section = sender.tag / selectedMoneyBtnTagIndex;
    NSInteger row = sender.tag % selectedMoneyBtnTagIndex;
    
    SelectMoneyView *selectMoneyView = (SelectMoneyView *)[[[NSBundle mainBundle] loadNibNamed:@"SelectMoneyView" owner:nil options:nil] firstObject];
    
    //设置显示位置
    CGFloat height = selectMoneyView.bounds.size.height;
    CGRect frame ;
    frame.origin.x = 0;
    frame.origin.y = self.view.bounds.size.height - height;
    frame.size.width = self.view.bounds.size.width;
    frame.size.height = height;
    selectMoneyView.frame = frame;
    
    
    Insurance *currentData = [[self.currentData objectAtIndex:section] objectAtIndex:row];
    
    if ([currentData.insuranceName isEqualToString:@"第三者责任险"]) {
        //设置初始值
        [selectMoneyView setOriginalViewWithNumberArray:@[@5,@10,@20,@30,@50,@100] withUnit:@"万"];
    }else{
        if ([currentData.insuranceName isEqualToString:@"乘客责任险"]) {
            //设置初始值
            [selectMoneyView setOriginalViewWithNumberArray:@[@1,@2,@3,@4,@5,@10,@20] withUnit:@"万/座"];
        }else{
            //设置初始值
            [selectMoneyView setOriginalViewWithNumberArray:@[@1,@2,@3,@4,@5,@10,@20] withUnit:@"万"];
        }
    }
    
    [self.view addSubview:selectMoneyView];
    
    
    //回调，得到选择投保金额
    selectMoneyView.passMoney = ^(NSString *money,NSString *danwei){
       
        NSString *selectMoney = [NSString stringWithFormat:@"%@/%@",money,danwei];
        
        //修改保价金额
        currentData.InsurancePrice = money;
        
        [sender setTitle:selectMoney forState:UIControlStateNormal];
        
        [self writeToPlistFile];
        
    };
    
}

#pragma mark - 不计免赔
-(void)notDutyBtnAction:(UIButton *)sender{
    NSInteger section = sender.tag / notDutyBtnTagIndex;
    NSInteger row = sender.tag % notDutyBtnTagIndex;
    
    Insurance *currentData = [[self.currentData objectAtIndex:section] objectAtIndex:row];
    
    //取反,控制险种是否勾选
    currentData.notDutyFlag = !currentData.notDutyFlag;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    ThreeBtnCell *threeBtnCell = (ThreeBtnCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (YES == currentData.notDutyFlag) {
        [threeBtnCell notDutyAction:YES];
    }else{
        [threeBtnCell notDutyAction:NO];
    }
    
    
    [self writeToPlistFile];
    
}



#pragma mark - tableView的headerView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        return [[[NSBundle mainBundle] loadNibNamed:@"InsuranceProposalBasicHeaderView" owner:nil options:nil] firstObject];
    }else{
        return [[[NSBundle mainBundle] loadNibNamed:@"InsuranceProposalExtraHeaderView" owner:nil options:nil] firstObject];
    }
}

#pragma mark - headerView 的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}


#pragma mark - footerView的高度，避免被遮
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (0 == section) {
        return 10;
    }else{
        return self.bottomView.frame.size.height;
    }
}


#pragma mark - 分段字段 segmentControl的响应事件
- (IBAction)selectSegmentAction:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
            //基本版、经济版、豪华版的是固定。
        case 0:
            self.currentData = self.baseData;
            break;
        case 1:
            self.currentData = self.jingJiData;
            break;
        case 2:
            self.currentData = self.haoHuaData;
            break;
            
            //只有自选版的才是可以变动的。
        case 3:
            self.currentData = self.ziXuanData;
            break;
    }
    
    //刷新页面数据
    [self.tableView reloadData];
}

#pragma mark - 立即报价按钮->跳转到报价结果页面
- (IBAction)toResultPage:(UIButton *)sender {
    
    ResultTableViewController *resultTVC = [ResultTableViewController new];
    
    HTTPManager *manager = [HTTPManager sharedHTPPManager];
    
    //车主(可填)
    NSString *cz_name = self.tempCarInfo.cz_name == nil ? @"" : self.tempCarInfo.cz_name;
    
    //车牌号(必填)
    NSString *cph_no = self.tempCarInfo.cph_no == nil ? @"" : self.tempCarInfo.cph_no;
    
    //车架号(必填)
    NSString *cjh_no = self.tempCarInfo.cjh_no == nil ? @"" : self.tempCarInfo.cjh_no;
    
    //购买日期(行驶证注册日期)(必填)
    NSString *buy_date = self.tempCarInfo.buy_date == nil ? @"" : self.tempCarInfo.buy_date;
    
    //车辆损失险(录入1或者其他字符)
    Insurance *clssInstance = [[self.currentData objectAtIndex:0] objectAtIndex:1];
    NSString *clssx = [NSString stringWithFormat:@"%d",clssInstance.isSelectedInsuranceFlag];
    
    //第三者责任险实例
    Insurance *dszInstance = [[self.currentData objectAtIndex:0] objectAtIndex:2];
    
    //第三者责任险 1/0
    NSString *dszzrx = [NSString stringWithFormat:@"%d",dszInstance.isSelectedInsuranceFlag];
    
    //第三者责任险值
    NSString *dszzrxValue ;
    if (dszInstance.isSelectedInsuranceFlag) {
        dszzrxValue = [NSString stringWithFormat:@"%@",dszInstance.InsurancePrice];
    }else{
        dszzrxValue = @"0";
    }
    
    //全车盗抢险实例
    Insurance *qcdqInstance = [[self.currentData objectAtIndex:0] objectAtIndex:3];
    
    //全车盗抢险 1/0
    NSString *qcdqx = [NSString stringWithFormat:@"%d",qcdqInstance.isSelectedInsuranceFlag];
    
    //司机责任险实例
    Insurance *sjzrInstance = [[self.currentData objectAtIndex:0] objectAtIndex:4];
    
    //司机责任险 1/0
    NSString *sjzrx = [NSString stringWithFormat:@"%d",sjzrInstance.isSelectedInsuranceFlag];
    
    //司机责任险值
    NSString *sjzrxValue ;
    if (sjzrInstance.isSelectedInsuranceFlag) {
        sjzrxValue = [NSString stringWithFormat:@"%@",sjzrInstance.InsurancePrice];
    }else{
        sjzrxValue = @"0";
    }
    
    //乘客责任险实例
    Insurance *ckzrInstance = [[self.currentData objectAtIndex:0] objectAtIndex:5];
    
    //乘客责任险 1/0
    NSString *ckzrx = [NSString stringWithFormat:@"%d",ckzrInstance.isSelectedInsuranceFlag];
    
    //乘客责任险值
    NSString *ckzrxValue ;
    if (ckzrInstance.isSelectedInsuranceFlag) {
        ckzrxValue = [NSString stringWithFormat:@"%@",ckzrInstance.InsurancePrice];
    }else{
        ckzrxValue = @"0";
    }
    
    
    //玻璃破碎险实例
    Insurance *blpsxInstance = [[self.currentData objectAtIndex:1] objectAtIndex:0];
    NSString *blpsx =[NSString stringWithFormat:@"%d",blpsxInstance.isSelectedInsuranceFlag];
    NSString *blpsxValue = blpsxInstance.state;
    
    //自燃损失险
    Insurance *zrssxInstance = [[self.currentData objectAtIndex:1] objectAtIndex:1];
    NSString *zrssx = [NSString stringWithFormat:@"%d",zrssxInstance.isSelectedInsuranceFlag];
    NSString *zrssxValue = @"";
    
    resultTVC.carInfo = self.tempCarInfo;
    
    //立即比价
    [manager ImmediatelyOfferPriceWithcz_name:cz_name cph_no:cph_no cjh_no:cjh_no buy_date:buy_date clssx:clssx dszzrx:dszzrx dszzrxValue:dszzrxValue qcdqx:qcdqx sjzrx:sjzrx sjzrxValue:sjzrxValue ckzrx:ckzrx ckzrxValue:ckzrxValue blpsx:blpsx blpsxValue:blpsxValue zrssx:zrssx zrssxValue:zrssxValue];
    
    //投保方案中选取的保价信息
    NSDictionary *parametersDictionary = @{
                                           @"cz_name":cz_name,
                                           @"cph_no":cph_no,
                                           @"cjh_no":cjh_no,
                                           @"buy_date":buy_date,
                                           @"clssx":clssx,
                                           @"dszzrx":dszzrx,
                                           @"dszzrxValue":dszzrxValue,
                                           @"qcdqx":qcdqx,
                                           @"sjzrx":sjzrx,
                                           @"sjzrxValue":sjzrxValue,
                                           @"ckzrx":ckzrx,
                                           @"ckzrxValue":ckzrxValue,
                                           @"blpsx":blpsx,
                                           @"blpsxValue":[blpsxValue integerValue] == 1 ? @"国产" : @"进口" ,
                                           @"zrssx":zrssx,
                                           @"zrssxValue":zrssxValue
                                           };
    
    //把投保方案选择的数据往下一层传递
    resultTVC.arrayInsuranceData = self.currentData;
    resultTVC.infoAboutSelectedInsurance = parametersDictionary;
    
    
    self.hidesBottomBarWhenPushed = YES;
    pushToViewControllerAndTarget(self, ResultTableViewController, resultTVC);
    
}



#pragma mark - 内存警告处理中心
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - carInfosetter方法
-(void)setCarInfoInstance:(CarInfo *)carInfoInstance{
    self.tempCarInfo = carInfoInstance;
}

#pragma mark - 数据源 各个数据的懒加载
-(NSMutableArray *)baseData{
    if (nil == _baseData) {
        _baseData = [NSMutableArray arrayWithCapacity:20];
    }
    return _baseData;
}

-(NSMutableArray *)jingJiData{
    if (nil == _jingJiData) {
        _jingJiData = [NSMutableArray arrayWithCapacity:20];
    }
    return _jingJiData;
}

-(NSMutableArray *)haoHuaData{
    if (nil == _haoHuaData) {
        _haoHuaData = [NSMutableArray arrayWithCapacity:20];
    }
    return _haoHuaData;
}

-(NSMutableArray *)ziXuanData{
    if (nil == _ziXuanData) {
        _ziXuanData = [NSMutableArray arrayWithCapacity:20];
    }
    return _ziXuanData;
}

-(NSMutableArray *)currentData{
    if (nil == _currentData) {
        _currentData = [NSMutableArray arrayWithCapacity:20];
    }
    return _currentData;
}


#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //设置初始值
    [self setOriginalValue];
    
    //设置代理
    [self setDelegateForTableView];
    
    //注册cell
    [self registerCell];
    
    //加载数据
    [self loadData];
}

@end
