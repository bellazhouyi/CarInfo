//
//  ResultTableViewController.m
//  Template_Joker
//
//  Created by Bella on 16/1/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ResultTableViewController.h"

#import "CustomCell.h"
#import "PriceDetail.h"

#import "DetailPriceInfoViewController.h"

#import "DGAaimaView.h"

#import "GiFHUD.h"

@interface ResultTableViewController ()

/**
 *  用于存放险种公司名称的容器
 */
@property(nonatomic,strong) NSMutableArray *mutableArray_companyName;

/**
 *  存放总报价结果的容器
 */
@property(nonatomic,strong) NSMutableArray *mutableArray_totalPrice;

/**
 *  存放PriceDetail实例的容器
 */
@property(nonatomic,strong) NSMutableArray *mutableArray_priceDetailInstance;

/**
 *  carInfo临时存储
 */
@property(nonatomic,strong) CarInfo *tempCarInfo;

/**
 *  暂时存储保价方案的数组
 */
@property(nonatomic,strong) NSArray *tempArrayInsurance;


/**
 *  暂存保价信息
 */
@property(nonatomic,strong) NSDictionary *tempInfoAboutSelectedInsurance;


/**
 *  加载中的 动画显示
 */
@property(nonatomic,strong) GSIndeterminateProgressView *progressView;

@end

/**
 *  cell重用标识符
 */
static NSString *customCellIdentifier = @"customCell";

@implementation ResultTableViewController

#pragma mark - 视图加载完毕
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"报价结果";
    
    //tableView的自适应
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
}

#pragma mark - 接收到内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mutableArray_companyName.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *customCell = [tableView dequeueReusableCellWithIdentifier:customCellIdentifier forIndexPath:indexPath];
    
    customCell.companyNameLabel.text = self.mutableArray_companyName[indexPath.section];
    
    customCell.totalPriceLabel.text = [NSString stringWithFormat:@"￥%@",self.mutableArray_totalPrice[indexPath.section]];
    
    customCell.companyIconImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"test_b_%d",((int)indexPath.section + 1)]];
    
    return customCell;
}

#pragma mark - 跳转到报价详情页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailPriceInfoViewController *detailPriceInfoVC = [[DetailPriceInfoViewController alloc]initWithNibName:@"DetailPriceInfoViewController" bundle:nil];
    
    detailPriceInfoVC.arrayOfInsurance = self.tempArrayInsurance;
    detailPriceInfoVC.infoAboutSelectedInsurance = self.tempInfoAboutSelectedInsurance;
    
    detailPriceInfoVC.priceDetail = self.mutableArray_priceDetailInstance[indexPath.section];
    
    detailPriceInfoVC.view.backgroundColor = [UIColor whiteColor];
    
    detailPriceInfoVC.companyName = self.mutableArray_companyName[indexPath.section];
    
    detailPriceInfoVC.totalPrice = [self.mutableArray_totalPrice[indexPath.section] floatValue];
    detailPriceInfoVC.carInfo = self.tempCarInfo;
   
    
    detailPriceInfoVC.imageIndex = indexPath.section;
    
    
    pushToViewControllerAndTarget(self, DetailPriceInfoViewController, detailPriceInfoVC);
    
}


#pragma mark - carInfo的setter方法
-(void)setCarInfo:(CarInfo *)carInfo{
    self.tempCarInfo = carInfo;
}

#pragma mark - 把投保方案传递过来的数据暂时存储
-(void)setArrayInsuranceData:(NSArray *)arrayInsuranceData{
    self.tempArrayInsurance = arrayInsuranceData;
}

-(void)setInfoAboutSelectedInsurance:(NSDictionary *)infoAboutSelectedInsurance{
    self.tempInfoAboutSelectedInsurance = infoAboutSelectedInsurance;
}

#pragma mark - mutableArray_companyName 懒加载
-(NSMutableArray *)mutableArray_companyName{
    if (nil == _mutableArray_companyName) {
        _mutableArray_companyName = [NSMutableArray arrayWithCapacity:10];
    }
    return _mutableArray_companyName;
}

-(NSMutableArray *)mutableArray_totalPrice{
    if (nil == _mutableArray_totalPrice) {
        _mutableArray_totalPrice = [NSMutableArray arrayWithCapacity:10];
    }
    return _mutableArray_totalPrice;
}

-(NSMutableArray *)mutableArray_priceDetailInstance{
    if (nil == _mutableArray_priceDetailInstance) {
        _mutableArray_priceDetailInstance = [NSMutableArray arrayWithCapacity:10];
    }
    return _mutableArray_priceDetailInstance;
}

#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     UINavigationBar *navigationBar = self.navigationController.navigationBar;
    //加载动画
    GSIndeterminateProgressView *progressView = [[GSIndeterminateProgressView alloc]initWithFrame:CGRectMake(0, navigationBar.bounds.size.height - 2, navigationBar.bounds.size.width, 2)];
    
    progressView.progressTintColor = [UIColor grayColor];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [navigationBar addSubview:progressView];
    
    
    [progressView startAnimating];
    self.progressView = progressView;
    
    //加载提示框
    [GiFHUD showWithMessage:@"开始为您报价,请稍等"];
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:customCellIdentifier];
    
    HTTPManager *manager = [HTTPManager sharedHTPPManager];
    
    __weak typeof(self) temp = self;
    
    //解析得到的比价结果
    manager.passValue = ^(NSArray *array){
        if (0 == array.count) {
            NSLog(@"不好意思，空数组");
        }else{
            
            for (NSDictionary *dict in array) {
                PriceDetail *item = [PriceDetail new];
                [item setValuesForKeysWithDictionary:dict];
                [temp.mutableArray_companyName addObject:item.company_name];
                
                //基本险
                //交强险
                CGFloat jqxValue = [item.jqx floatValue];
                
                //车船税
                CGFloat ccsValue = [item.ccs floatValue];
                
                //车辆损失险
                CGFloat clssxValue = [item.clssx floatValue];
                
                //第三者责任险
                CGFloat dszzrxValue = [item.dszzrx floatValue];
                
                //全车盗抢险
                CGFloat qcdqxValue = [item.qcdqx floatValue];
                
                //司机责任险
                CGFloat sjzrValue = [item.sjzrx floatValue];
                
                //乘客责任险
                CGFloat ckzrValue = [item.ckzrx floatValue];
                
                
                
                //附加险
                //玻璃破碎险
                CGFloat blpsValue = [item.blpsx floatValue];
                
                //自燃损失险
                CGFloat zrssValue = [item.zrssx floatValue];
                
                //车身划痕险
                //                CGFloat cshhValue = [item.cshhx floatValue];
                
                //涉水险
                CGFloat ssValue = [item.ssx floatValue];
                
                //指定专修厂
                CGFloat zdzxcValue = [item.zdzxc floatValue];
                
                
                
                //不计免赔
                //车辆损失险
                CGFloat clssx_bValue = [item.clssx_b floatValue];
                
                
                //第三者责任险
                CGFloat dszzrx_bValue = [item.dszzrx_b floatValue];
                
                
                //全车盗抢险
                CGFloat qcdqx_bValue = [item.qcdqx_b floatValue];
                
                
                //司机责任险
                CGFloat sjzrx_bValue = [item.sjzrx_b floatValue];
                
                
                //乘客责任险
                CGFloat ckzrx_bValue = [item.ckzrx_b floatValue];
                
                
                //自燃损失险
                CGFloat zrssx_bValue = [item.zrssx_b floatValue];
                
                
                //报价总金额
                CGFloat total = jqxValue + ccsValue + clssxValue + zrssValue + dszzrxValue + qcdqxValue + sjzrValue + ckzrValue + blpsValue + ssValue  + zdzxcValue +clssx_bValue + dszzrx_bValue + qcdqx_bValue + sjzrx_bValue + ckzrx_bValue + zrssx_bValue;
                
                [temp.mutableArray_totalPrice addObject:[NSString stringWithFormat:@"%.2f",total]
                 ];
                
                [temp.mutableArray_priceDetailInstance addObject:item];
            }
            [temp.tableView reloadData];
            //移除加载动画
            [progressView stopAnimating];
            [GiFHUD dismissBiggerFrame];
            self.tableView.alpha = 1;
        }
    };
    
    //比价没有结果的时候
    manager.passNullMsg_GetPolicyPrice = ^(NSString *msg){
        
        //移除加载动画
        [progressView stopAnimating];
        [GiFHUD dismissBiggerFrame];
        self.tableView.alpha = 1;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //返回到上一级页面--也即投保方案页面
            [temp.navigationController popViewControllerAnimated:YES];
        }];
        
        [alertController addAction:confirm];
        
        //弹出提示框
        [self presentViewController:alertController animated:YES completion:nil];
    };
    
    
    //服务器原因,比价没得结果
    manager.passError = ^(){
        //移除加载动画
        [progressView stopAnimating];
        [GiFHUD dismissBiggerFrame];
        self.tableView.alpha = 1;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"不好意思,网络繁忙,请稍后再试." message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //返回到上一级页面--也即投保方案页面
            [temp.navigationController popViewControllerAnimated:YES];
        }];
        
        [alertController addAction:confirm];
        
        //弹出提示框
        [self presentViewController:alertController animated:YES completion:nil];
    };
}

#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [GiFHUD dismissBiggerFrame];
    [_progressView stopAnimating];
}

@end
