//
//  DetailPriceInfoViewController.m
//  Template_Joker
//
//  Created by Bella on 16/1/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "DetailPriceInfoViewController.h"

#import "OneLabelCell.h"
#import "TwoLabelCell.h"
#import "CustomCell.h"

#import "ConfirmNoteTableViewController.h"

#import "PriceDetail.h"

@interface DetailPriceInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 *  tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *customTableView;


/**
 *  暂时存储投保方案的数据
 */
@property(nonatomic,strong) NSArray *tempArray_Insurance;
@property(nonatomic,strong) NSDictionary *tempInfoAboutSelectedInsurance;


/**
 *  基本险种容器
 */
@property(nonatomic,strong) NSMutableArray *mutableArray_basicInsurance;

/**
 *  附加险种容器
 */
@property(nonatomic,strong) NSMutableArray *mutableArray_extraInsurance;

/**
 *  不计免赔险种容器
 */
@property(nonatomic,strong) NSMutableArray *mutableArray_notDutyInsurance;

/**
 *  临时存放PriceDetail实例
 */
@property(nonatomic,strong) PriceDetail *tempPriceDetail;

/**
 *  存储临时总价
 */
@property(nonatomic,assign) CGFloat tempTotalPrice;


/**
 *  carInfo临时存储
 */
@property(nonatomic,strong) CarInfo *tempCarInfo;


/**
 *  暂存图片索引值
 */
@property(nonatomic,assign) NSInteger tempImageIndex;


/**
 *  存储 比价后的保价金额
 */
@property(nonatomic,strong) NSMutableArray *mutableArray_AboutBasicInsuranceValue;


@property(nonatomic,strong) NSMutableArray *mutablArray_AboutExtraInsuranceValue;

@property(nonatomic,strong) NSMutableArray *mutableArray_AboutNotDutyInsuranceValue;

@end

/**
 *  cell重用标志符
 */
static NSString *customCellIdentifier = @"customCell";
static NSString *threeLabelCellIdentifier = @"threeLabelCell";
static NSString *colorCellIdentifier = @"colorCell";

@implementation DetailPriceInfoViewController

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.customTableView.dataSource = self;
    self.customTableView.delegate = self;
    
    self.customTableView.bounces = NO;
    
    //注册cell
    [self registCell];
    
    //tableView的自适应
    self.customTableView.rowHeight = UITableViewAutomaticDimension;
    self.customTableView.estimatedRowHeight = 44;
    
}

#pragma mark -- 注册cell
-(void)registCell{
    //注册
    [self.customTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:colorCellIdentifier];
    [self.customTableView registerNib:[UINib nibWithNibName:@"TwoLabelCell" bundle:nil]  forCellReuseIdentifier:threeLabelCellIdentifier];
    [self.customTableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:customCellIdentifier];
    
}

#pragma mark -- 加载数据
-(void)loadData{
    
    //基本险名称数组
    int indexOfBasicInsurance = 0;
    for (Insurance *item in [self.tempArray_Insurance objectAtIndex:0]) {
        
        if ([item.insuranceName isEqualToString:@"交强险/车船税"]) {
            //如果是 交强险/车船税 分成两部分
            Insurance *jqxItem = [Insurance new];
            jqxItem.insuranceName = @"交强险";
            jqxItem.insuranceValue = [self.mutableArray_AboutBasicInsuranceValue objectAtIndex:indexOfBasicInsurance]; //0
            indexOfBasicInsurance ++; // 1
            
            Insurance *ccsItem = [Insurance new];
            ccsItem.insuranceName = @"车船税";
            ccsItem.insuranceValue = [self.mutableArray_AboutBasicInsuranceValue objectAtIndex:1];
            
            if ([jqxItem.insuranceValue floatValue] != 0.00 ) {
                [self.mutableArray_basicInsurance addObject:jqxItem];
                
            }
            
            if ([ccsItem.insuranceValue floatValue] != 0.00) {
                [self.mutableArray_basicInsurance addObject:ccsItem];
            }
        }else{
            
            indexOfBasicInsurance ++; //2
            item.insuranceValue = [self.mutableArray_AboutBasicInsuranceValue objectAtIndex:indexOfBasicInsurance];
            
            
            if ([item.insuranceValue floatValue] != 0.00) {
                [self.mutableArray_basicInsurance addObject:item];
            }
        }
        
    }
    
    
    //附加险
    int indexOfExtraInsurance = 0;
    for (Insurance *item in [self.tempArray_Insurance objectAtIndex:1]) {
        
        item.insuranceValue = [self.mutablArray_AboutExtraInsuranceValue objectAtIndex:indexOfExtraInsurance];
        indexOfExtraInsurance ++;
        
        if ([item.insuranceValue floatValue] != 0.00) {
            [self.mutableArray_extraInsurance addObject:item];
        }
        
    }
    
    //不计免赔的数组
    int indexOfNotDutyInsurance = 0;
    for (NSArray *sonArray in self.tempArray_Insurance) {
        
#warning 这里的不计免赔的还得想一下
        //
        for (Insurance *item in sonArray) {
            
            if ([item.insuranceName isEqualToString:@"乘客责任险"]) {
                item.insuranceNotDutyValue = [self.mutableArray_AboutNotDutyInsuranceValue objectAtIndex:0];
            }
            
            if ([item.insuranceName isEqualToString:@"车辆损失险"]) {
                item.insuranceNotDutyValue = [self.mutableArray_AboutNotDutyInsuranceValue objectAtIndex:1];
            }
            
            if ([item.insuranceName isEqualToString:@"第三者责任险"]) {
                item.insuranceNotDutyValue = [self.mutableArray_AboutNotDutyInsuranceValue objectAtIndex:2];
                
            }
            
            if ([item.insuranceName isEqualToString:@"全车盗抢险"]) {
                item.insuranceNotDutyValue = [self.mutableArray_AboutNotDutyInsuranceValue objectAtIndex:3];
            }
            
            if ([item.insuranceName isEqualToString:@"司机责任险"]) {
                item.insuranceNotDutyValue = [self.mutableArray_AboutNotDutyInsuranceValue objectAtIndex:4];
            }
            
            if ([item.insuranceName isEqualToString:@"自燃损失险"]) {
                item.insuranceNotDutyValue = [self.mutableArray_AboutNotDutyInsuranceValue objectAtIndex:5];
            }
            indexOfNotDutyInsurance ++;
            if ([item.insuranceNotDutyValue floatValue] != 0.00) {
                [self.mutableArray_notDutyInsurance addObject:item];
            }
            
            
        }
    }
    
}

#pragma mark -- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (0 == section) {
        return 1;
    }else if(1 == section){
        if (0 == self.mutableArray_basicInsurance.count) {
            return 0;
        }else{
            return self.mutableArray_basicInsurance.count + 1;
        }
    }else if (2 == section){
        if (0 == self.mutableArray_extraInsurance.count) {
            return 0;
        }else{
            return self.mutableArray_extraInsurance.count + 1;
        }
    }else{
        if (0 == self.mutableArray_notDutyInsurance.count) {
            return 0;
        }else{
            return self.mutableArray_notDutyInsurance.count + 1;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.section) {
        
        CustomCell *customCell = [tableView dequeueReusableCellWithIdentifier:customCellIdentifier forIndexPath:indexPath];
        
        customCell.companyNameLabel.text = self.title;
        customCell.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",self.tempTotalPrice];
        customCell.accessoryType = UITableViewCellAccessoryNone;
        customCell.companyIconImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"test_b_%d",(int)(self.tempImageIndex + 1)]];
        
        
        return customCell;
    }else if(1 == indexPath.section){
        if (0 == indexPath.row) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:colorCellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = @"基本险";
            cell.textLabel.textColor = [UIColor blueColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            TwoLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:threeLabelCellIdentifier forIndexPath:indexPath];
            Insurance *insurance = self.mutableArray_basicInsurance[indexPath.row - 1];
            cell.insuranceNameLabel.text = insurance.insuranceName;
            if (insurance.InsurancePrice.length == 0) {
                cell.insurancePriceLabel.hidden = YES;
            }else{
                if ([insurance.insuranceName isEqualToString:@"乘客责任险"]) {
                    cell.insurancePriceLabel.text = [NSString stringWithFormat:@"%@/万/座",[self.infoAboutSelectedInsurance objectForKey:@"ckzrxValue"]];
                }
                if ([insurance.insuranceName isEqualToString:@"第三者责任险"]) {
                    cell.insurancePriceLabel.text = [NSString stringWithFormat:@"%@/万",[self.infoAboutSelectedInsurance objectForKey:@"dszzrxValue"]];
                }
                
                if ([insurance.insuranceName isEqualToString:@"司机责任险"]) {
                    cell.insurancePriceLabel.text = [NSString stringWithFormat:@"%@/万",[self.infoAboutSelectedInsurance objectForKey:@"sjzrxValue"]];
                }
            }
            if ([insurance.insuranceValue isEqualToString:@"0"] || [insurance.insuranceValue isEqualToString:@"0.00"]) {
                cell.insuranceValueLabel.hidden = YES;
            }else{
                cell.insuranceValueLabel.text = [NSString stringWithFormat:@"￥%@",insurance.insuranceValue];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if(2 == indexPath.section){
        if (0 == indexPath.row) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:colorCellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = @"附加险";
            cell.textLabel.textColor = [UIColor blueColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            TwoLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:threeLabelCellIdentifier forIndexPath:indexPath];
            Insurance *insurance = self.mutableArray_extraInsurance[indexPath.row - 1];
            cell.insuranceNameLabel.text = insurance.insuranceName;
            if (insurance.state.length == 0) {
                cell.insurancePriceLabel.hidden = YES;
            }else{
                if ([insurance.insuranceName isEqualToString:@"玻璃破碎险"]) {
                    cell.insurancePriceLabel.text = [NSString stringWithFormat:@"%@",[self.infoAboutSelectedInsurance objectForKey:@"blpsxValue"]];
                }else{
                    cell.insurancePriceLabel.text = [NSString stringWithFormat:@"%@/万",insurance.InsurancePrice];
                }
            }
            if ([insurance.insuranceValue isEqualToString:@"0"] || [insurance.insuranceValue isEqualToString:@"0.00"]) {
                cell.insuranceValueLabel.hidden = YES;
            }else{
                cell.insuranceValueLabel.text = [NSString stringWithFormat:@"￥%@",insurance.insuranceValue];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else{
        if (0 == indexPath.row) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:colorCellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = @"不计免赔";
            cell.textLabel.textColor = [UIColor blueColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            TwoLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:threeLabelCellIdentifier forIndexPath:indexPath];
            Insurance *insurance = self.mutableArray_notDutyInsurance[indexPath.row - 1];
            cell.insuranceNameLabel.text = insurance.insuranceName;
            if (insurance.InsurancePrice.length == 0) {
                cell.insurancePriceLabel.hidden = YES;
            }else{
                if ([insurance.insuranceName isEqualToString:@"乘客责任险"]) {
                    cell.insurancePriceLabel.text = [NSString stringWithFormat:@"%@/万/座",[self.infoAboutSelectedInsurance objectForKey:@"ckzrxValue"]];
                }
                if ([insurance.insuranceName isEqualToString:@"第三者责任险"]) {
                    cell.insurancePriceLabel.text = [NSString stringWithFormat:@"%@/万",[self.infoAboutSelectedInsurance objectForKey:@"dszzrxValue"]];
                }
                
                if ([insurance.insuranceName isEqualToString:@"司机责任险"]) {
                    cell.insurancePriceLabel.text = [NSString stringWithFormat:@"%@/万",[self.infoAboutSelectedInsurance objectForKey:@"sjzrxValue"]];
                }
                
                
            }
            
            if (insurance.state.length == 0) {
                cell.insurancePriceLabel.hidden = YES;
            }else{
                if ([insurance.insuranceName isEqualToString:@"玻璃破碎险"]) {
                    cell.insurancePriceLabel.text = [NSString stringWithFormat:@"%@",[self.infoAboutSelectedInsurance objectForKey:@"blpsxValue"]];
                }else{
                    cell.insurancePriceLabel.text = [NSString stringWithFormat:@"%@/万",insurance.InsurancePrice];
                }
            }
            
            if ([insurance.insuranceValue isEqualToString:@"0"] || [insurance.insuranceValue isEqualToString:@"0.00"]) {
                cell.insuranceValueLabel.hidden = YES;
            }else{
                cell.insuranceValueLabel.text = [NSString stringWithFormat:@"￥%@",insurance.insuranceNotDutyValue];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 跳转到 确认保单
- (IBAction)toCheckInsurance:(UIButton *)sender {
    
    ConfirmNoteTableViewController *confirmNoteTVC = [ConfirmNoteTableViewController new];
    
    confirmNoteTVC.view.backgroundColor = [UIColor whiteColor];
    
    confirmNoteTVC.companyName = self.title;
    confirmNoteTVC.priceDetail = self.tempPriceDetail;
    confirmNoteTVC.totalPrice = self.tempTotalPrice;
    confirmNoteTVC.carInfo = self.tempCarInfo;
    confirmNoteTVC.arrayAboutInsuranceInfo = self.tempArray_Insurance;
    
    pushToViewControllerAndTarget(self, ConfirmNoteTableViewController, confirmNoteTVC);
    
}


#pragma mark -- companyName的setter方法
-(void)setCompanyName:(NSString *)companyName{
    self.title = companyName;
}
-(void)setPriceDetail:(PriceDetail *)priceDetail{
    
    PriceDetail *item = priceDetail;
    
    //基本险
    //交强险
    [self.mutableArray_AboutBasicInsuranceValue addObject:item.jqx == nil ? @"0" : item.jqx];
    
    //车船税
    [self.mutableArray_AboutBasicInsuranceValue addObject:item.ccs == nil ? @"0" : item.ccs];
    
    //车辆损失险
    [self.mutableArray_AboutBasicInsuranceValue addObject:item.clssx == nil ? @"0" : item.clssx];
    
    //第三者责任险
    [self.mutableArray_AboutBasicInsuranceValue addObject:item.dszzrx == nil ? @"0" : item.dszzrx];
    
    //全车盗抢险
    [self.mutableArray_AboutBasicInsuranceValue addObject:item.qcdqx == nil ? @"0" : item.qcdqx];
    //司机责任险
    [self.mutableArray_AboutBasicInsuranceValue addObject:item.sjzrx == nil ? @"0" : item.sjzrx];
    //乘客责任险
    [self.mutableArray_AboutBasicInsuranceValue addObject:item.ckzrx == nil ? @"0" : item.ckzrx];
    
    
    //附加险
    //玻璃破碎险
    [self.mutablArray_AboutExtraInsuranceValue addObject:item.blpsx == nil ? @"0" : item.blpsx];
    //车身划痕险
    //    [self.mutablArray_AboutExtraInsuranceValue addObject:item.cshhx == nil ? @"0" : item.cshhx ];
    
    //自燃损失险
    [self.mutablArray_AboutExtraInsuranceValue addObject:item.zrssx == nil ? @"0" : item.zrssx];
    
    //涉水险
    [self.mutablArray_AboutExtraInsuranceValue addObject:item.ssx == nil ? @"0" : item.ssx];
    //指定专修厂
    [self.mutablArray_AboutExtraInsuranceValue addObject:item.zdzxc == nil ? @"0" : item.zdzxc];
    
    
    //不计免赔
    //乘客责任险
    [self.mutableArray_AboutNotDutyInsuranceValue addObject:item.ckzrx_b == nil ? @"0" : item.ckzrx_b];
    
    //车辆损失险
    [self.mutableArray_AboutNotDutyInsuranceValue addObject:item.clssx_b == nil ? @"0" : item.clssx_b];
    
    //第三者责任险
    [self.mutableArray_AboutNotDutyInsuranceValue addObject:item.dszzrx_b == nil ? @"0" : item.dszzrx_b];
    
    //全车盗抢险
    [self.mutableArray_AboutNotDutyInsuranceValue addObject:item.qcdqx_b == nil ? @"0" : item.qcdqx_b];
    
    //司机责任险
    [self.mutableArray_AboutNotDutyInsuranceValue addObject:item.sjzrx_b == nil ? @"0" : item.sjzrx_b];
    
    
    //自燃损失险
    [self.mutableArray_AboutNotDutyInsuranceValue addObject:item.zrssx_b == nil ? @"0" : item.zrssx_b];
    
    
    self.tempPriceDetail = priceDetail;
    
}
-(void)setTotalPrice:(CGFloat)totalPrice{
    
    self.tempTotalPrice = totalPrice;
}

-(void)setCarInfo:(CarInfo *)carInfo{
    self.tempCarInfo = carInfo;
}

-(void)setImageIndex:(NSInteger)imageIndex{
    self.tempImageIndex = imageIndex;
}

#pragma mark -- 接收来自投保方案传递过来的关于保价情况
-(void)setArrayOfInsurance:(NSArray *)arrayOfInsurance{
    
    self.tempArray_Insurance = arrayOfInsurance;
    
}

#pragma mark -- 懒加载
-(NSMutableArray *)mutableArray_basicInsurance{
    if (nil == _mutableArray_basicInsurance) {
        _mutableArray_basicInsurance = [NSMutableArray arrayWithCapacity:10];
    }
    return _mutableArray_basicInsurance;
}

-(NSMutableArray *)mutableArray_extraInsurance{
    if (nil == _mutableArray_extraInsurance) {
        _mutableArray_extraInsurance = [NSMutableArray arrayWithCapacity:10];
    }
    return _mutableArray_extraInsurance;
}

-(NSMutableArray *)mutableArray_notDutyInsurance{
    if (nil == _mutableArray_notDutyInsurance) {
        _mutableArray_notDutyInsurance = [NSMutableArray arrayWithCapacity:10];
    }
    return _mutableArray_notDutyInsurance;
}

-(NSMutableArray *)mutableArray_AboutBasicInsuranceValue{
    if (nil == _mutableArray_AboutBasicInsuranceValue) {
        _mutableArray_AboutBasicInsuranceValue = [NSMutableArray arrayWithCapacity:10];
    }
    return _mutableArray_AboutBasicInsuranceValue;
}

-(NSMutableArray *)mutablArray_AboutExtraInsuranceValue{
    if (nil == _mutablArray_AboutExtraInsuranceValue) {
        _mutablArray_AboutExtraInsuranceValue = [NSMutableArray arrayWithCapacity:10];
    }
    return _mutablArray_AboutExtraInsuranceValue;
}

-(NSMutableArray *)mutableArray_AboutNotDutyInsuranceValue{
    if (nil == _mutableArray_AboutNotDutyInsuranceValue) {
        _mutableArray_AboutNotDutyInsuranceValue = [NSMutableArray arrayWithCapacity:10];
    }
    return _mutableArray_AboutNotDutyInsuranceValue;
}

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //加载数据
    [self loadData];
}

@end
